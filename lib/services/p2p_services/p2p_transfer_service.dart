import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:p2lantransfer/models/p2p_models.dart';
// Import enum DataTransferKey để dùng cho metadata
import 'package:p2lantransfer/services/app_logger.dart';
import 'package:p2lantransfer/services/isar_service.dart';
import 'package:p2lantransfer/services/p2p_services/p2p_chat_service.dart';
import 'package:p2lantransfer/services/p2p_services/p2p_network_service.dart';
import 'package:p2lantransfer/services/p2p_services/p2p_notification_service.dart';
import 'package:p2lantransfer/services/p2p_services/p2p_settings_adapter.dart';
import 'package:p2lantransfer/services/performance_optimizer_service.dart'; // 🚀 Thêm import
import 'package:p2lantransfer/utils/isar_utils.dart';
import 'package:p2lantransfer/utils/url_utils.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:p2lantransfer/services/encryption_service.dart';
import 'package:p2lantransfer/services/crypto_service.dart';

/// Validation result for file transfer request
class _FileTransferValidationResult {
  final bool isValid;
  final FileTransferRejectReason? rejectReason;
  final String? rejectMessage;

  _FileTransferValidationResult.valid()
      : isValid = true,
        rejectReason = null,
        rejectMessage = null;
  _FileTransferValidationResult.invalid(this.rejectReason, this.rejectMessage)
      : isValid = false;
}

/// P2P Transfer Service - Handles file transfer, data chunks, and concurrency control
/// Extracted from monolithic P2PService for better modularity
class P2PTransferService extends ChangeNotifier {
  final P2PNetworkService _networkService;
  late final P2PChatService _chatService = P2PChatService(IsarService.isar);

  // Transfer settings
  P2PDataTransferSettings? _transferSettings;

  // File transfer request management
  final List<FileTransferRequest> _pendingFileTransferRequests = [];

  // Callbacks
  Function(FileTransferRequest)? _onNewFileTransferRequest;

  // File transfer responses pending timeout
  final Map<String, Timer> _fileTransferResponseTimers = {};
  final Map<String, Timer> _fileTransferRequestTimers = {};

  // Store download paths for batches (with date folders)
  final Map<String, String> _batchDownloadPaths = {};

  // Store total file counts for each batch to ensure proper cleanup
  final Map<String, int> _batchFileCounts = {};

  // Map from sender userId to current active batchId for incoming transfers
  final Map<String, String> _activeBatchIdsByUser = {};

  // Data transfer management
  final Map<String, DataTransferTask> _activeTransfers = {};
  final Map<String, Isolate> _transferIsolates = {};
  final Map<String, ReceivePort> _transferPorts = {};

  // File receiving management
  final Map<String, List<Uint8List>> _incomingFileChunks = {};
  // Map taskId -> temporary file path for large file chunks
  final Map<String, String> _tempFileChunks = {};
  // Map taskId -> messageId (P2PCMessage.id) for received files
  final Map<String, int> _receivedFileMessageIds = {};

  // Task creation synchronization to prevent race conditions
  final Map<String, Completer<DataTransferTask?>> _taskCreationLocks = {};

  // Buffer chunks that arrive before task is created
  final Map<String, List<Map<String, dynamic>>> _pendingChunks = {};

  // File picker cache management
  static final Set<String> _activeFileTransferBatches = <String>{};
  static DateTime? _lastFilePickerCleanup;
  static const Duration _cleanupCooldown = Duration(minutes: 2);

  // Encryption session keys management
  final Map<String, Uint8List> _sessionKeys = {};

  /// Get session key for a user. Returns null if not found.
  Uint8List? _getSessionKey(String userId) {
    return _sessionKeys[userId];
  }

  /// Get or generate session key for a user.
  Uint8List _getOrCreateSessionKey(String userId) {
    return _sessionKeys[userId] ??= EncryptionService.generateKey();
  }

  /// Clear session key for a user
  void clearSessionKey(String userId) {
    _sessionKeys.remove(userId);
    logInfo('P2PTransferService: Session key cleared for user $userId');
  }

  /// Clear all session keys
  void clearAllSessionKeys() {
    _sessionKeys.clear();
    logInfo('P2PTransferService: All session keys cleared');
  }

  // Getters
  P2PDataTransferSettings? get transferSettings => _transferSettings;
  List<FileTransferRequest> get pendingFileTransferRequests =>
      List.unmodifiable(_pendingFileTransferRequests);
  List<DataTransferTask> get activeTransfers =>
      _activeTransfers.values.toList();

  P2PTransferService(this._networkService) {
    // Set up message handler for incoming TCP messages
    _networkService.setMessageHandler(_handleTcpMessage);
  }

  /// Initialize transfer service
  Future<void> initialize() async {
    // Load transfer settings and active transfers
    await _loadTransferSettings();
    await _loadActiveTransfers();
    await _loadPendingFileTransferRequests();

    // Initialize Android path if needed
    await _initializeAndroidPath();

    // Schedule cleanup of expired messages in background
    _scheduleMessageCleanup();

    logInfo('P2PTransferService: Initialized successfully');
  }

  /// Schedule message cleanup to run in background
  void _scheduleMessageCleanup() {
    Future.microtask(() async {
      try {
        // Wait a bit to ensure all services are fully initialized
        await Future.delayed(const Duration(seconds: 3));
        await _chatService.cleanupExpiredMessages();
      } catch (e) {
        logError(
            'P2PTransferService: Error during scheduled message cleanup: $e');
      }
    });
  }

  /// Public method to trigger message cleanup manually
  Future<void> cleanupExpiredMessages() async {
    try {
      await _chatService.cleanupExpiredMessages();
    } catch (e) {
      logError('P2PTransferService: Error during manual message cleanup: $e');
    }
  }

  /// Send multiple files to paired user
  Future<bool> sendMultipleFiles(
      List<String> filePaths, P2PUser targetUser, bool transferOnly) async {
    try {
      if (!targetUser.isPaired) {
        throw Exception('User is not paired');
      }

      if (filePaths.isEmpty) {
        throw Exception('No files selected');
      }

      // Check all files exist and prepare file info list
      final files = <FileTransferInfo>[];
      int totalSize = 0;

      for (final filePath in filePaths) {
        final file = File(filePath);
        if (!await file.exists()) {
          throw Exception('File does not exist: $filePath');
        }

        final fileSize = await file.length();
        final fileName = file.path.split(Platform.pathSeparator).last;

        files.add(FileTransferInfo(fileName: fileName, fileSize: fileSize));
        totalSize += fileSize;
      }

      // Create file transfer request
      final request = FileTransferRequest(
        requestId: 'ftr_${const Uuid().v4()}',
        batchId: const Uuid().v4(),
        fromUserId: _networkService.currentUser!.id,
        fromUserName: _networkService.currentUser!.displayName,
        files: files,
        totalSize: totalSize,
        protocol: _transferSettings?.sendProtocol ?? 'tcp',
        maxChunkSize: _transferSettings?.maxChunkSize,
        requestTime: DateTime.now(),
        useEncryption: _transferSettings?.enableEncryption ?? false,
      );

      // Create transfer tasks in waiting state
      for (int i = 0; i < filePaths.length; i++) {
        final filePath = filePaths[i];
        final fileInfo = files[i];

        // Prepare task data based on transfer type
        Map<String, dynamic>? taskData;
        if (!transferOnly) {
          // For chat messages: include syncFilePath to update chat message with file path
          taskData = {DataTransferKey.syncFilePath.name: 1};
        }
        // For regular file transfers (transferOnly = true): no special data needed

        final task = DataTransferTask.create(
            fileName: fileInfo.fileName,
            filePath: filePath,
            fileSize: fileInfo.fileSize,
            targetUserId: targetUser.id,
            targetUserName: targetUser.displayName,
            status: DataTransferStatus.waitingForApproval,
            isOutgoing: true,
            batchId: request.batchId,
            data: taskData);
        _activeTransfers[task.id] = task;
        logDebug(
            'P2PTransferService: Created task ${task.id} for file ${fileInfo.fileName} '
            'transferOnly=$transferOnly with data: ${task.data.toString()}');
      }

      // Send file transfer request
      final message = {
        'type': P2PMessageTypes.fileTransferRequest,
        'fromUserId': _networkService.currentUser!.id,
        'toUserId': targetUser.id,
        'data': request.toJson(),
      };

      final success =
          await _networkService.sendMessageToUser(targetUser, message);
      if (success) {
        // Register active file transfer batch
        _registerActiveFileTransferBatch(request.batchId);

        // Set up response timeout timer
        _fileTransferResponseTimers[request.requestId] = Timer(
          const Duration(seconds: 65),
          () => _handleFileTransferTimeout(request.requestId),
        );

        logInfo(
            'P2PTransferService: Sent file transfer request for ${files.length} files');
      } else {
        // Clean up tasks if request failed
        _cancelTasksByBatchId(request.batchId);
        cleanupFilePickerCacheIfSafe();
      }

      notifyListeners();
      return success;
    } catch (e) {
      logError('P2PTransferService: Failed to send file transfer request: $e');
      return false;
    }
  }

  /// Cancel data transfer
  Future<bool> cancelDataTransfer(String taskId) async {
    try {
      final task = _activeTransfers[taskId];
      if (task == null) return false;

      // Only cancel transfers that are actually in progress
      if (task.status != DataTransferStatus.transferring) {
        logInfo(
            'P2PTransferService: Skipping cancellation for task ${task.id} with status ${task.status}');
        return false;
      }

      // Stop isolate if running
      final isolate = _transferIsolates[taskId];
      if (isolate != null) {
        isolate.kill(priority: Isolate.immediate);
        _transferIsolates.remove(taskId);
        _transferPorts[taskId]?.close();
        _transferPorts.remove(taskId);
      }

      task.status = DataTransferStatus.cancelled;
      task.errorMessage = 'Cancelled by user';

      // Auto-cleanup cancelled task after a delay
      if (_transferSettings?.autoCleanupCancelledTasks == true) {
        Timer(
            Duration(seconds: _transferSettings?.autoCleanupDelaySeconds ?? 3),
            () async {
          // logDebug(
          //     '>> Call auto cleanup from autoCleanupCancelledTasks == true for failed task: ${task.id}');

          await _autoCleanupTask(taskId, 'cancelled');
        });
      }

      // Notify other user
      final targetUser = _getTargetUser(task.targetUserId);
      if (targetUser != null && targetUser.isOnline) {
        final message = {
          'type': P2PMessageTypes.dataTransferCancel,
          'fromUserId': _networkService.currentUser!.id,
          'toUserId': targetUser.id,
          'data': {'taskId': taskId},
        };
        await _networkService.sendMessageToUser(targetUser, message);
      }

      // Clean up and start next queued transfer
      _cleanupTransfer(taskId);

      notifyListeners();
      return true;
    } catch (e) {
      logError('P2PTransferService: Failed to cancel data transfer: $e');
      return false;
    }
  }

  /// Respond to file transfer request
  Future<bool> respondToFileTransferRequest(
      String requestId, bool accept, String? rejectMessage) async {
    try {
      final request = _pendingFileTransferRequests
          .firstWhere((r) => r.requestId == requestId);

      // Cancel timeout timer
      _fileTransferRequestTimers[requestId]?.cancel();
      _fileTransferRequestTimers.remove(requestId);

      // Dismiss notification
      await _safeNotificationCall(() => P2PNotificationService.instance
          .cancelNotification(request.requestId.hashCode));

      if (accept) {
        await _acceptFileTransferRequest(request);
      } else {
        await _sendFileTransferResponse(
            request,
            false,
            FileTransferRejectReason.userRejected,
            rejectMessage ?? 'Rejected by user');

        // Remove from pending list
        _pendingFileTransferRequests
            .removeWhere((r) => r.requestId == requestId);
        await _removeFileTransferRequest(request.requestId);
      }

      notifyListeners();
      return true;
    } catch (e) {
      logError(
          'P2PTransferService: Failed to respond to file transfer request: $e');
      return false;
    }
  }

  /// Update transfer settings
  Future<bool> updateTransferSettings(P2PDataTransferSettings settings) async {
    try {
      await P2PSettingsAdapter.updateSettings(settings);
      _transferSettings = settings;

      logInfo('P2PTransferService: Updated transfer settings');
      return true;
    } catch (e) {
      logError('P2PTransferService: Failed to update transfer settings: $e');
      return false;
    }
  }

  /// Reload transfer settings from storage
  Future<void> reloadTransferSettings() async {
    await _loadTransferSettings();
    logInfo('P2PTransferService: Transfer settings reloaded');
  }

  /// Clear a transfer from the list
  void clearTransfer(String taskId) {
    final task = _activeTransfers.remove(taskId);
    if (task != null) {
      // Clean up temp file if exists
      final tempFilePath = _tempFileChunks.remove(taskId);
      if (tempFilePath != null) {
        _cleanupTempFile(tempFilePath);
      }
      logInfo('P2PTransferService: Cleared transfer: ${task.fileName}');
      notifyListeners();
    }
  }

  /// Clear a transfer and optionally delete the downloaded file
  Future<bool> clearTransferWithFile(String taskId, bool deleteFile) async {
    final task = _activeTransfers.remove(taskId);
    if (task == null) {
      logWarning(
          'P2PTransferService: Task $taskId not found for clear operation');
      return false;
    }

    // Clear file chunks for this task
    _incomingFileChunks.remove(taskId);

    // Clean up temp file if exists
    final tempFilePath = _tempFileChunks.remove(taskId);
    if (tempFilePath != null) {
      _cleanupTempFile(tempFilePath);
    }

    if (deleteFile && !task.isOutgoing && task.savePath != null) {
      try {
        final file = File(task.savePath!);
        if (await file.exists()) {
          await file.delete();
          logInfo(
              'P2PTransferService: Successfully deleted file: ${task.savePath}');
        }
      } catch (e) {
        logError(
            'P2PTransferService: Failed to delete file ${task.savePath}: $e');
      }
    }

    // Trigger memory cleanup
    Future.microtask(() => _cleanupMemory());

    notifyListeners();
    return true;
  }

  /// Set callback for new file transfer requests
  void setNewFileTransferRequestCallback(
      Function(FileTransferRequest)? callback) {
    _onNewFileTransferRequest = callback;
  }

  /// Cancel all active transfers
  Future<void> cancelAllTransfers() async {
    for (final taskId in _activeTransfers.keys.toList()) {
      final task = _activeTransfers[taskId];
      if (task != null && task.status == DataTransferStatus.transferring) {
        task.status = DataTransferStatus.cancelled;
        task.errorMessage = 'Transfer cancelled during network stop';
        _cleanupTransfer(taskId);
      }
    }
  }

  /// Cleanup file picker cache if safe
  Future<void> cleanupFilePickerCacheIfSafe() async {
    try {
      final now = DateTime.now();
      if (_lastFilePickerCleanup != null &&
          now.difference(_lastFilePickerCleanup!) < _cleanupCooldown) {
        return;
      }

      final hasActiveOutgoingTransfers = _activeTransfers.values.any((task) =>
          task.isOutgoing &&
          (task.status == DataTransferStatus.transferring ||
              task.status == DataTransferStatus.waitingForApproval ||
              task.status == DataTransferStatus.pending));

      if (!hasActiveOutgoingTransfers && _activeFileTransferBatches.isEmpty) {
        await FilePicker.platform.clearTemporaryFiles();
        _lastFilePickerCleanup = now;
        logInfo('P2PTransferService: Safely cleaned up file picker cache');
      }
    } catch (e) {
      logWarning('P2PTransferService: Failed to cleanup file picker cache: $e');
    }
  }

  // Private methods

  void _handleTcpMessage(Socket socket, Uint8List messageBytes) {
    try {
      final jsonString = utf8.decode(messageBytes);
      final messageData = jsonDecode(jsonString);
      final message = P2PMessage.fromJson(messageData);

      // Associate socket with user ID
      if (!_networkService.connectedSockets.containsKey(message.fromUserId)) {
        _networkService.associateSocketWithUser(message.fromUserId, socket);
      }

      switch (message.type) {
        case P2PMessageTypes.dataChunk:
          _handleDataChunk(message);
          break;
        case P2PMessageTypes.dataTransferCancel:
          _handleDataTransferCancel(message);
          break;
        case P2PMessageTypes.fileTransferRequest:
          _handleFileTransferRequest(message);
          break;
        case P2PMessageTypes.fileTransferResponse:
          _handleFileTransferResponse(message);
          break;
        case P2PMessageTypes.sendChatMessage:
          _networkService.handleIncomingChatMessage(message.data);
          break;
        case P2PMessageTypes.chatRequestFileBackward:
          _handleFileCheckAndTransferBackwardRequest(message);
          break;
        case P2PMessageTypes.chatRequestFileLost:
          _handleChatResponseLost(message);
          break;
        default:
          // Forward other message types to discovery service via callback
          if (_onOtherMessageReceived != null) {
            _onOtherMessageReceived!(message, socket);
          }
          break;
      }
    } catch (e) {
      logError('P2PTransferService: Failed to process TCP message: $e');
    }
  }

  Future<void> _handleFileTransferRequest(P2PMessage message) async {
    try {
      final request = FileTransferRequest.fromJson(message.data);
      request.receivedTime = DateTime.now();

      logInfo(
          'P2PTransferService: Received file transfer request from ${request.fromUserName} '
          '(Encryption: ${request.useEncryption ? "enabled" : "disabled"})');

      // If sender uses encryption, generate/get session key
      if (request.useEncryption) {
        _getOrCreateSessionKey(request.fromUserId);
        logInfo(
            'P2PTransferService: Session key prepared for encrypted transfer');
      }

      // Validate sender is paired
      final fromUser = _getTargetUser(request.fromUserId);
      if (fromUser == null || !fromUser.isPaired) {
        await _sendFileTransferResponse(request, false,
            FileTransferRejectReason.unknown, 'User not paired');
        return;
      }

      // Validate request
      final validationResult =
          await _validateFileTransferRequest(request, fromUser);
      if (!validationResult.isValid) {
        await _sendFileTransferResponse(request, false,
            validationResult.rejectReason!, validationResult.rejectMessage!);
        await _safeNotificationCall(() => P2PNotificationService.instance
            .cancelNotification(request.requestId.hashCode));
        return;
      }

      // Auto-accept for trusted users
      if (fromUser.isTrusted) {
        logInfo(
            'P2PTransferService: Auto-accepting from trusted user: ${fromUser.displayName}');
        _fileTransferRequestTimers[request.requestId]?.cancel();
        _fileTransferRequestTimers.remove(request.requestId);
        await _acceptFileTransferRequest(request);
        return;
      }

      // Show notification for non-trusted users
      await _safeNotificationCall(
          () => P2PNotificationService.instance.showFileTransferRequest(
                request: request,
                enableActions: true,
              ));

      // Add to pending requests
      _pendingFileTransferRequests.add(request);
      await _saveFileTransferRequest(request);
      notifyListeners();

      // Trigger callback
      if (_onNewFileTransferRequest != null) {
        _onNewFileTransferRequest!(request);
      }

      // Set timeout timer
      _fileTransferRequestTimers[request.requestId] =
          Timer(const Duration(seconds: 60), () {
        _handleFileTransferRequestTimeout(request.requestId);
      });
    } catch (e) {
      logError(
          'P2PTransferService: Failed to handle file transfer request: $e');
    }
  }

  Future<void> _handleFileTransferResponse(P2PMessage message) async {
    try {
      final response = FileTransferResponse.fromJson(message.data);

      // Cancel timeout timer
      _fileTransferResponseTimers[response.requestId]?.cancel();
      _fileTransferResponseTimers.remove(response.requestId);

      // Find tasks for this batch
      final batchTasks = _activeTransfers.values
          .where((task) => task.batchId == response.batchId && task.isOutgoing)
          .toList();

      if (response.accepted) {
        logInfo(
            'P2PTransferService: File transfer accepted for batch ${response.batchId}');

        // Store the received session key if available
        if (response.sessionKeyBase64 != null) {
          final sessionKey = base64Decode(response.sessionKeyBase64!);
          _sessionKeys[message.fromUserId] = sessionKey;
          logInfo(
              'P2PTransferService: Received and stored session key from user ${message.fromUserId}');
        }

        await _startTransfersWithConcurrencyLimit(batchTasks);
      } else {
        logInfo(
            'P2PTransferService: File transfer rejected: ${response.rejectMessage}');
        for (final task in batchTasks) {
          task.status = DataTransferStatus.rejected;
          task.errorMessage = response.rejectMessage ?? 'Transfer rejected';
          _cleanupTransfer(task.id);
        }
      }

      notifyListeners();
    } catch (e) {
      logError(
          'P2PTransferService: Failed to handle file transfer response: $e');
    }
  }

  Future<void> _handleDataChunk(P2PMessage message) async {
    final data = message.data;
    final taskId = data['taskId'] as String?;
    final isLast = data['isLast'] as bool? ?? false;

    if (taskId == null) {
      logError('P2PTransferService: Invalid data chunk - no taskId');
      return;
    }

    try {
      Uint8List? chunkData;

      // Handle encrypted data
      if (data['enc'] == 'gcm') {
        // AES-GCM encryption (backward compatibility)
        final ctBase64 = data['ct'] as String?;
        final ivBase64 = data['iv'] as String?;
        final tagBase64 = data['tag'] as String?;

        if (ctBase64 != null && ivBase64 != null && tagBase64 != null) {
          final sessionKey = _getOrCreateSessionKey(message.fromUserId);
          final encryptedMap = {
            'ciphertext': base64Decode(ctBase64),
            'iv': base64Decode(ivBase64),
            'tag': base64Decode(tagBase64),
          };
          chunkData = EncryptionService.decryptGCM(encryptedMap, sessionKey);
          if (chunkData == null) {
            logError(
                'P2PTransferService: GCM decryption failed for task $taskId. Might be a wrong key or tampered data.');
            return;
          }
        }
      } else if (data['enc'] == 'aes-gcm' ||
          data['enc'] == 'chacha20-poly1305') {
        // New encryption system using CryptoService
        final encryptionType = data['enc'] == 'aes-gcm'
            ? EncryptionType.aesGcm
            : EncryptionType.chaCha20;

        final sessionKey = _getOrCreateSessionKey(message.fromUserId);
        final encryptedData = <String, dynamic>{};

        if (encryptionType == EncryptionType.aesGcm) {
          encryptedData['ciphertext'] = base64Decode(data['ct'] as String);
          encryptedData['iv'] = base64Decode(data['iv'] as String);
          encryptedData['tag'] = base64Decode(data['tag'] as String);
        } else {
          encryptedData['ciphertext'] = base64Decode(data['ct'] as String);
          encryptedData['nonce'] = base64Decode(data['nonce'] as String);
          encryptedData['tag'] = base64Decode(data['tag'] as String);
        }

        chunkData = await CryptoService.decrypt(
            encryptedData, sessionKey, encryptionType);
        if (chunkData == null) {
          logError(
              'P2PTransferService: ${encryptionType.name} decryption failed for task $taskId. Might be a wrong key or tampered data.');
          return;
        }
      } else {
        // Fallback for unencrypted data (e.g., from older clients)
        final dataBase64 = data['data'] as String?;
        if (dataBase64 != null) {
          chunkData = base64Decode(dataBase64);
        }
      }

      if (chunkData == null) {
        logError(
            'P2PTransferService: Failed to get chunk data for task $taskId');
        return;
      }

      DataTransferTask? task = await _getOrCreateTask(taskId, message, data);
      if (task == null) {
        logError(
            'P2PTransferService: Could not get or create task for $taskId');
        _pendingChunks.putIfAbsent(taskId, () => []);
        _pendingChunks[taskId]!.add({
          'chunkData': chunkData,
          'isLast': isLast,
          'data': data,
        });
        return;
      }

      // Initialize chunks list
      _incomingFileChunks.putIfAbsent(taskId, () => []);
      _incomingFileChunks[taskId]!.add(chunkData);

      // For large files, periodically flush chunks to temporary file to reduce memory usage
      const int maxChunksInMemory = 50; // Limit chunks in memory
      if (_incomingFileChunks[taskId]!.length >= maxChunksInMemory) {
        await _flushChunksToTempFile(taskId);
      }

      // Update progress
      task.transferredBytes += chunkData.length;
      if (task.status != DataTransferStatus.transferring) {
        task.status = DataTransferStatus.transferring;
        task.startedAt ??= DateTime.now();
      }

      // Cap transferredBytes to fileSize to prevent overflow
      if (task.transferredBytes > task.fileSize) {
        logWarning(
            'P2PTransferService: Transfer bytes overflow for task $taskId. Capping to fileSize.');
        task.transferredBytes = task.fileSize;
      }

      final progressPercent = (task.fileSize > 0)
          ? ((task.transferredBytes / task.fileSize) * 100)
              .round()
              .clamp(0, 100)
          : 0;

      // Show progress notification
      if (progressPercent == 0 ||
          progressPercent % 5 == 0 ||
          progressPercent > 90 ||
          isLast) {
        String? speed;
        String? eta;
        if (task.startedAt != null &&
            progressPercent > 0 &&
            task.transferredBytes > 0) {
          final elapsed = DateTime.now().difference(task.startedAt!);
          if (elapsed.inSeconds > 0) {
            final speedBps = task.transferredBytes / elapsed.inSeconds;
            speed = _formatSpeed(speedBps);
            if (speedBps > 0) {
              final remainingBytes = task.fileSize - task.transferredBytes;
              if (remainingBytes > 0) {
                final etaSeconds = (remainingBytes / speedBps).round();
                eta = _formatEta(etaSeconds);
              }
            }
          }
        }

        await _safeNotificationCall(
            () => P2PNotificationService.instance.showFileTransferStatus(
                  task: task,
                  progress: progressPercent,
                  speed: speed,
                  eta: eta,
                ));
      }

      // Notify UI every 10 chunks to reduce overhead
      if (_incomingFileChunks[taskId]!.length % 10 == 0 || isLast) {
        notifyListeners();
      }

      // If this is the last chunk, assemble the file
      if (isLast) {
        logInfo(
            'P2PTransferService: Last chunk received for task $taskId, assembling file...');
        await _assembleReceivedFile(
            taskId: taskId, metaData: {"userId": message.fromUserId});
      }
    } catch (e) {
      logError(
          'P2PTransferService: Failed to process data chunk for task $taskId: $e');
      _incomingFileChunks.remove(taskId);
    }
  }

  Future<void> _handleDataTransferCancel(P2PMessage message) async {
    final data = message.data;
    final taskId = data['taskId'] as String?;

    if (taskId == null) {
      logError('P2PTransferService: Invalid cancel message - missing taskId');
      return;
    }

    logInfo('P2PTransferService: Data transfer cancelled for task $taskId');

    // Clean up receiving data and temp files
    _incomingFileChunks.remove(taskId);
    final tempFilePath = _tempFileChunks.remove(taskId);
    if (tempFilePath != null) {
      _cleanupTempFile(tempFilePath);
    }

    // Update task status if it exists
    final task = _activeTransfers[taskId];
    if (task != null) {
      task.status = DataTransferStatus.cancelled;
      task.errorMessage = 'Transfer cancelled by sender';
      _cleanupTransfer(taskId);
      notifyListeners();
    }
  }

  Future<DataTransferTask?> _getOrCreateTask(
      String taskId, P2PMessage message, Map<String, dynamic> data) async {
    // Check if task already exists
    DataTransferTask? task = _activeTransfers[taskId];
    if (task != null) {
      logDebug('Get or create task: Found existing task for taskId=$taskId');
      return task;
    }

    // Check if another thread is creating this task
    Completer<DataTransferTask?>? existingLock = _taskCreationLocks[taskId];
    if (existingLock != null) {
      logDebug(
          'Get or create task: Waiting for existing lock for taskId=$taskId');
      return await existingLock.future;
    }

    // Create lock for this task creation
    final completer = Completer<DataTransferTask?>();
    _taskCreationLocks[taskId] = completer;

    try {
      // Double-check pattern
      task = _activeTransfers[taskId];
      if (task != null) {
        logDebug(
            'Get or create task: Found existing task after double-check for taskId=$taskId');
        completer.complete(task);
        return task;
      }

      // Extract metadata for first chunk
      final fileName = data['fileName'] as String?;
      final fileSize = data['fileSize'] as int?;

      if (fileName != null && fileSize != null) {
        logDebug(
            'Get or create task: Creating new task for file $fileName, taskId=$taskId');
        // Get batchId for this incoming transfer
        final batchId = _activeBatchIdsByUser[message.fromUserId];

        // Get sender's display name from lookup callback or FileTransferRequest
        String senderName = 'Unknown User';
        final fromUser = _getTargetUser(message.fromUserId);
        if (fromUser != null && fromUser.displayName.isNotEmpty) {
          senderName = fromUser.displayName;
        } else {
          for (final request in _pendingFileTransferRequests) {
            if (request.fromUserId == message.fromUserId &&
                request.fromUserName.isNotEmpty) {
              senderName = request.fromUserName;
              break;
            }
          }
        }

        // Tự động lấy toàn bộ metadata từ payload chunk đầu tiên, trừ các trường mặc định
        final excludeKeys = [
          'fileName',
          'fileSize',
          'taskId',
          'data',
          'isLast',
          'ct',
          'iv',
          'tag',
          'nonce',
          'enc'
        ];
        Map<String, dynamic> metadata = {};
        data.forEach((key, value) {
          if (!excludeKeys.contains(key)) {
            metadata[key] = value;
          }
        });
        // Nếu có messageId thì lưu lại cho _receivedFileMessageIds
        if (metadata.containsKey('messageId')) {
          _receivedFileMessageIds[taskId] = metadata['messageId'];
        }
        logDebug(
            '[P2PTransferService] Received metadata from sender: $metadata for taskId=$taskId');

        task = DataTransferTask(
          id: taskId,
          fileName: fileName,
          filePath: fileName, // Set initial filePath to fileName
          fileSize: fileSize,
          targetUserId: message.fromUserId,
          targetUserName: senderName,
          status: DataTransferStatus.transferring,
          isOutgoing: false,
          createdAt: DateTime.now(),
          startedAt: DateTime.now(),
          batchId: batchId,
          data: metadata.isNotEmpty ? metadata : null,
        );

        _activeTransfers[taskId] = task;

        // Process buffered chunks
        final bufferedChunks = _pendingChunks.remove(taskId);
        if (bufferedChunks != null && bufferedChunks.isNotEmpty) {
          for (final bufferedChunk in bufferedChunks) {
            final chunkData = bufferedChunk['chunkData'] as Uint8List;
            final isLast = bufferedChunk['isLast'] as bool;

            _incomingFileChunks.putIfAbsent(taskId, () => []);
            _incomingFileChunks[taskId]!.add(chunkData);
            task.transferredBytes += chunkData.length;

            if (task.transferredBytes > task.fileSize) {
              task.transferredBytes = task.fileSize;
            }

            if (isLast) {
              Future.microtask(() => _assembleReceivedFile(taskId: taskId));
            }
          }
          notifyListeners();
        }

        completer.complete(task);
        return task;
      } else {
        completer.complete(null);
        return null;
      }
    } catch (e) {
      logError('P2PTransferService: Failed to create task $taskId: $e');
      completer.complete(null);
      return null;
    } finally {
      _taskCreationLocks.remove(taskId);
    }
  }

  Future<void> _assembleReceivedFile(
      {required String taskId, Map<String, dynamic>? metaData}) async {
    try {
      final chunks = _incomingFileChunks[taskId];
      final task = _activeTransfers[taskId];

      if (chunks == null || task == null) {
        logError('P2PTransferService: Missing chunks or task for $taskId');
        return;
      }

      logInfo(
          'P2PTransferService: Receive task ${task.id} with data: ${task.data.toString()}');

      final fileName = _sanitizeFileName(task.fileName);
      final expectedFileSize = task.fileSize;

      // Get download path
      String downloadPath;
      if (task.batchId != null &&
          _batchDownloadPaths.containsKey(task.batchId)) {
        downloadPath = _batchDownloadPaths[task.batchId]!;
      } else if (_transferSettings != null) {
        downloadPath = _transferSettings!.downloadPath;
      } else {
        downloadPath = Platform.isWindows
            ? '${Platform.environment['USERPROFILE']}\\Downloads'
            : '${Platform.environment['HOME']}/Downloads';
      }

      // Create directory
      final downloadDir = Directory(downloadPath);
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      // Generate unique filename
      String finalFileName = fileName;
      String filePath = '$downloadPath${Platform.pathSeparator}$finalFileName';
      int counter = 1;

      while (await File(filePath).exists()) {
        final fileNameParts = fileName.split('.');
        if (fileNameParts.length > 1) {
          final baseName =
              fileNameParts.sublist(0, fileNameParts.length - 1).join('.');
          final extension = fileNameParts.last;
          finalFileName = '${baseName}_$counter.$extension';
        } else {
          finalFileName = '${fileName}_$counter';
        }
        filePath = '$downloadPath${Platform.pathSeparator}$finalFileName';
        counter++;
      }

      // Assemble file data using streaming to avoid memory issues with large files
      final file = File(filePath);
      final fileSink = file.openWrite();
      int actualFileSize = 0;

      try {
        // First, copy data from temp file if it exists
        final tempFilePath = _tempFileChunks[taskId];
        if (tempFilePath != null) {
          final tempFile = File(tempFilePath);
          if (await tempFile.exists()) {
            await tempFile.openRead().listen(
              (chunk) {
                fileSink.add(chunk);
                actualFileSize += chunk.length;
              },
            ).asFuture();
          }
        }

        // Then write remaining chunks from memory
        for (final chunk in chunks) {
          if (chunk.isNotEmpty) {
            fileSink.add(chunk);
            actualFileSize += chunk.length;
          }
        }

        // Ensure all data is written to disk
        await fileSink.flush();
        await fileSink.close();

        // Clean up temp file
        if (tempFilePath != null) {
          final tempFile = File(tempFilePath);
          if (await tempFile.exists()) {
            await tempFile.delete();
          }
          _tempFileChunks.remove(taskId);
        }

        // Verify file size
        if (actualFileSize != expectedFileSize) {
          logError(
              'P2PTransferService: File size mismatch for $fileName: expected $expectedFileSize, got $actualFileSize');
          task.transferredBytes = actualFileSize;
        }
      } catch (writeError) {
        await fileSink.close();
        // Clean up partial file on write error
        if (await file.exists()) {
          await file.delete();
        }
        // Clean up temp file
        final tempFilePath = _tempFileChunks.remove(taskId);
        if (tempFilePath != null) {
          final tempFile = File(tempFilePath);
          if (await tempFile.exists()) {
            await tempFile.delete();
          }
        }
        throw Exception('Failed to write file: $writeError');
      }

      // Update task to completed state
      task.status = DataTransferStatus.completed;
      task.completedAt = DateTime.now();
      task.filePath = filePath;
      task.savePath = filePath;
      task.transferredBytes = actualFileSize;

      logDebug('Check data transfer task: ${task.data}');

      // Auto-cleanup completed task after a delay (keep for a short time to allow user interaction)
      if (_transferSettings?.autoCleanupCompletedTasks == true) {
        Timer(
            Duration(seconds: _transferSettings?.autoCleanupDelaySeconds ?? 5),
            () async {
          // logDebug(
          //     '>> Call auto cleanup from autoCleanupCompletedTasks == true for failed task: ${task.id}');

          await _autoCleanupTask(taskId, 'completed');
        });
      }

      logInfo('>>>>>>>>> Task data after assembly: ${task.data.toString()}');

      // Chỉ cập nhật filePath trong Isar nếu có syncFilePath (tức là đồng bộ đường dẫn file)
      if (task.data?.containsKey(DataTransferKey.syncFilePath.name) ?? false) {
        try {
          /// Block code 2
          final String userId = metaData!['userId'] as String;

          _chatService.updateFilePathAndNotify(
              userBId: userId, filePath: filePath);
        } catch (e) {
          logError('P2PTransferService: Failed to update filePath in Isar: $e');
        }
      }

      // Update isar if fileSyncResponse is present
      if (task.data?.containsKey(DataTransferKey.fileSyncResponse.name) ??
          false) {
        logInfo(
            'P2PTransferService: Updating message status in Isar for task $taskId');
        try {
          final userId = task.data!['userId'] as String;
          final syncId = task.data![DataTransferKey.fileSyncResponse.name];

          _chatService.updateFileSyncResponseAndNotify(
              userBId: userId, syncId: syncId, filePath: filePath);
          logInfo(
              'P2PTransferService: Updated message status in Isar for syncId: $syncId');

          // For file sync response, immediately clean up the transfer task
          // since it's a background re-sync operation that shouldn't persist in UI
          Timer(const Duration(seconds: 2), () async {
            logDebug(
                '>> Call auto cleanup from Contain key fileSyncResponse for failed task: ${task.id}');

            await _autoCleanupTask(taskId, 'file sync response completed');
          });
        } catch (e) {
          logError(
              'P2PTransferService: Failed to update message status in Isar: $e');
        }
      }

      // Show completion notification
      await _safeNotificationCall(
          () => P2PNotificationService.instance.showFileTransferCompleted(
                task: task,
                success: true,
              ));

      // Clean up chunks from memory immediately after writing to save memory
      _incomingFileChunks.remove(taskId);

      // Clean up batch data if this was the last file
      if (task.batchId != null) {
        final totalFilesInBatch = _batchFileCounts[task.batchId] ?? 0;
        await Future.delayed(const Duration(milliseconds: 100));

        final completedInBatch = _activeTransfers.values
            .where((t) =>
                t.batchId == task.batchId &&
                !t.isOutgoing &&
                t.status == DataTransferStatus.completed)
            .length;

        if (totalFilesInBatch > 0 && completedInBatch >= totalFilesInBatch) {
          logInfo(
              'P2PTransferService: Batch ${task.batchId} complete. Cleaning up resources.');
          _batchDownloadPaths.remove(task.batchId);
          _batchFileCounts.remove(task.batchId);

          final userToRemove = _activeBatchIdsByUser.entries
              .firstWhere((entry) => entry.value == task.batchId,
                  orElse: () => const MapEntry('', ''))
              .key;

          if (userToRemove.isNotEmpty) {
            _activeBatchIdsByUser.remove(userToRemove);
          }
        }
      }

      // Trigger aggressive garbage collection for large files to free memory
      if (actualFileSize > 50 * 1024 * 1024) {
        // Files larger than 50MB
        Future.microtask(() async {
          await _cleanupMemory();
          // Force garbage collection hint for Dart VM
          if (kDebugMode) {
            logInfo(
                'P2PTransferService: Large file ($actualFileSize bytes) completed, suggesting GC');
          }
        });
      }

      notifyListeners();
      logInfo('P2PTransferService: File transfer completed: $finalFileName');
    } catch (e) {
      logError(
          'P2PTransferService: Failed to assemble received file for task $taskId: $e');
      _incomingFileChunks.remove(taskId);
      // Clean up temp file if exists
      final tempFilePath = _tempFileChunks.remove(taskId);
      if (tempFilePath != null) {
        try {
          final tempFile = File(tempFilePath);
          if (await tempFile.exists()) {
            await tempFile.delete();
          }
        } catch (e) {
          logWarning('Failed to clean up temp file: $e');
        }
      }
    }
  }

  /// Flush accumulated chunks to a temporary file to reduce memory usage
  Future<void> _flushChunksToTempFile(String taskId) async {
    final chunks = _incomingFileChunks[taskId];
    if (chunks == null || chunks.isEmpty) return;

    try {
      // Create temp file path
      final tempDir = await getTemporaryDirectory();
      final tempFilePath =
          '${tempDir.path}${Platform.pathSeparator}p2p_temp_$taskId.tmp';
      _tempFileChunks[taskId] = tempFilePath;

      // Write chunks to temp file
      final tempFile = File(tempFilePath);
      final tempSink = tempFile.openWrite(mode: FileMode.append);

      for (final chunk in chunks) {
        tempSink.add(chunk);
      }

      await tempSink.flush();
      await tempSink.close();

      // Clear chunks from memory
      _incomingFileChunks[taskId]!.clear();

      logDebug(
          'P2PTransferService: Flushed ${chunks.length} chunks to temp file for task $taskId');
    } catch (e) {
      logError(
          'P2PTransferService: Failed to flush chunks to temp file for task $taskId: $e');
    }
  }

  /// Clean up temporary file
  void _cleanupTempFile(String tempFilePath) {
    Future.microtask(() async {
      try {
        final tempFile = File(tempFilePath);
        if (await tempFile.exists()) {
          await tempFile.delete();
          logDebug('P2PTransferService: Cleaned up temp file: $tempFilePath');
        }
      } catch (e) {
        logWarning('P2PTransferService: Failed to clean up temp file: $e');
      }
    });
  }

  Future<void> _startTransfersWithConcurrencyLimit(
      List<DataTransferTask> tasks) async {
    final limit = _transferSettings?.maxConcurrentTasks ?? 3;

    logInfo(
        'P2PTransferService: Starting transfers with concurrency limit: $limit');

    // Set all tasks to pending status first
    for (final task in tasks) {
      if (task.status == DataTransferStatus.waitingForApproval) {
        task.status = DataTransferStatus.pending;
      }
    }

    // Start initial batch
    await _startNextAvailableTransfers();
  }

  Future<void> _startNextAvailableTransfers() async {
    final maxConcurrent = _transferSettings?.maxConcurrentTasks ?? 3;

    final currentlyRunning = _activeTransfers.values
        .where(
            (t) => t.isOutgoing && t.status == DataTransferStatus.transferring)
        .length;

    final availableSlots = maxConcurrent - currentlyRunning;
    if (availableSlots <= 0) return;

    final pendingTasks = _activeTransfers.values
        .where((t) => t.isOutgoing && t.status == DataTransferStatus.pending)
        .take(availableSlots)
        .toList();

    for (final task in pendingTasks) {
      final targetUser = _getTargetUser(task.targetUserId);
      if (targetUser != null) {
        task.status = DataTransferStatus.transferring;
        task.startedAt = DateTime.now();
        await _startDataTransfer(task, targetUser);
      }
    }

    if (pendingTasks.isNotEmpty) {
      notifyListeners();
    }
  }

  Future<void> _startDataTransfer(
      DataTransferTask task, P2PUser targetUser) async {
    try {
      final chunkSizeKB = _transferSettings?.maxChunkSize ?? 512;
      final chunkSizeBytes = chunkSizeKB * 1024;

      // Create isolate for data transfer
      final receivePort = ReceivePort();
      _transferPorts[task.id] = receivePort;

      // Check if encryption is enabled for this transfer
      final encryptionType =
          _transferSettings?.encryptionType ?? EncryptionType.none;
      final useEncryption = encryptionType != EncryptionType.none;
      final sessionKey = useEncryption ? _getSessionKey(targetUser.id) : null;

      final isolate = await Isolate.spawn(
        _staticDataTransferIsolate,
        {
          'sendPort': receivePort.sendPort,
          'task': task.toJson(),
          'targetUser': targetUser.toJson(),
          'currentUserId': _networkService.currentUser!.id,
          'maxChunkSize': chunkSizeBytes,
          'protocol': 'tcp',
          'useEncryption': useEncryption,
          'encryptionType': encryptionType.name,
          'sessionKey': sessionKey != null ? base64Encode(sessionKey) : null,
        },
      );

      _transferIsolates[task.id] = isolate;

      // Listen for progress updates
      receivePort.listen((data) async {
        if (data is Map<String, dynamic>) {
          final progress = data['progress'] as double?;
          final completed = data['completed'] as bool? ?? false;
          final error = data['error'] as String?;

          if (progress != null) {
            task.transferredBytes = (task.fileSize * progress).round();

            // Show progress notification - 🚀 Giảm tần suất update để tăng hiệu suất
            if (_transferSettings?.enableNotifications == true) {
              final progressPercent = (progress * 100).round();
              // Chỉ show notification ở các mốc quan trọng hoặc 10% intervals
              if (progressPercent == 0 ||
                  progressPercent % 10 == 0 ||
                  progressPercent > 95) {
                await _safeNotificationCall(() =>
                    P2PNotificationService.instance.showFileTransferStatus(
                      task: task,
                      progress: progressPercent,
                    ));
              }
            }
          }

          if (completed) {
            task.status = DataTransferStatus.completed;
            task.completedAt = DateTime.now();

            await _safeNotificationCall(() => P2PNotificationService.instance
                .cancelFileTransferStatus(task.id));
            await _safeNotificationCall(
                () => P2PNotificationService.instance.showFileTransferCompleted(
                      task: task,
                      success: true,
                    ));

            _cleanupTransfer(task.id);
          } else if (error != null) {
            task.status = DataTransferStatus.failed;
            task.errorMessage = error;

            // Auto-cleanup failed task after a delay
            if (_transferSettings?.autoCleanupFailedTasks == true) {
              Timer(
                  Duration(
                      seconds: _transferSettings?.autoCleanupDelaySeconds ??
                          10), () async {
                // logDebug(
                //     '>> Call auto cleanup from autoCleanupFailedTasks == true for failed task: ${task.id}');

                await _autoCleanupTask(task.id, 'failed');
              });
            }

            await _safeNotificationCall(() => P2PNotificationService.instance
                .cancelFileTransferStatus(task.id));
            await _safeNotificationCall(
                () => P2PNotificationService.instance.showFileTransferCompleted(
                      task: task,
                      success: false,
                      errorMessage: error,
                    ));

            _cleanupTransfer(task.id);
          }

          notifyListeners();
        }
      });

      notifyListeners();
    } catch (e) {
      task.status = DataTransferStatus.failed;
      task.errorMessage = e.toString();

      // Auto-cleanup failed task after a delay
      if (_transferSettings?.autoCleanupFailedTasks == true) {
        Timer(
            Duration(seconds: _transferSettings?.autoCleanupDelaySeconds ?? 10),
            () async {
          // logDebug(
          //     '>> Call auto cleanup from autoCleanupFailedTasks == true for failed task: ${task.id}');
          await _autoCleanupTask(task.id, 'failed');
        });
      }

      logError('P2PTransferService: Failed to start data transfer: $e');
      notifyListeners();
    }
  }

  static void _staticDataTransferIsolate(Map<String, dynamic> params) async {
    final sendPort = params['sendPort'] as SendPort;
    Socket? tcpSocket;
    RawDatagramSocket? udpSocket;

    try {
      // Parse parameters
      final taskData = params['task'] as Map<String, dynamic>;
      final targetUserData = params['targetUser'] as Map<String, dynamic>;
      final currentUserId = params['currentUserId'] as String;
      final maxChunkSizeFromSettings =
          (params['maxChunkSize'] as int? ?? 512 * 1024);
      final protocol = params['protocol'] as String? ?? 'tcp';

      final task = DataTransferTask.fromJson(taskData);
      final targetUser = P2PUser.fromJson(targetUserData);

      // Initialize connection based on protocol
      if (protocol.toLowerCase() == 'udp') {
        udpSocket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
        // 🚀 Tối ưu UDP socket
        PerformanceOptimizerService.optimizeUDPSocket(udpSocket);
      } else {
        tcpSocket = await Socket.connect(
          targetUser.ipAddress,
          targetUser.port,
          timeout: const Duration(seconds: 10),
        );
        // 🚀 Tối ưu TCP socket với buffer size lớn hơn
        tcpSocket.setOption(SocketOption.tcpNoDelay, true);
        PerformanceOptimizerService.optimizeTCPSocket(tcpSocket);
      }

      // Read file
      final file = File(task.filePath);
      if (!await file.exists()) {
        sendPort.send({'error': 'File does not exist: ${task.filePath}'});
        return;
      }

      final fileBytes = await file.readAsBytes();
      int totalSent = 0;
      // 🚀 Bắt đầu với chunk size lớn hơn cho tốc độ tốt hơn
      int chunkSize =
          min(512 * 1024, maxChunkSizeFromSettings); // Start with 512KB
      final int maxChunkSize = maxChunkSizeFromSettings;
      int successfulChunksInRow = 0;
      Duration delay =
          const Duration(milliseconds: 2); // 🚀 Giảm delay từ 5ms xuống 2ms

      final totalBytes = fileBytes.length;
      bool isFirstChunk = true;

      while (totalSent < totalBytes) {
        final remainingBytes = totalBytes - totalSent;
        final currentChunkSize = min(chunkSize, remainingBytes);
        final chunk =
            fileBytes.sublist(totalSent, totalSent + currentChunkSize);

        try {
          Map<String, dynamic> dataPayload;

          // Check if encryption is enabled (passed via parameters)
          final useEncryption = params['useEncryption'] as bool? ?? false;
          final encryptionTypeName =
              params['encryptionType'] as String? ?? 'none';

          if (useEncryption) {
            // Get session key (passed via parameters)
            final sessionKeyBase64 = params['sessionKey'] as String?;
            if (sessionKeyBase64 != null) {
              final sessionKey = base64Decode(sessionKeyBase64);

              // Determine encryption type
              EncryptionType encryptionType;
              switch (encryptionTypeName) {
                case 'aesGcm':
                  encryptionType = EncryptionType.aesGcm;
                  break;
                case 'chaCha20':
                  encryptionType = EncryptionType.chaCha20;
                  break;
                default:
                  encryptionType = EncryptionType.none;
              }

              if (encryptionType != EncryptionType.none) {
                // Use new CryptoService
                final encryptedData = await CryptoService.encrypt(
                    chunk, sessionKey, encryptionType);

                if (encryptionType == EncryptionType.aesGcm) {
                  dataPayload = {
                    'taskId': task.id,
                    'ct': base64Encode(encryptedData['ciphertext']!),
                    'iv': base64Encode(encryptedData['iv']!),
                    'tag': base64Encode(encryptedData['tag']!),
                    'enc': 'aes-gcm',
                    'isLast': (totalSent + currentChunkSize == totalBytes),
                  };
                } else {
                  dataPayload = {
                    'taskId': task.id,
                    'ct': base64Encode(encryptedData['ciphertext']!),
                    'nonce': base64Encode(encryptedData['nonce']!),
                    'tag': base64Encode(encryptedData['tag']!),
                    'enc': 'chacha20-poly1305',
                    'isLast': (totalSent + currentChunkSize == totalBytes),
                  };
                }
              } else {
                // Fallback to unencrypted
                dataPayload = {
                  'taskId': task.id,
                  'data': base64Encode(chunk),
                  'isLast': (totalSent + currentChunkSize == totalBytes),
                };
              }
            } else {
              // Fallback to unencrypted if no session key
              dataPayload = {
                'taskId': task.id,
                'data': base64Encode(chunk),
                'isLast': (totalSent + currentChunkSize == totalBytes),
              };
            }
          } else {
            // Unencrypted chunk (original behavior)
            dataPayload = {
              'taskId': task.id,
              'data': base64Encode(chunk),
              'isLast': (totalSent + currentChunkSize == totalBytes),
            };
          }

          if (isFirstChunk) {
            dataPayload['fileName'] = task.fileName;
            dataPayload['fileSize'] = task.fileSize;
            // Truyền messageId nếu có trong task.data
            // final syncFilePath = task.data != null
            //     ? task.data![DataTransferKey.syncFilePath.name]
            //     : null;
            // if (syncFilePath != null) {
            //   dataPayload['messageId'] = syncFilePath;
            // }
            // Truyền toàn bộ metadata từ task.data vào chunk đầu tiên
            if (task.data != null) {
              task.data!.forEach((key, value) {
                dataPayload[key] = value;
              });
            }
            isFirstChunk = false;
          }

          final chunkMessage = P2PMessage(
            type: P2PMessageTypes.dataChunk,
            fromUserId: currentUserId,
            toUserId: targetUser.id,
            data: dataPayload,
          );

          final messageBytes = utf8.encode(jsonEncode(chunkMessage.toJson()));

          // Send based on protocol
          if (protocol.toLowerCase() == 'udp') {
            final targetAddress = InternetAddress(targetUser.ipAddress);
            udpSocket!.send(messageBytes, targetAddress, targetUser.port);
          } else {
            final lengthHeader = ByteData(4)
              ..setUint32(0, messageBytes.length, Endian.big);
            tcpSocket!.add(lengthHeader.buffer.asUint8List());
            tcpSocket.add(messageBytes);
            await tcpSocket.flush();
          }

          totalSent += currentChunkSize;
          successfulChunksInRow++;

          // Dynamic chunk size adjustment - 🚀 Cải thiện thuật toán adaptive
          if (successfulChunksInRow > 2 && chunkSize < maxChunkSize) {
            // Giảm từ 3 xuống 2
            chunkSize = min(
                (chunkSize * 1.5).round(), maxChunkSize); // Tăng 50% thay vì x2
            delay = Duration(
                milliseconds:
                    max(1, delay.inMilliseconds - 1)); // Giảm delay nhẹ hơn
            successfulChunksInRow = 0;
          }

          sendPort.send({
            'progress': totalSent / totalBytes,
            'transferredBytes': totalSent,
          });

          if (delay > Duration.zero) {
            await Future.delayed(delay);
          }
        } catch (e) {
          sendPort.send({'error': 'Chunk failed: $e. Retrying...'});

          // 🚀 Cải thiện error recovery
          // Slow down on error nhưng không quá aggressive
          chunkSize =
              max(128 * 1024, (chunkSize * 0.7).round()); // Giảm 30% thay vì /2
          delay = Duration(
              milliseconds:
                  min(20, delay.inMilliseconds + 5)); // Tăng delay ít hơn

          // Re-establish connection for TCP
          if (protocol.toLowerCase() != 'udp') {
            await tcpSocket?.close();
            tcpSocket = await Socket.connect(
                targetUser.ipAddress, targetUser.port,
                timeout: const Duration(seconds: 10));
            // 🚀 Tối ưu lại TCP socket sau khi reconnect
            tcpSocket.setOption(SocketOption.tcpNoDelay, true);
            PerformanceOptimizerService.optimizeTCPSocket(tcpSocket);
          }

          // Reset first chunk flag if we failed on first chunk
          if (totalSent == 0) {
            isFirstChunk = true;
          }
        }
      }

      sendPort.send({'completed': true});
    } catch (e) {
      sendPort.send({'error': 'Transfer failed: $e'});
    } finally {
      await tcpSocket?.close();
      udpSocket?.close();
    }
  }

  void _cleanupTransfer(String taskId) {
    final task = _activeTransfers[taskId];
    final isolate = _transferIsolates.remove(taskId);
    isolate?.kill();

    final port = _transferPorts.remove(taskId);
    port?.close();

    if (task != null) {
      _checkAndUnregisterBatchIfComplete(task.batchId);

      if (task.isOutgoing && task.status == DataTransferStatus.completed) {
        final remainingOutgoingTasks = _activeTransfers.values
            .where((t) =>
                t.id != taskId &&
                t.isOutgoing &&
                (t.status == DataTransferStatus.transferring ||
                    t.status == DataTransferStatus.pending))
            .toList();

        if (remainingOutgoingTasks.isEmpty) {
          Future.delayed(const Duration(seconds: 2), () {
            cleanupFilePickerCacheIfSafe();
          });
        }
      }
    }

    _startNextQueuedTransfer();
  }

  void _startNextQueuedTransfer() async {
    await _startNextAvailableTransfers();
  }

  void _checkAndUnregisterBatchIfComplete(String? batchId) {
    if (batchId == null || batchId.isEmpty) return;

    if (!_activeFileTransferBatches.contains(batchId)) {
      return;
    }

    final batchTasks = _activeTransfers.values
        .where((task) => task.batchId == batchId)
        .toList();

    if (batchTasks.isEmpty) {
      _unregisterFileTransferBatch(batchId);
      return;
    }

    final allTasksFinished = batchTasks.every((task) =>
        task.status == DataTransferStatus.completed ||
        task.status == DataTransferStatus.failed ||
        task.status == DataTransferStatus.cancelled ||
        task.status == DataTransferStatus.rejected);

    if (allTasksFinished) {
      logInfo(
          'P2PTransferService: All tasks in batch $batchId are finished. Unregistering.');
      _unregisterFileTransferBatch(batchId);
    }
  }

  void _registerActiveFileTransferBatch(String batchId) {
    _activeFileTransferBatches.add(batchId);
    logInfo(
        'P2PTransferService: Registered active file transfer batch: $batchId');
  }

  void _unregisterFileTransferBatch(String batchId) {
    _activeFileTransferBatches.remove(batchId);
    logInfo('P2PTransferService: Unregistered file transfer batch: $batchId');

    Future.delayed(const Duration(seconds: 5), () {
      cleanupFilePickerCacheIfSafe();
    });
  }

  void _cancelTasksByBatchId(String batchId) {
    final tasksToCancel = _activeTransfers.values
        .where((task) => task.batchId == batchId)
        .toList();

    bool hasOutgoingTasks = false;
    for (final task in tasksToCancel) {
      if (task.isOutgoing) hasOutgoingTasks = true;
      task.status = DataTransferStatus.cancelled;
      task.errorMessage = 'File transfer request failed';
      _cleanupTransfer(task.id);
    }

    if (hasOutgoingTasks && batchId.isNotEmpty) {
      _unregisterFileTransferBatch(batchId);
    }

    logInfo(
        'P2PTransferService: Cancelled ${tasksToCancel.length} tasks for batch $batchId');
    notifyListeners();
  }

  void _handleFileTransferTimeout(String requestId) {
    _fileTransferResponseTimers.remove(requestId);

    final tasksToCancel = _activeTransfers.values
        .where((task) =>
            task.status == DataTransferStatus.waitingForApproval &&
            task.isOutgoing)
        .toList();

    if (tasksToCancel.isNotEmpty) {
      final batchIds = tasksToCancel
          .where((task) => task.batchId?.isNotEmpty == true)
          .map((task) => task.batchId!)
          .toSet();

      for (final task in tasksToCancel) {
        task.status = DataTransferStatus.cancelled;
        task.errorMessage = 'No response from receiver (timeout)';
        _cleanupTransfer(task.id);
      }

      for (final batchId in batchIds) {
        _unregisterFileTransferBatch(batchId);
      }
    }

    logInfo('P2PTransferService: File transfer request $requestId timed out');
    notifyListeners();
  }

  void _handleFileTransferRequestTimeout(String requestId) {
    _fileTransferRequestTimers.remove(requestId);

    final request = _pendingFileTransferRequests
        .where((r) => r.requestId == requestId)
        .firstOrNull;

    if (request == null) return;

    logInfo(
        'P2PTransferService: File transfer request timed out: ${request.requestId}');

    _safeNotificationCall(() => P2PNotificationService.instance
        .cancelNotification(request.requestId.hashCode));

    _sendFileTransferResponse(request, false, FileTransferRejectReason.timeout,
        'Request timed out (no response)');

    _pendingFileTransferRequests.removeWhere((r) => r.requestId == requestId);
    _removeFileTransferRequest(request.requestId);

    notifyListeners();
  }

  Future<_FileTransferValidationResult> _validateFileTransferRequest(
      FileTransferRequest request, P2PUser fromUser) async {
    final settings = _transferSettings;
    if (settings == null) {
      return _FileTransferValidationResult.invalid(
          FileTransferRejectReason.unknown, 'Transfer settings not configured');
    }

    // Check total size limit
    if (settings.maxTotalReceiveSize != -1 &&
        request.totalSize > settings.maxTotalReceiveSize) {
      final maxSizeMB = settings.maxTotalReceiveSize ~/ (1024 * 1024);
      final requestSizeMB = request.totalSize / (1024 * 1024);
      return _FileTransferValidationResult.invalid(
          FileTransferRejectReason.totalSizeExceeded,
          'Total size ${requestSizeMB.toStringAsFixed(1)}MB exceeds limit ${maxSizeMB}MB');
    }

    // Check individual file size limits
    for (final file in request.files) {
      if (settings.maxReceiveFileSize != -1 &&
          file.fileSize > settings.maxReceiveFileSize) {
        final maxSizeMB = settings.maxReceiveFileSize ~/ (1024 * 1024);
        final fileSizeMB = file.fileSize / (1024 * 1024);
        return _FileTransferValidationResult.invalid(
            FileTransferRejectReason.fileSizeExceeded,
            'File ${file.fileName} size ${fileSizeMB.toStringAsFixed(1)}MB exceeds limit ${maxSizeMB}MB');
      }
    }

    return _FileTransferValidationResult.valid();
  }

  Future<void> _sendFileTransferResponse(
      FileTransferRequest request,
      bool accepted,
      FileTransferRejectReason? rejectReason,
      String? rejectMessage) async {
    final targetUser = _getTargetUser(request.fromUserId);
    if (targetUser == null) return;

    String? downloadPath;
    if (accepted && _transferSettings != null) {
      downloadPath = _transferSettings!.downloadPath;

      if (_transferSettings!.createSenderFolders) {
        String senderFolderName = 'Unknown';
        final sender = _getTargetUser(request.fromUserId);
        if (sender != null && sender.displayName.isNotEmpty) {
          senderFolderName = _sanitizeFileName(sender.displayName);
        } else if (request.fromUserName.isNotEmpty) {
          senderFolderName = _sanitizeFileName(request.fromUserName);
        }

        downloadPath =
            '$downloadPath${Platform.pathSeparator}$senderFolderName';

        final dir = Directory(downloadPath);
        if (!await dir.exists()) {
          await dir.create(recursive: true);
        }
      } else if (_transferSettings!.createDateFolders) {
        final dateFolder = DateTime.now().toIso8601String().split('T')[0];
        downloadPath = '$downloadPath${Platform.pathSeparator}$dateFolder';

        final dir = Directory(downloadPath);
        if (!await dir.exists()) {
          await dir.create(recursive: true);
        }
      }
    }

    String? sessionKeyBase64;
    if (accepted && request.useEncryption) {
      final key = _getOrCreateSessionKey(request.fromUserId);
      sessionKeyBase64 = base64Encode(key);
      logInfo(
          'P2PTransferService: Sending session key to user ${request.fromUserId}');
    }

    final response = FileTransferResponse(
      requestId: request.requestId,
      batchId: request.batchId,
      accepted: accepted,
      rejectReason: rejectReason,
      rejectMessage: rejectMessage,
      downloadPath: downloadPath,
      sessionKeyBase64: sessionKeyBase64,
    );

    final message = {
      'type': P2PMessageTypes.fileTransferResponse,
      'fromUserId': _networkService.currentUser!.id,
      'toUserId': request.fromUserId,
      'data': response.toJson(),
    };

    await _networkService.sendMessageToUser(targetUser, message);
  }

  Future<void> _acceptFileTransferRequest(FileTransferRequest request) async {
    await _safeNotificationCall(() => P2PNotificationService.instance
        .cancelNotification(request.requestId.hashCode));

    String? downloadPath;
    if (_transferSettings != null) {
      downloadPath = _transferSettings!.downloadPath;

      if (_transferSettings!.createSenderFolders) {
        String senderFolderName = 'Unknown';
        final sender = _getTargetUser(request.fromUserId);
        if (sender != null && sender.displayName.isNotEmpty) {
          senderFolderName = _sanitizeFileName(sender.displayName);
        } else if (request.fromUserName.isNotEmpty) {
          senderFolderName = _sanitizeFileName(request.fromUserName);
        }

        downloadPath =
            '$downloadPath${Platform.pathSeparator}$senderFolderName';

        final dir = Directory(downloadPath);
        if (!await dir.exists()) {
          await dir.create(recursive: true);
        }
      } else if (_transferSettings!.createDateFolders) {
        final dateFolder = DateTime.now().toIso8601String().split('T')[0];
        downloadPath = '$downloadPath${Platform.pathSeparator}$dateFolder';

        final dir = Directory(downloadPath);
        if (!await dir.exists()) {
          await dir.create(recursive: true);
        }
      }
    }

    if (downloadPath != null) {
      _batchDownloadPaths[request.batchId] = downloadPath;
      _batchFileCounts[request.batchId] = request.files.length;
    }

    _activeBatchIdsByUser[request.fromUserId] = request.batchId;

    await _sendFileTransferResponse(request, true, null, null);

    _pendingFileTransferRequests
        .removeWhere((r) => r.requestId == request.requestId);
    await _removeFileTransferRequest(request.requestId);

    notifyListeners();
  }

  String _sanitizeFileName(String fileName) {
    return fileName.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
  }

  String? _formatSpeed(double bytesPerSecond) {
    if (bytesPerSecond < 1024) {
      return '${bytesPerSecond.round()} B/s';
    } else if (bytesPerSecond < 1024 * 1024) {
      return '${(bytesPerSecond / 1024).round()} KB/s';
    } else {
      return '${(bytesPerSecond / (1024 * 1024)).toStringAsFixed(1)} MB/s';
    }
  }

  String? _formatEta(int totalSeconds) {
    if (totalSeconds < 60) {
      return '${totalSeconds}s left';
    } else if (totalSeconds < 3600) {
      final minutes = totalSeconds ~/ 60;
      final seconds = totalSeconds % 60;
      return '${minutes}m ${seconds}s left';
    } else {
      final hours = totalSeconds ~/ 3600;
      final minutes = (totalSeconds % 3600) ~/ 60;
      return '${hours}h ${minutes}m left';
    }
  }

  P2PUser? _getTargetUser(String userId) {
    // Use callback to get user from discovery service
    if (_getUserByIdCallback != null) {
      return _getUserByIdCallback!(userId);
    }
    return null;
  }

  /// Set reference to discovery service for user lookup
  Function(String)? _getUserByIdCallback;

  /// Set user lookup callback from discovery service
  void setUserLookupCallback(P2PUser? Function(String) callback) {
    _getUserByIdCallback = callback;
  }

  /// Set callback for forwarding messages to other services
  Function(P2PMessage, Socket)? _onOtherMessageReceived;

  void setOtherMessageCallback(Function(P2PMessage, Socket) callback) {
    _onOtherMessageReceived = callback;
  }

  Future<void> _safeNotificationCall(Future<void> Function() operation) async {
    if (_transferSettings?.enableNotifications != true) {
      return;
    }

    final notificationService = P2PNotificationService.instanceOrNull;
    if (notificationService == null || !notificationService.isReady) {
      return;
    }

    try {
      await operation();
    } catch (e) {
      logWarning('P2PTransferService: Notification service call failed: $e');
    }
  }

  Future<void> _cleanupMemory() async {
    try {
      final completedTaskIds = _activeTransfers.entries
          .where((entry) =>
              entry.value.status == DataTransferStatus.completed ||
              entry.value.status == DataTransferStatus.failed ||
              entry.value.status == DataTransferStatus.cancelled)
          .map((entry) => entry.key)
          .toList();

      for (final taskId in completedTaskIds) {
        _incomingFileChunks.remove(taskId);
      }

      await cleanupFilePickerCacheIfSafe();
      await _cleanupOldFileTransferRequests();

      logInfo('P2PTransferService: Memory cleanup completed');
    } catch (e) {
      logError('P2PTransferService: Error during memory cleanup: $e');
    }
  }

  Future<void> _cleanupOldFileTransferRequests() async {
    try {
      final isar = IsarService.isar;
      final cutoffTime = DateTime.now().subtract(const Duration(hours: 24));

      final requestsToDelete = await isar.fileTransferRequests
          .filter()
          .requestTimeLessThan(cutoffTime)
          .findAll();

      if (requestsToDelete.isNotEmpty) {
        final idsToDelete = requestsToDelete.map((r) => r.isarId).toList();
        await isar.writeTxn(() async {
          await isar.fileTransferRequests.deleteAll(idsToDelete);
        });
        logInfo(
            'P2PTransferService: Cleaned up ${idsToDelete.length} old file transfer requests');
      }
    } catch (e) {
      logError(
          'P2PTransferService: Error cleaning up old file transfer requests: $e');
    }
  }

  // Storage methods

  Future<void> _loadTransferSettings() async {
    try {
      _transferSettings = await P2PSettingsAdapter.getSettings();
      // logDebug(
      //     '----------------------- P2PTransferService: Loaded transfer settings: ${_transferSettings?.toJson()}');
      logInfo('P2PTransferService: Loaded transfer settings');
    } catch (e) {
      logError('P2PTransferService: Failed to load transfer settings: $e');
      final dir = await getApplicationDocumentsDirectory();
      _transferSettings = P2PDataTransferSettings(
          downloadPath: '${dir.path}${Platform.pathSeparator}downloads',
          createDateFolders: false,
          maxReceiveFileSize: 1024 * 1024 * 1024,
          maxTotalReceiveSize: 5 * 1024 * 1024 * 1024,
          maxConcurrentTasks: 3,
          sendProtocol: 'TCP',
          maxChunkSize: 1024,
          createSenderFolders: true,
          uiRefreshRateSeconds: 0,
          enableNotifications: true,
          rememberBatchExpandState: false,
          encryptionType: EncryptionType.none);
    }
  }

  /// Refresh transfer settings from storage
  Future<void> refreshSettings() async {
    await _loadTransferSettings();
    logInfo('P2PTransferService: Settings refreshed');
  }

  Future<void> _loadActiveTransfers() async {
    final isar = IsarService.isar;
    final tasks = await isar.dataTransferTasks
        .filter()
        .not()
        .statusEqualTo(DataTransferStatus.completed)
        .and()
        .not()
        .statusEqualTo(DataTransferStatus.failed)
        .and()
        .not()
        .statusEqualTo(DataTransferStatus.cancelled)
        .and()
        .not()
        .statusEqualTo(DataTransferStatus.rejected)
        .findAll();
    _activeTransfers.clear();
    for (final task in tasks) {
      _activeTransfers[task.id] = task;
    }
    logInfo(
        'P2PTransferService: Loaded ${_activeTransfers.length} active transfers');
  }

  Future<void> _loadPendingFileTransferRequests() async {
    final isar = IsarService.isar;
    _pendingFileTransferRequests.clear();
    final requests = await isar.fileTransferRequests.where().findAll();
    _pendingFileTransferRequests.addAll(requests);
    logInfo(
        'P2PTransferService: Loaded ${_pendingFileTransferRequests.length} pending requests');
  }

  Future<void> _saveFileTransferRequest(FileTransferRequest request) async {
    try {
      await IsarService.isar
          .writeTxn(() => IsarService.isar.fileTransferRequests.put(request));
    } catch (e) {
      logError('P2PTransferService: Failed to save file transfer request: $e');
    }
  }

  Future<void> _removeFileTransferRequest(String requestId) async {
    try {
      await IsarService.isar.writeTxn(() =>
          IsarService.isar.fileTransferRequests.delete(fastHash(requestId)));
    } catch (e) {
      logError(
          'P2PTransferService: Failed to remove file transfer request: $e');
    }
  }

  Future<void> _initializeAndroidPath() async {
    if (Platform.isAndroid && _transferSettings != null) {
      try {
        final appDocDir = await getApplicationDocumentsDirectory();
        final androidPath = '${appDocDir.parent.path}/files/p2lan_transfer';

        final directory = Directory(androidPath);
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        if (_transferSettings!.downloadPath.contains(
            '/data/data/com.p2lantransfer.app/files/p2lan_transfer')) {
          _transferSettings =
              _transferSettings!.copyWith(downloadPath: androidPath);
          await P2PSettingsAdapter.updateSettings(_transferSettings!);
          logInfo(
              'P2PTransferService: Updated Android download path to: $androidPath');
        }
      } catch (e) {
        logError('P2PTransferService: Failed to initialize Android path: $e');
      }
    }
  }

  Future<void> _handleFileCheckAndTransferBackwardRequest(
      P2PMessage msg) async {
    logInfo(
        'P2PTransferService: Handling file check and transfer backward request from ${msg.toJson()}');

    final data = msg.data;
    final peerUser = _getTargetUser(msg.fromUserId)!;
    final syncId = data['syncId'];

    if (syncId == null) {
      logError(
          'P2PTransferService: syncId is null in file check and transfer backward request');
      return;
    }

    // Check the file on device
    String? filePath =
        await _chatService.handleCheckMessageFileExist(msg.fromUserId, syncId);
    // Double check if filePath is null
    filePath ??=
        await _chatService.handleCheckMessageFileExist(msg.fromUserId, syncId);

    logDebug(
        'P2PTransferService: File check for syncId $syncId returned path: $filePath');

    // If file not found, send response
    if (filePath == null) {
      logInfo('P2PTransferService: File not found for syncId $syncId');
      final response = P2PMessage(
          type: P2PMessageTypes.chatRequestFileLost,
          fromUserId: msg.toUserId,
          toUserId: msg.fromUserId,
          data: {"syncId": syncId});
      await _networkService.sendMessageToUser(peerUser, response.toJson());
    } else {
      // If file exists, create file transfer task
      final file = File(filePath);
      final task = DataTransferTask.create(
        filePath: filePath,
        fileName: UriUtils.getFileName(filePath),
        fileSize: file.lengthSync(),
        status: DataTransferStatus.pending,
        isOutgoing: true,
        targetUserId: msg.fromUserId,
        batchId: syncId,
        startedAt: DateTime.now(),
        targetUserName: peerUser.displayName,
        createdAt: DateTime.now(),
        data: {
          DataTransferKey.fileSyncResponse.name: syncId,
          "userId": msg.toUserId
        },
      );
      _activeTransfers[syncId] = task;
      logInfo(
          'P2PTransferService: Created file transfer task for syncId $syncId');
      await _startNextAvailableTransfers();
      notifyListeners();
    }
  }

  Future<void> _handleChatResponseLost(P2PMessage msg) async {
    final userId = msg.fromUserId;
    final syncId = msg.data['syncId'] as String;
    _chatService.handleFileRequestLost(userId, syncId);
  }

  /// Auto-cleanup completed or cancelled transfer tasks
  Future<void> _autoCleanupTask(String taskId, String reason) async {
    try {
      final task = _activeTransfers[taskId];
      if (task == null) return;

      // Only auto-cleanup if task is in terminal state
      if (task.status == DataTransferStatus.completed ||
          task.status == DataTransferStatus.cancelled ||
          task.status == DataTransferStatus.failed) {
        logInfo(
            'P2PTransferService: Auto-cleaning up task $taskId (reason: $reason)');

        // Remove from active transfers
        _activeTransfers.remove(taskId);

        // Remove from Isar database
        final isar = IsarService.isar;
        await isar.writeTxn(() async {
          await isar.dataTransferTasks.delete(task.isarId);
        });

        // Clean up any associated resources
        _cleanupTransfer(taskId);

        notifyListeners();

        logInfo('P2PTransferService: Successfully auto-cleaned task $taskId');
      }
    } catch (e) {
      logError('P2PTransferService: Failed to auto-cleanup task $taskId: $e');
    }
  }

  /// Clear in-memory transfer data (used when clearing all transfer data from database)
  void clearInMemoryTransferData() {
    // Clear pending file transfer requests
    _pendingFileTransferRequests.clear();

    // Cancel and clear all active transfers
    cancelAllTransfers();

    // Clear all memory caches
    _incomingFileChunks.clear();
    _tempFileChunks.clear();
    _receivedFileMessageIds.clear();
    _taskCreationLocks.clear();
    _pendingChunks.clear();
    _batchDownloadPaths.clear();
    _batchFileCounts.clear();
    _activeBatchIdsByUser.clear();

    // Cancel all timers
    for (final timer in _fileTransferRequestTimers.values) {
      timer.cancel();
    }
    _fileTransferRequestTimers.clear();

    for (final timer in _fileTransferResponseTimers.values) {
      timer.cancel();
    }
    _fileTransferResponseTimers.clear();

    // Clear encryption session keys
    clearAllSessionKeys();

    notifyListeners();
    logInfo('P2PTransferService: In-memory transfer data cleared');
  }

  @override
  void dispose() {
    logInfo('P2PTransferService: Disposing...');
    cancelAllTransfers();

    // Cancel all timers
    for (final timer in _fileTransferRequestTimers.values) {
      timer.cancel();
    }
    _fileTransferRequestTimers.clear();

    // Clear all memory caches
    _incomingFileChunks.clear();
    _activeTransfers.clear();

    // Clear encryption session keys
    clearAllSessionKeys();

    super.dispose();
  }
}
