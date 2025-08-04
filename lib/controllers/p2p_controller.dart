import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:p2lantransfer/models/p2p_chat.dart';
import 'package:p2lantransfer/models/p2p_models.dart';
import 'package:p2lantransfer/screens/p2lan_transfer/p2lan_local_files_screen.dart';
import 'package:p2lantransfer/services/isar_service.dart';
import 'package:p2lantransfer/services/network_security_service.dart';
import 'package:p2lantransfer/services/p2p_services/p2p_chat_service.dart';
import 'package:p2lantransfer/services/p2p_services/p2p_service_manager.dart';
import 'package:p2lantransfer/services/app_logger.dart';
import 'package:p2lantransfer/l10n/app_localizations.dart';

class P2PController with ChangeNotifier {
  // Chat service
  late final P2PChatService _p2pChatService = P2PChatService(IsarService.isar);
  final P2PServiceManager _p2pService = P2PServiceManager.instance;

  // UI State
  bool _isInitialized = false;
  bool _showSecurityWarning = false;
  String? _errorMessage;

  // Network state
  NetworkInfo? _networkInfo;

  // Selected items
  P2PUser? _selectedUser;
  String? _selectedFile;

  // Discovery state
  bool _isRefreshing = false;
  bool _hasPerformedInitialDiscovery = false;
  DateTime? _lastDiscoveryTime;
  final Completer<void> _initCompleter = Completer<void>();

  // Connectivity monitoring
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _wasPreviouslyEnabled =
      false; // Track if P2P was enabled before connection loss
  bool _isTemporarilyDisabled =
      false; // Track if P2P is temporarily disabled due to no internet

  // Callback for new pairing requests
  // ignore: unused_field
  Function(PairingRequest)? _onNewPairingRequest;

  // Callback for new file transfer requests
  Function(FileTransferRequest)? _onNewFileTransferRequest;

  P2PController() {
    _p2pService.addListener(_onP2PServiceChanged);
  }

  // Getters
  bool get isInitialized => _isInitialized;
  Future<void> get initializationComplete => _initCompleter.future;
  bool get isEnabled => _p2pService.isEnabled;
  bool get isDiscovering => _p2pService.isDiscovering;
  bool get showSecurityWarning => _showSecurityWarning;
  String? get errorMessage => _errorMessage;
  NetworkInfo? get networkInfo => _networkInfo;
  ConnectionStatus get connectionStatus => _p2pService.connectionStatus;
  P2PUser? get currentUser => _p2pService.currentUser;
  List<P2PUser> get discoveredUsers => _p2pService.discoveredUsers;
  List<P2PUser> get pairedUsers => _p2pService.pairedUsers;
  P2PChatService get p2pChatService => _p2pChatService;

  /// Saved devices (stored connections) - ensure no duplicates
  List<P2PUser> get connectedUsers {
    final users = _p2pService.connectedUsers; // This returns isStored users
    return _deduplicateUsers(users);
  }

  /// All devices with duplicates removed
  List<P2PUser> get unconnectedUsers {
    final users =
        _p2pService.discoveredUsers.where((user) => !user.isStored).toList();
    return _deduplicateUsers(users);
  }

  /// Online saved devices (green background)
  List<P2PUser> get onlineDevices {
    return discoveredUsers.where((user) => user.isOnlineSaved).toList();
  }

  P2PUser? getUserById(String userId) {
    try {
      return discoveredUsers.firstWhere((user) => user.id == userId);
    } catch (e) {
      return null;
    }
  }

  /// Offline saved devices (gray background)
  bool isUserOnline(String userId) {
    final user = discoveredUsers.firstWhere(
      (user) => user.id == userId,
      orElse: () => P2PUser.create(
          displayName: '',
          profileId: '',
          ipAddress: '',
          port: 0,
          isOnline: false),
    );
    return user.isOnline;
  }

  /// New discovered devices (blue background)
  List<P2PUser> get newDevices {
    return discoveredUsers.where((user) => user.isNewDevice).toList();
  }

  /// Offline saved devices (gray background)
  List<P2PUser> get savedDevices {
    return discoveredUsers.where((user) => user.isOfflineSaved).toList();
  }

  /// Check if any device category has data
  bool get hasOnlineDevices => onlineDevices.isNotEmpty;
  bool get hasNewDevices => newDevices.isNotEmpty;
  bool get hasSavedDevices => savedDevices.isNotEmpty;

  /// Deduplicate users by multiple criteria to prevent UI duplicates
  List<P2PUser> _deduplicateUsers(List<P2PUser> users) {
    final uniqueUsers = <String, P2PUser>{};
    final ipPortCombos = <String, P2PUser>{};

    for (final user in users) {
      final ipPortKey = '${user.ipAddress}:${user.port}';

      // Check for duplicates by ID first
      final existingById = uniqueUsers[user.id];
      if (existingById == null) {
        // Check for duplicates by IP:Port
        final existingByIpPort = ipPortCombos[ipPortKey];
        if (existingByIpPort == null) {
          // No duplicates found, add user
          uniqueUsers[user.id] = user;
          ipPortCombos[ipPortKey] = user;
        } else {
          // Found duplicate by IP:Port, keep the better one
          final betterUser = _chooseBetterUser(existingByIpPort, user);

          // Remove old entries
          uniqueUsers.remove(existingByIpPort.id);
          ipPortCombos.remove(ipPortKey);

          // Add better user
          uniqueUsers[betterUser.id] = betterUser;
          ipPortCombos[ipPortKey] = betterUser;
        }
      } else {
        // Found duplicate by ID, merge data and keep the better one
        final mergedUser = _mergeUserData(existingById, user);
        uniqueUsers[user.id] = mergedUser;
        ipPortCombos[ipPortKey] = mergedUser;
      }
    }

    return uniqueUsers.values.toList();
  }

  /// Choose the better user when duplicates are found
  P2PUser _chooseBetterUser(P2PUser user1, P2PUser user2) {
    // Priority order:
    // 1. Stored users over non-stored
    // 2. Paired users over non-paired
    // 3. Trusted users over non-trusted
    // 4. Online users over offline
    // 5. More recent lastSeen

    if (user1.isStored != user2.isStored) {
      return user1.isStored ? user1 : user2;
    }

    if (user1.isPaired != user2.isPaired) {
      return user1.isPaired ? user1 : user2;
    }

    if (user1.isTrusted != user2.isTrusted) {
      return user1.isTrusted ? user1 : user2;
    }

    if (user1.isOnline != user2.isOnline) {
      return user1.isOnline ? user1 : user2;
    }

    // Choose more recent
    return user1.lastSeen.isAfter(user2.lastSeen) ? user1 : user2;
  }

  /// Merge data from two user objects
  P2PUser _mergeUserData(P2PUser primary, P2PUser secondary) {
    // Use primary as base and update with better data from secondary
    if (secondary.isStored && !primary.isStored) {
      primary.isStored = secondary.isStored;
      primary.isPaired = secondary.isPaired;
      primary.isTrusted = secondary.isTrusted;
      primary.pairedAt = secondary.pairedAt;
    }

    // Update network info if secondary is more recent
    if (secondary.lastSeen.isAfter(primary.lastSeen)) {
      primary.ipAddress = secondary.ipAddress;
      primary.port = secondary.port;
      primary.lastSeen = secondary.lastSeen;
      primary.isOnline = secondary.isOnline;
    }

    // Update display name if secondary has a better name
    if (primary.displayName.startsWith('Device-') &&
        !secondary.displayName.startsWith('Device-')) {
      primary.displayName = secondary.displayName;
    }

    return primary;
  }

  List<PairingRequest> get pendingRequests => _p2pService.pendingRequests;
  List<DataTransferTask> get activeTransfers => _p2pService.activeTransfers;
  List<FileTransferRequest> get pendingFileTransferRequests =>
      _p2pService.pendingFileTransferRequests;
  P2PUser? get selectedUser => _selectedUser;
  String? get selectedFile => _selectedFile;
  bool get isRefreshing => _isRefreshing;
  bool get hasPerformedInitialDiscovery => _hasPerformedInitialDiscovery;
  DateTime? get lastDiscoveryTime => _lastDiscoveryTime;
  bool get isBroadcasting => _p2pService.isBroadcasting;
  bool get isTemporarilyDisabled => _isTemporarilyDisabled;

  /// Access to P2P service for advanced operations
  P2PServiceManager get p2pService => _p2pService;

  /// Initialize the controller
  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      // Initialize P2P services with proper initialization order
      await P2PServiceManager.init();

      // Automatically check network status on initialization
      await _checkInitialNetworkStatus();
      // Start monitoring connectivity changes
      _startConnectivityMonitoring();
      _isInitialized = true;
      if (!_initCompleter.isCompleted) {
        _initCompleter.complete();
      }
    } catch (e) {
      _errorMessage = 'Failed to initialize P2P Controller: $e';
      logError(_errorMessage!);
      if (!_initCompleter.isCompleted) {
        _initCompleter.completeError(e);
      }
    } finally {
      notifyListeners();
    }
  }

  /// Check the initial network status without starting networking or requesting permissions
  Future<void> _checkInitialNetworkStatus() async {
    try {
      _networkInfo = await NetworkSecurityService.checkNetworkSecurity();
      logInfo(
          'Initial network status checked - no permission requests made yet');
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to check network status: $e';
      logError(_errorMessage!);
      notifyListeners();
    }
  }

  /// Check network and start P2P if conditions are met
  Future<bool> checkAndStartNetworking() async {
    try {
      _errorMessage = null;

      _networkInfo = await NetworkSecurityService.checkNetworkSecurity();
      if (_networkInfo == null || !_networkInfo!.isSecure) {
        _showSecurityWarning = true;
        notifyListeners();
        return false;
      }
      _showSecurityWarning = false;

      // Enable the service, which will handle discovery
      await _p2pService.enable();

      if (_p2pService.isEnabled && !_hasPerformedInitialDiscovery) {
        await refreshDiscoveredUsers();
      }
      notifyListeners();
      return _p2pService.isEnabled;
    } catch (e) {
      _errorMessage = 'Failed to start networking: $e';
      logError(_errorMessage!);
      notifyListeners();
      return false;
    }
  }

  /// Start networking after user confirms security warning
  Future<bool> startNetworkingWithWarning() async {
    try {
      _errorMessage = null;
      _showSecurityWarning = false;

      // Enable the service, which will handle discovery
      await _p2pService.enable();

      if (_p2pService.isEnabled && !_hasPerformedInitialDiscovery) {
        await refreshDiscoveredUsers();
      }
      notifyListeners();
      return _p2pService.isEnabled;
    } catch (e) {
      _errorMessage = 'Failed to start networking with warning: $e';
      logError(_errorMessage!);
      notifyListeners();
      return false;
    }
  }

  /// Stop P2P networking
  Future<void> stopNetworking() async {
    try {
      await _p2pService.stopNetworking();
      _showSecurityWarning = false;
      _errorMessage = null;
      // Reset temporary disabled state when manually stopping
      _isTemporarilyDisabled = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to stop P2P networking: $e';
      logError(_errorMessage!);
      notifyListeners();
    }
  }

  /// Start monitoring connectivity changes
  void _startConnectivityMonitoring() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((results) {
      _handleConnectivityChange(results);
    });
    logInfo('P2P connectivity monitoring started');
  }

  /// Handle connectivity state changes
  void _handleConnectivityChange(List<ConnectivityResult> results) async {
    final hasConnection =
        results.any((result) => result != ConnectivityResult.none);

    logInfo('Connectivity changed: $results, hasConnection: $hasConnection');

    if (!hasConnection) {
      // Lost internet connection
      if (_p2pService.isEnabled) {
        logInfo(
            'Lost internet connection. Temporarily disabling P2P networking.');
        _wasPreviouslyEnabled = true;
        _isTemporarilyDisabled = true;

        try {
          await _p2pService.stopNetworking();
          _showSecurityWarning = false;
          _errorMessage = 'P2P temporarily disabled - no internet connection';
          _resetDiscoveryState();
          notifyListeners();
        } catch (e) {
          logError('Error stopping P2P networking on connectivity loss: $e');
        }
      }
    } else {
      // Gained internet connection
      if (_wasPreviouslyEnabled && _isTemporarilyDisabled) {
        logInfo('Internet connection restored. Re-enabling P2P networking.');
        _isTemporarilyDisabled = false;
        _wasPreviouslyEnabled = false;

        try {
          // Small delay to ensure network is fully established
          await Future.delayed(const Duration(seconds: 2));

          await _p2pService.enable();
          if (_p2pService.isEnabled) {
            _errorMessage = null;
            await _checkInitialNetworkStatus();
            logInfo('P2P networking automatically restored');
          } else {
            _errorMessage = 'Failed to restore P2P networking automatically';
            logError('Failed to automatically restore P2P networking');
          }
          notifyListeners();
        } catch (e) {
          _errorMessage = 'Error restoring P2P networking: $e';
          logError('Error restoring P2P networking on connectivity gain: $e');
          notifyListeners();
        }
      }
    }
  }

  /// Dismiss security warning
  void dismissSecurityWarning() {
    _showSecurityWarning = false;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Select user for pairing or data transfer
  void selectUser(P2PUser user) {
    _selectedUser = user;
    notifyListeners();
  }

  /// Clear selected user
  void clearSelectedUser() {
    _selectedUser = null;
    notifyListeners();
  }

  /// Send pairing request
  Future<bool> sendPairingRequest(
      P2PUser targetUser, bool saveConnection, bool trustUser) async {
    try {
      _errorMessage = null;
      final success =
          await _p2pService.sendPairingRequest(targetUser, saveConnection);
      if (!success) {
        _errorMessage = 'Failed to send pairing request';
      }
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Respond to pairing request
  Future<bool> respondToPairingRequest(String requestId, bool accept,
      bool trustUser, bool saveConnection) async {
    try {
      _errorMessage = null;
      final success = await _p2pService.respondToPairingRequest(
          requestId, accept, trustUser, saveConnection);
      if (!success) {
        _errorMessage = 'Failed to respond to pairing request';
      }
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Set selected file for transfer
  void setSelectedFile(String filePath) {
    _selectedFile = filePath;
    notifyListeners();
  }

  /// Send file to selected user
  Future<bool> sendDataToUser(String filePath, P2PUser targetUser) async {
    try {
      _errorMessage = null;
      final success = await _p2pService.sendData(filePath, targetUser);
      if (!success) {
        _errorMessage = 'Failed to start data transfer';
      }
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Send multiple files to user
  Future<bool> sendMultipleFilesToUser(
      List<String> filePaths, P2PUser targetUser,
      {bool transferOnly = true}) async {
    try {
      _errorMessage = null;
      final success = await _p2pService.sendMultipleFilesToUser(
          filePaths, targetUser, transferOnly);
      if (!success) {
        _errorMessage = 'Failed to send files';
      }
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Cancel data transfer
  Future<bool> cancelDataTransfer(String taskId) async {
    try {
      _errorMessage = null;
      final success = await _p2pService.cancelDataTransfer(taskId);
      if (!success) {
        _errorMessage = 'Failed to cancel data transfer';
      }
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Get network status description (requires context for localization)
  String getNetworkStatusDescription(AppLocalizations l10n) {
    if (_isTemporarilyDisabled) {
      return l10n.p2pTemporarilyDisabled;
    }

    if (_networkInfo == null) return l10n.checkingNetwork;

    if (_networkInfo!.isMobile) {
      return l10n.connectedViaMobileData;
    } else if (_networkInfo!.isWiFi) {
      final securityText = _networkInfo!.isSecure ? l10n.secure : l10n.unsecure;
      // Simplify WiFi name display - just show "WiFi" instead of "Unknown WiFi"
      final wifiName = _networkInfo!.wifiName?.isNotEmpty == true
          ? _networkInfo!.wifiName!
          : "WiFi";
      return l10n.connectedToWifi(wifiName, securityText);
    } else if (_networkInfo!.securityType == 'ETHERNET') {
      return l10n.connectedViaEthernet;
    } else {
      return l10n.noNetworkConnection;
    }
  }

  /// Get connection status description (requires context for localization)
  String getConnectionStatusDescription(AppLocalizations l10n) {
    switch (connectionStatus) {
      case ConnectionStatus.disconnected:
        return l10n.disconnected;
      case ConnectionStatus.discovering:
        return l10n.discoveringDevices;
      case ConnectionStatus.connected:
        return l10n.connected;
      case ConnectionStatus.pairing:
        return l10n.pairing;
      case ConnectionStatus.paired:
        return l10n.paired;
    }
  }

  /// Get data transfer progress text
  String getTransferProgressText(DataTransferTask task) {
    final progress = (task.progress * 100).toStringAsFixed(1);
    final transferred = _formatBytes(task.transferredBytes);
    final total = _formatBytes(task.fileSize);
    return '$progress% ($transferred / $total)';
  }

  /// Format bytes to human readable string
  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  /// Get status icon for user
  IconData getUserStatusIcon(P2PUser user) {
    if (!user.isOnline) return Icons.offline_bolt;
    if (user.isPaired && user.isTrusted) return Icons.verified_user;
    if (user.isPaired) return Icons.link;
    return Icons.person;
  }

  /// Get status color for user
  Color getUserStatusColor(P2PUser user) {
    switch (user.connectionDisplayStatus) {
      case ConnectionDisplayStatus.discovered:
        return Colors.blue; // Xanh dương - thiết bị mới phát hiện
      case ConnectionDisplayStatus.connectedOnline:
        return Colors.green; // Xanh lá - đã kết nối và online
      case ConnectionDisplayStatus.connectedOffline:
        return Colors.grey; // Xám - đã kết nối nhưng offline
    }
  }

  /// Get transfer status icon
  IconData getTransferStatusIcon(DataTransferTask task) {
    switch (task.status) {
      case DataTransferStatus.pending:
        return Icons.schedule;
      case DataTransferStatus.requesting:
        return Icons.help_outline;
      case DataTransferStatus.waitingForApproval:
        return Icons.hourglass_empty;
      case DataTransferStatus.transferring:
        return Icons.sync;
      case DataTransferStatus.completed:
        return Icons.check_circle;
      case DataTransferStatus.failed:
        return Icons.error;
      case DataTransferStatus.cancelled:
        return Icons.cancel;
      case DataTransferStatus.rejected:
        return Icons.block;
    }
  }

  /// Get transfer status color
  Color getTransferStatusColor(DataTransferTask task) {
    switch (task.status) {
      case DataTransferStatus.pending:
        return Colors.orange;
      case DataTransferStatus.requesting:
        return Colors.blue;
      case DataTransferStatus.waitingForApproval:
        return Colors.orange;
      case DataTransferStatus.transferring:
        return Colors.green;
      case DataTransferStatus.completed:
        return Colors.green;
      case DataTransferStatus.failed:
        return Colors.red;
      case DataTransferStatus.cancelled:
        return Colors.grey;
      case DataTransferStatus.rejected:
        return Colors.red;
    }
  }

  /// Get task status icon
  IconData getTaskStatusIcon(DataTransferTask task) {
    switch (task.status) {
      case DataTransferStatus.pending:
        return Icons.schedule;
      case DataTransferStatus.requesting:
        return Icons.sync;
      case DataTransferStatus.waitingForApproval:
        return Icons.hourglass_empty;
      case DataTransferStatus.transferring:
        return Icons.file_upload;
      case DataTransferStatus.completed:
        return Icons.check_circle;
      case DataTransferStatus.failed:
        return Icons.error;
      case DataTransferStatus.cancelled:
        return Icons.cancel;
      case DataTransferStatus.rejected:
        return Icons.block;
    }
  }

  /// Get task status color
  Color getTaskStatusColor(DataTransferTask task) {
    switch (task.status) {
      case DataTransferStatus.pending:
        return Colors.grey;
      case DataTransferStatus.requesting:
        return Colors.blue;
      case DataTransferStatus.waitingForApproval:
        return Colors.orange;
      case DataTransferStatus.transferring:
        return Colors.green;
      case DataTransferStatus.completed:
        return Colors.green;
      case DataTransferStatus.failed:
        return Colors.red;
      case DataTransferStatus.cancelled:
        return Colors.grey;
      case DataTransferStatus.rejected:
        return Colors.red;
    }
  }

  /// Manual discovery for refresh button
  Future<void> manualDiscovery() async {
    if (_isRefreshing) return;

    try {
      _isRefreshing = true;
      notifyListeners();

      await _p2pService.manualDiscovery();
      _lastDiscoveryTime = DateTime.now(); // Update time after discovery runs

      // Spinner chỉ xoay 10 giây thay vì 60 giây
      await Future.delayed(const Duration(seconds: 10));
    } catch (e) {
      _errorMessage = 'Discovery failed: $e';
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }

  /// Quick refresh for lightweight updates (temporarily disabled)
  Future<void> quickRefresh() async {
    if (!isEnabled) return;
    // Implementation will be added when quickRefresh is available in service
    logInfo('Quick refresh requested but not yet implemented');
  }

  /// Toggle broadcast announcements on/off
  Future<void> toggleBroadcast() async {
    if (!_p2pService.isEnabled) {
      _errorMessage = 'Networking must be enabled to toggle broadcast';
      notifyListeners();
      return;
    }

    try {
      await _p2pService.toggleBroadcast();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to toggle broadcast: $e';
      logError(_errorMessage!);
    } finally {
      notifyListeners();
    }
  }

  /// Reset discovery state when networking is stopped
  void _resetDiscoveryState() {
    _hasPerformedInitialDiscovery = false;
    _isRefreshing = false;
    // Broadcast state is reset automatically in the service
  }

  /// Unpair from user
  Future<bool> unpairUser(String userId) async {
    try {
      _errorMessage = null;
      final success = await _p2pService.unpairUser(userId);
      if (!success) {
        _errorMessage = 'Failed to unpair user';
      }
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Send trust request
  Future<bool> sendTrustRequest(P2PUser targetUser) async {
    try {
      _errorMessage = null;
      final success = await _p2pService.sendTrustRequest(targetUser);
      if (!success) {
        _errorMessage = 'Failed to send trust request';
      }
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Remove trust from user
  Future<bool> removeTrust(String userId) async {
    try {
      _errorMessage = null;
      final success = await _p2pService.removeTrust(userId);
      if (!success) {
        _errorMessage = 'Failed to remove trust';
      }
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Add trust to user (manually trust without request)
  Future<bool> addTrust(String userId) async {
    try {
      _errorMessage = null;
      final success = await _p2pService.addTrust(userId);
      if (!success) {
        _errorMessage = 'Failed to add trust';
      }
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Update file storage settings
  // Đã xóa updateFileStorageSettings và mọi tham chiếu đến P2PFileStorageSettings

  /// Get current file storage settings
  // Đã xóa getter fileStorageSettings

  /// Set callback for new pairing requests (for auto-showing dialogs)
  void setNewPairingRequestCallback(Function(PairingRequest)? callback) {
    _onNewPairingRequest = callback;
    _p2pService.setNewPairingRequestCallback(callback);
  }

  /// Clear new pairing request callback
  void clearNewPairingRequestCallback() {
    _onNewPairingRequest = null;
    _p2pService.setNewPairingRequestCallback(null);
  }

  /// Clear a transfer from the list
  void clearTransfer(String taskId) {
    _p2pService.clearTransfer(taskId);
  }

  /// Clear a transfer from the list and optionally delete the downloaded file
  Future<bool> clearTransferWithFile(String taskId, bool deleteFile) async {
    try {
      return await _p2pService.clearTransferWithFile(taskId, deleteFile);
    } catch (e) {
      _errorMessage = 'Failed to clear transfer: $e';
      logError(_errorMessage!);
      notifyListeners();
      return false;
    }
  }

  /// Update transfer settings
  Future<bool> updateTransferSettings(P2PDataTransferSettings settings) async {
    try {
      final success = await _p2pService.updateTransferSettings(settings);
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Get current transfer settings
  P2PDataTransferSettings? get transferSettings => _p2pService.transferSettings;

  /// Reload transfer settings from storage (for when settings changed externally)
  Future<void> reloadTransferSettings() async {
    try {
      await _p2pService.reloadTransferSettings();
      notifyListeners();
      logInfo('P2PController: Transfer settings reloaded');
    } catch (e) {
      _errorMessage = 'Failed to reload transfer settings: $e';
      logError(_errorMessage!);
      notifyListeners();
    }
  }

  /// Respond to file transfer request
  Future<bool> respondToFileTransferRequest(
      String requestId, bool accept, String? rejectMessage) async {
    try {
      _errorMessage = null;
      final success = await _p2pService.respondToFileTransferRequest(
          requestId, accept, rejectMessage);
      if (!success) {
        _errorMessage = 'Failed to respond to file transfer request';
      }
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Process pending file transfer requests when user returns to P2P screen
  /// This handles requests that arrived while the user was not on this screen
  void processPendingFileTransferRequests() {
    final pendingRequests = _p2pService.pendingFileTransferRequests;

    for (final request in pendingRequests) {
      // Calculate remaining time from 60 seconds since request was received
      final elapsed = DateTime.now().difference(request.requestTime);
      final remainingSeconds = 60 - elapsed.inSeconds;

      // Only show dialog if there's still time left (at least 5 seconds)
      if (remainingSeconds > 5 && _onNewFileTransferRequest != null) {
        // Show dialog with remaining countdown time
        // Note: The callback will receive the request, and the UI will calculate countdown
        _onNewFileTransferRequest!(request);
      }
    }
  }

  void _onP2PServiceChanged() {
    // This method now simply notifies listeners.
    // Specific event handling is done via direct callbacks for reliability.
    if (hasListeners) {
      notifyListeners();
    }
  }

  /// Override the dispose method to only remove the listener,
  /// preventing the P2P service from stopping when the UI is disposed.
  @override
  void dispose() {
    logInfo('P2PController disposed. Removing listener only.');
    _connectivitySubscription?.cancel();
    _p2pService.removeListener(_onP2PServiceChanged);
    clearNewPairingRequestCallback(); // Clean up callback
    clearNewFileTransferRequestCallback(); // Clean up file transfer callback
    // DO NOT call _p2pService.stopNetworking() here.
    // The service should persist in the background.
    super.dispose();
  }

  /// Set callback for new file transfer requests
  void setNewFileTransferRequestCallback(
      Function(FileTransferRequest)? callback) {
    _onNewFileTransferRequest = callback;
    _p2pService.setNewFileTransferRequestCallback(callback);
  }

  /// Clear callback for new file transfer requests
  void clearNewFileTransferRequestCallback() {
    _onNewFileTransferRequest = null;
    _p2pService.setNewFileTransferRequestCallback(null);
  }

  /// Manually refresh discovered users (force new discovery)
  Future<void> refreshDiscoveredUsers() async {
    if (_isRefreshing) return;
    _isRefreshing = true;
    _lastDiscoveryTime = DateTime.now();
    notifyListeners();

    try {
      // If service is already enabled, stop it first to force a full refresh
      if (_p2pService.isEnabled) {
        await _p2pService.stopNetworking();
      }
      // Enable the service, which will trigger a new discovery
      await _p2pService.enable();
      _hasPerformedInitialDiscovery = true;
    } catch (e) {
      _errorMessage = 'Failed to refresh discovered users: $e';
      logError(_errorMessage!);
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }

  void navigateToLocalFilesViewer(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const P2LanLocalFilesScreen(),
      ),
    );
  }

  /// SECTION: CHAT MANAGEMENT

  Future<List<P2PChat>> loadAllChatsTitle() async {
    try {
      return await _p2pChatService.getAllChatsWithoutMessages();
    } catch (e) {
      logError('Failed to load all chats: $e');
      rethrow;
    }
  }
}
