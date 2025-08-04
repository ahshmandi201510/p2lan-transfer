import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';
import 'package:p2lantransfer/services/compression_service.dart';
import 'package:p2lantransfer/services/encryption_service.dart';
import 'package:p2lantransfer/services/performance_optimizer_service.dart';
import 'package:p2lantransfer/services/app_logger.dart';

/// Advanced transfer service with compression, encryption, and optimization
/// This demonstrates how to integrate all performance improvements
class AdvancedTransferService {
  static final Map<String, Uint8List> _sessionKeys = {};

  /// Send file with all optimizations enabled
  static Future<bool> sendOptimizedFile({
    required File file,
    required Socket socket,
    required String targetUserId,
    required String targetIP,
    String? fileName,
    bool enableCompression = true,
    bool enableEncryption = true,
  }) async {
    try {
      fileName ??= file.path.split('/').last;
      final fileSize = await file.length();

      logInfo(
          'AdvancedTransfer: Starting optimized transfer of $fileName (${_formatBytes(fileSize)})');

      // 1. Get optimal transfer parameters
      final params =
          await PerformanceOptimizerService.getOptimizedParameters(targetIP);
      logInfo('AdvancedTransfer: Using optimized params: $params');

      // 2. Optimize socket
      PerformanceOptimizerService.optimizeTCPSocket(socket);

      // 3. Read file in optimal chunks
      final stream = file.openRead();
      int chunkIndex = 0;
      int totalSent = 0;

      await for (final rawChunk in stream) {
        final chunk = Uint8List.fromList(rawChunk);
        final isLast = totalSent + chunk.length >= fileSize;

        // 4. Apply compression if beneficial
        Uint8List processedChunk = chunk;
        CompressionAlgorithm usedCompression = CompressionAlgorithm.none;

        if (enableCompression) {
          final compressionResult = await CompressionService.smartCompress(
            data: chunk,
            fileName: fileName,
            prioritizeSpeed: true,
          );

          if (compressionResult.isBeneficial) {
            processedChunk = compressionResult.compressedData;
            usedCompression = compressionResult.algorithm;

            logInfo('AdvancedTransfer: Compressed chunk $chunkIndex: '
                '${chunk.length} → ${processedChunk.length} bytes '
                '(${compressionResult.compressionRatio.toStringAsFixed(2)}x)');
          }
        }

        // 5. Encrypt if enabled
        Map<String, dynamic> dataPayload;
        if (enableEncryption) {
          final sessionKey = _getSessionKey(targetUserId);
          final encryptedData =
              EncryptionService.encryptGCM(processedChunk, sessionKey);

          dataPayload = {
            'chunkIndex': chunkIndex,
            'ct': base64Encode(encryptedData['ciphertext']!),
            'iv': base64Encode(encryptedData['iv']!),
            'tag': base64Encode(encryptedData['tag']!),
            'enc': 'aes-gcm',
            'compressed': usedCompression != CompressionAlgorithm.none,
            'compressionAlg': usedCompression.name,
            'originalSize': chunk.length,
            'isLast': isLast,
          };
        } else {
          dataPayload = {
            'chunkIndex': chunkIndex,
            'data': base64Encode(processedChunk),
            'compressed': usedCompression != CompressionAlgorithm.none,
            'compressionAlg': usedCompression.name,
            'originalSize': chunk.length,
            'isLast': isLast,
          };
        }

        // 6. Add metadata for first chunk
        if (chunkIndex == 0) {
          dataPayload.addAll({
            'fileName': fileName,
            'fileSize': fileSize,
            'version': '3.0-advanced',
          });
        }

        // 7. Create and send message
        final message = {
          'type': 'advanced_data_chunk',
          'fromUserId': 'current_user', // Would be injected
          'toUserId': targetUserId,
          'data': dataPayload,
          'timestamp': DateTime.now().toIso8601String(),
        };

        final messageBytes = utf8.encode(jsonEncode(message));
        final lengthHeader = ByteData(4)
          ..setUint32(0, messageBytes.length, Endian.big);

        socket.add(lengthHeader.buffer.asUint8List());
        socket.add(messageBytes);
        await socket.flush();

        // 8. Record metrics
        final speedBps = chunk.length / 0.1; // Placeholder
        PerformanceOptimizerService.recordTransferMetrics(
          chunkSize: chunk.length,
          speedMBps: speedBps / (1024 * 1024),
          rtt: params.rtt,
          successful: true,
          concurrency: 1,
        );

        totalSent += chunk.length;
        chunkIndex++;

        logInfo('AdvancedTransfer: Sent chunk $chunkIndex '
            '(${_formatBytes(totalSent)}/${_formatBytes(fileSize)})');
      }

      logInfo('AdvancedTransfer: File transfer completed successfully');
      return true;
    } catch (e) {
      logError('AdvancedTransfer: Failed to send file: $e');
      return false;
    }
  }

  /// Receive and process optimized file chunks
  static Future<Uint8List?> receiveOptimizedChunk({
    required Map<String, dynamic> messageData,
    required String fromUserId,
  }) async {
    try {
      final data = messageData['data'] as Map<String, dynamic>;

      // 1. Check if encrypted
      final isEncrypted = data.containsKey('ct');
      Uint8List processedChunk;

      if (isEncrypted) {
        // Decrypt first
        final sessionKey = _getSessionKey(fromUserId);
        final encryptedMap = {
          'ciphertext': base64Decode(data['ct'] as String),
          'iv': base64Decode(data['iv'] as String),
          'tag': base64Decode(data['tag'] as String),
        };

        final decrypted =
            EncryptionService.decryptGCM(encryptedMap, sessionKey);
        if (decrypted == null) {
          logError('AdvancedTransfer: Failed to decrypt chunk');
          return null;
        }
        processedChunk = decrypted;
      } else {
        processedChunk = base64Decode(data['data'] as String);
      }

      // 2. Check if compressed
      final isCompressed = data['compressed'] as bool? ?? false;
      if (isCompressed) {
        final algorithmName = data['compressionAlg'] as String? ?? 'none';
        final algorithm = CompressionAlgorithm.values.firstWhere(
          (e) => e.name == algorithmName,
          orElse: () => CompressionAlgorithm.none,
        );

        if (algorithm != CompressionAlgorithm.none) {
          processedChunk = await CompressionService.decompress(
            compressedData: processedChunk,
            algorithm: algorithm,
          );

          final originalSize =
              data['originalSize'] as int? ?? processedChunk.length;
          logInfo('AdvancedTransfer: Decompressed chunk: '
              '${processedChunk.length} → $originalSize bytes');
        }
      }

      return processedChunk;
    } catch (e) {
      logError('AdvancedTransfer: Failed to receive chunk: $e');
      return null;
    }
  }

  /// Benchmark different optimization strategies
  static Future<Map<String, dynamic>> benchmarkStrategies({
    required File testFile,
    required String targetIP,
  }) async {
    final results = <String, dynamic>{};
    final fileData = await testFile.readAsBytes();
    final fileName = testFile.path.split('/').last;

    try {
      // 1. Test compression effectiveness
      final compressionResults = await CompressionService.benchmark(
        sampleData: fileData,
        fileName: fileName,
      );

      results['compression'] = compressionResults.map(
        (alg, result) => MapEntry(alg.name, {
          'ratio': result.compressionRatio,
          'size_reduction': result.originalSize - result.compressedSize,
          'time_us': result.compressionTime,
          'speed_mbps': result.compressionSpeedMBps,
          'beneficial': result.isBeneficial,
        }),
      );

      // 2. Test network optimization
      final networkParams =
          await PerformanceOptimizerService.getOptimizedParameters(targetIP);
      results['network_optimization'] = {
        'optimal_chunk_size': networkParams.chunkSize,
        'optimal_concurrency': networkParams.concurrency,
        'estimated_bandwidth': networkParams.bandwidth,
        'estimated_rtt': networkParams.rtt,
      };

      // 3. Estimate transfer time with different strategies
      final fileSize = fileData.length;
      final bandwidth =
          networkParams.bandwidth * 1024 * 1024; // Convert to bytes/s

      results['transfer_estimates'] = {
        'unoptimized':
            _estimateTransferTime(fileSize, bandwidth * 0.6), // 60% efficiency
        'optimized_only':
            _estimateTransferTime(fileSize, bandwidth * 0.85), // 85% efficiency
        'compressed_gzip': _estimateTransferTime(
          (fileSize /
                  (compressionResults[CompressionAlgorithm.gzip]
                          ?.compressionRatio ??
                      1.0))
              .round(),
          bandwidth * 0.85,
        ),
        'compressed_deflate': _estimateTransferTime(
          (fileSize /
                  (compressionResults[CompressionAlgorithm.deflate]
                          ?.compressionRatio ??
                      1.0))
              .round(),
          bandwidth * 0.85,
        ),
      };

      // 4. Recommendations
      final bestCompression = compressionResults.values
          .where((r) => r.isBeneficial)
          .fold<CompressionResult?>(null, (best, current) {
        if (best == null) return current;
        return current.compressionRatio > best.compressionRatio
            ? current
            : best;
      });

      results['recommendations'] = {
        'use_compression': bestCompression != null,
        'best_compression': bestCompression?.algorithm.name,
        'estimated_improvement': bestCompression?.compressionRatio ?? 1.0,
        'file_type_analysis':
            CompressionService.shouldCompress(fileName, fileSize),
      };

      logInfo('AdvancedTransfer: Benchmark completed for $fileName');
    } catch (e) {
      logError('AdvancedTransfer: Benchmark failed: $e');
      results['error'] = e.toString();
    }

    return results;
  }

  // Helper methods
  static Uint8List _getSessionKey(String userId) {
    return _sessionKeys[userId] ??= EncryptionService.generateKey();
  }

  static String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024)
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  static double _estimateTransferTime(int bytes, double bytesPerSecond) {
    return bytes / bytesPerSecond; // seconds
  }
}
