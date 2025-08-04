import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';
import 'package:p2lantransfer/services/encryption_service.dart';
import 'package:p2lantransfer/services/performance_optimizer_service.dart';
import 'package:p2lantransfer/services/app_logger.dart';

/// Enhanced transfer service combining encryption and performance optimization
/// This is a demonstration of how to integrate the new services
class EnhancedTransferService {
  static final Map<String, Uint8List> _sessionKeys = {};

  /// Demo: Send encrypted and optimized file chunk
  static Future<bool> sendEnhancedChunk({
    required String taskId,
    required Uint8List chunkData,
    required Socket socket,
    required String targetUserId,
    required String targetIP,
    required bool isLast,
    String? fileName,
    int? fileSize,
  }) async {
    try {
      // 1. Get or generate session key for this connection
      final sessionKey = _getSessionKey(targetUserId);

      // 2. Get optimized transfer parameters
      final params =
          await PerformanceOptimizerService.getOptimizedParameters(targetIP);
      logInfo('Enhanced Transfer: Using params: $params');

      // 3. Optimize socket
      PerformanceOptimizerService.optimizeTCPSocket(socket);

      // 4. Encrypt chunk data using AES-GCM
      final encryptedData = EncryptionService.encryptGCM(chunkData, sessionKey);

      // 5. Create enhanced message payload
      final dataPayload = {
        'taskId': taskId,
        'ct': base64Encode(encryptedData['ciphertext']!),
        'iv': base64Encode(encryptedData['iv']!),
        'tag': base64Encode(encryptedData['tag']!),
        'enc': 'gcm',
        'isLast': isLast,
        'encryptionVersion': '2.0-gcm', // New version
        'compressionUsed': false,
      };

      if (fileName != null) dataPayload['fileName'] = fileName;
      if (fileSize != null) dataPayload['fileSize'] = fileSize;

      // 6. Create message
      final message = {
        'type': 'enhanced_data_chunk',
        'fromUserId': 'current_user_id', // Would be injected
        'toUserId': targetUserId,
        'data': dataPayload,
        'timestamp': DateTime.now().toIso8601String(),
      };

      // 7. Send with proper framing
      final messageBytes = utf8.encode(jsonEncode(message));
      final lengthHeader = ByteData(4)
        ..setUint32(0, messageBytes.length, Endian.big);

      socket.add(lengthHeader.buffer.asUint8List());
      socket.add(messageBytes);
      await socket.flush();

      // 8. Record performance metrics
      final speedBps = chunkData.length / 0.1; // Placeholder calculation
      PerformanceOptimizerService.recordTransferMetrics(
        chunkSize: chunkData.length,
        speedMBps: speedBps / (1024 * 1024),
        rtt: params.rtt,
        successful: true,
        concurrency: params.concurrency,
      );

      logInfo(
          'Enhanced Transfer: Sent encrypted chunk (${chunkData.length} bytes)');
      return true;
    } catch (e) {
      logError('Enhanced Transfer: Failed to send chunk: $e');
      return false;
    }
  }

  /// Demo: Receive and decrypt enhanced chunk
  static Uint8List? receiveEnhancedChunk({
    required Map<String, dynamic> messageData,
    required String fromUserId,
  }) {
    try {
      final data = messageData['data'] as Map<String, dynamic>;

      // 1. Get session key for this user
      final sessionKey = _getSessionKey(fromUserId);

      // 2. Check encryption type
      final encType = data['enc'] as String?;
      if (encType != 'gcm') {
        logWarning('Enhanced Transfer: Unsupported encryption type: $encType');
        return null;
      }

      // 3. Decrypt chunk data using GCM
      final encryptedMap = {
        'ciphertext': base64Decode(data['ct'] as String),
        'iv': base64Decode(data['iv'] as String),
        'tag': base64Decode(data['tag'] as String),
      };

      final chunkData = EncryptionService.decryptGCM(encryptedMap, sessionKey);

      if (chunkData == null) {
        logError('Enhanced Transfer: Failed to decrypt chunk from $fromUserId');
        return null;
      }

      logInfo(
          'Enhanced Transfer: Received and decrypted chunk (${chunkData.length} bytes)');
      return chunkData;
    } catch (e) {
      logError('Enhanced Transfer: Failed to receive chunk: $e');
      return null;
    }
  }

  /// Demo: Establish encrypted session with peer
  static Future<bool> establishSecureSession({
    required String targetUserId,
    required String targetIP,
    required int targetPort,
  }) async {
    try {
      // In a real implementation, this would use a key exchange protocol
      // like Diffie-Hellman or use the existing pairing mechanism

      // For demo purposes, generate a session key
      final sessionKey = EncryptionService.generateKey();
      _sessionKeys[targetUserId] = sessionKey;

      // Send key exchange message (in real implementation, this would be
      // properly encrypted and authenticated)
      final socket = await Socket.connect(targetIP, targetPort);
      PerformanceOptimizerService.optimizeTCPSocket(socket);

      final keyExchangeMessage = {
        'type': 'key_exchange_demo',
        'sessionKey': base64Encode(sessionKey),
        'timestamp': DateTime.now().toIso8601String(),
      };

      final messageBytes = utf8.encode(jsonEncode(keyExchangeMessage));
      final lengthHeader = ByteData(4)
        ..setUint32(0, messageBytes.length, Endian.big);

      socket.add(lengthHeader.buffer.asUint8List());
      socket.add(messageBytes);
      await socket.flush();
      await socket.close();

      logInfo(
          'Enhanced Transfer: Secure session established with $targetUserId');
      return true;
    } catch (e) {
      logError('Enhanced Transfer: Failed to establish secure session: $e');
      return false;
    }
  }

  /// Demo: Performance benchmark
  static Future<Map<String, dynamic>> runPerformanceBenchmark({
    required String targetIP,
    required int targetPort,
  }) async {
    final results = <String, dynamic>{};

    try {
      // Test different chunk sizes
      final chunkSizes = [
        64 * 1024,
        256 * 1024,
        512 * 1024,
        1024 * 1024,
        2048 * 1024
      ];
      final testData =
          Uint8List.fromList(List.generate(2048 * 1024, (i) => i % 256));

      for (final chunkSize in chunkSizes) {
        final startTime = DateTime.now();

        // Simulate encrypted transfer with GCM
        final chunk = testData.sublist(0, chunkSize);
        final sessionKey = EncryptionService.generateKey();
        final encrypted = EncryptionService.encryptGCM(chunk, sessionKey);
        final decrypted = EncryptionService.decryptGCM(encrypted, sessionKey);

        final encryptionTime = DateTime.now().difference(startTime);

        // Test network parameters
        final rtt = await PerformanceOptimizerService.estimateRTT(targetIP);
        final bandwidth = await PerformanceOptimizerService.estimateBandwidth();

        results['${chunkSize ~/ 1024}KB'] = {
          'encryptionTime': encryptionTime.inMicroseconds,
          'rtt': rtt,
          'bandwidth': bandwidth,
          'decryptionSuccess':
              decrypted != null && decrypted.length == chunk.length,
        };
      }

      // Get optimal parameters
      final optimalParams =
          await PerformanceOptimizerService.getOptimizedParameters(targetIP);
      results['optimal'] = {
        'chunkSize': optimalParams.chunkSize,
        'concurrency': optimalParams.concurrency,
        'bandwidth': optimalParams.bandwidth,
        'rtt': optimalParams.rtt,
      };

      logInfo('Enhanced Transfer: Benchmark completed');
    } catch (e) {
      logError('Enhanced Transfer: Benchmark failed: $e');
      results['error'] = e.toString();
    }

    return results;
  }

  /// Get or generate session key for a user
  static Uint8List _getSessionKey(String userId) {
    return _sessionKeys[userId] ??= EncryptionService.generateKey();
  }

  /// Clear session keys (call on logout/reset)
  static void clearSessionKeys() {
    _sessionKeys.clear();
    logInfo('Enhanced Transfer: Session keys cleared');
  }

  /// Get transfer statistics
  static Map<String, dynamic> getTransferStats() {
    return {
      'activeSessions': _sessionKeys.length,
      'encryptionEnabled': true,
      'performanceOptimizationEnabled': true,
      'supportedProtocols': ['TCP', 'UDP'],
      'encryptionAlgorithm': 'AES-256-GCM', // Updated algorithm
      'version': '2.0.0',
    };
  }
}
