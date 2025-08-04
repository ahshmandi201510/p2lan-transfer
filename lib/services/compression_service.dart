import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:p2lantransfer/services/app_logger.dart';

// Compression algorithms available
enum CompressionAlgorithm {
  none,
  gzip,
  deflate,
  brotli, // Future: requires native implementation
}

/// Compression service for optimizing P2P data transfer
/// Supports multiple algorithms with smart selection
class CompressionService {
  // File extensions that benefit from compression
  static const Set<String> _compressibleExtensions = {
    // Text files
    'txt', 'json', 'xml', 'csv', 'html', 'js', 'dart', 'cpp', 'java', 'py',
    'css', 'scss', 'yaml', 'yml', 'md', 'log', 'conf', 'ini', 'sql',

    // Office documents
    'docx', 'xlsx', 'pptx', 'odt', 'ods', 'odp',

    // Uncompressed images
    'bmp', 'tiff', 'tga', 'svg',
  };

  // File extensions that are already compressed (avoid double compression)
  static const Set<String> _alreadyCompressedExtensions = {
    // Images
    'jpg', 'jpeg', 'png', 'gif', 'webp',

    // Videos
    'mp4', 'avi', 'mkv', 'mov', 'wmv', 'flv', 'webm',

    // Audio
    'mp3', 'aac', 'ogg', 'flac', 'wma',

    // Archives
    'zip', 'rar', '7z', 'tar', 'gz', 'bz2', 'xz',

    // Executables
    'exe', 'dll', 'so', 'dylib',
  };

  /// Determine if a file should be compressed based on its characteristics
  static bool shouldCompress(String fileName, int fileSize) {
    // Skip very small files (compression overhead not worth it)
    if (fileSize < 1024) return false; // < 1KB

    // Skip very large files to avoid memory issues
    if (fileSize > 100 * 1024 * 1024) return false; // > 100MB

    final extension = _getFileExtension(fileName);

    // Don't compress already compressed files
    if (_alreadyCompressedExtensions.contains(extension)) {
      return false;
    }

    // Compress known compressible files
    if (_compressibleExtensions.contains(extension)) {
      return true;
    }

    // For unknown extensions, use heuristic:
    // If file is text-like (high entropy of printable characters), compress it
    return false; // Conservative approach for unknown types
  }

  /// Get optimal compression algorithm based on file characteristics and performance requirements
  static CompressionAlgorithm getOptimalAlgorithm({
    required String fileName,
    required int fileSize,
    required bool prioritizeSpeed,
  }) {
    if (!shouldCompress(fileName, fileSize)) {
      return CompressionAlgorithm.none;
    }

    final extension = _getFileExtension(fileName);

    // For real-time P2P transfer, prioritize speed
    if (prioritizeSpeed) {
      // Gzip is fast and widely supported
      return CompressionAlgorithm.gzip;
    }

    // For text files, can use stronger compression
    if (_isTextFile(extension)) {
      return CompressionAlgorithm.deflate; // Better compression ratio
    }

    // Default to gzip for good balance
    return CompressionAlgorithm.gzip;
  }

  /// Compress data using specified algorithm
  static Future<CompressionResult> compress({
    required Uint8List data,
    required CompressionAlgorithm algorithm,
  }) async {
    if (algorithm == CompressionAlgorithm.none) {
      return CompressionResult(
        compressedData: data,
        originalSize: data.length,
        compressedSize: data.length,
        algorithm: algorithm,
        compressionRatio: 1.0,
      );
    }

    final stopwatch = Stopwatch()..start();

    try {
      Uint8List compressedData;

      switch (algorithm) {
        case CompressionAlgorithm.gzip:
          compressedData = Uint8List.fromList(GZipEncoder().encode(data)!);
          break;

        case CompressionAlgorithm.deflate:
          compressedData = Uint8List.fromList(ZLibEncoder().encode(data));
          break;

        case CompressionAlgorithm.brotli:
          // TODO: Implement Brotli when native support is available
          throw UnsupportedError('Brotli compression not yet implemented');

        case CompressionAlgorithm.none:
          compressedData = data;
          break;
      }

      stopwatch.stop();

      final result = CompressionResult(
        compressedData: compressedData,
        originalSize: data.length,
        compressedSize: compressedData.length,
        algorithm: algorithm,
        compressionRatio: data.length / compressedData.length,
        compressionTime: stopwatch.elapsedMicroseconds,
      );

      logInfo('Compression: ${data.length} → ${compressedData.length} bytes '
          '(${(result.compressionRatio * 100).toStringAsFixed(1)}% ratio) '
          'in ${stopwatch.elapsedMilliseconds}ms');

      return result;
    } catch (e) {
      logError('Compression failed: $e');
      // Fallback to uncompressed
      return CompressionResult(
        compressedData: data,
        originalSize: data.length,
        compressedSize: data.length,
        algorithm: CompressionAlgorithm.none,
        compressionRatio: 1.0,
        error: e.toString(),
      );
    }
  }

  /// Decompress data using specified algorithm
  static Future<Uint8List> decompress({
    required Uint8List compressedData,
    required CompressionAlgorithm algorithm,
  }) async {
    if (algorithm == CompressionAlgorithm.none) {
      return compressedData;
    }

    try {
      List<int> decompressedData;

      switch (algorithm) {
        case CompressionAlgorithm.gzip:
          decompressedData = GZipDecoder().decodeBytes(compressedData);
          break;

        case CompressionAlgorithm.deflate:
          decompressedData = ZLibDecoder().decodeBytes(compressedData);
          break;

        case CompressionAlgorithm.brotli:
          throw UnsupportedError('Brotli decompression not yet implemented');

        case CompressionAlgorithm.none:
          decompressedData = compressedData;
          break;
      }

      return Uint8List.fromList(decompressedData);
    } catch (e) {
      logError('Decompression failed: $e');
      throw Exception('Decompression failed: $e');
    }
  }

  /// Smart compression with automatic algorithm selection
  static Future<CompressionResult> smartCompress({
    required Uint8List data,
    required String fileName,
    bool prioritizeSpeed = true,
  }) async {
    final algorithm = getOptimalAlgorithm(
      fileName: fileName,
      fileSize: data.length,
      prioritizeSpeed: prioritizeSpeed,
    );

    return await compress(data: data, algorithm: algorithm);
  }

  /// Benchmark different compression algorithms on sample data
  static Future<Map<CompressionAlgorithm, CompressionResult>> benchmark({
    required Uint8List sampleData,
    required String fileName,
  }) async {
    final results = <CompressionAlgorithm, CompressionResult>{};

    // Test available algorithms
    final algorithms = [
      CompressionAlgorithm.none,
      CompressionAlgorithm.gzip,
      CompressionAlgorithm.deflate,
    ];

    for (final algorithm in algorithms) {
      final result = await compress(data: sampleData, algorithm: algorithm);
      results[algorithm] = result;

      logInfo('Benchmark $algorithm: '
          '${result.compressionRatio.toStringAsFixed(2)}x ratio, '
          '${result.compressionTime ?? 0}μs');
    }

    return results;
  }

  // Helper methods
  static String _getFileExtension(String fileName) {
    final lastDot = fileName.lastIndexOf('.');
    if (lastDot == -1 || lastDot == fileName.length - 1) {
      return '';
    }
    return fileName.substring(lastDot + 1).toLowerCase();
  }

  static bool _isTextFile(String extension) {
    const textExtensions = {
      'txt',
      'json',
      'xml',
      'csv',
      'html',
      'js',
      'dart',
      'cpp',
      'java',
      'py',
      'css',
      'scss',
      'yaml',
      'yml',
      'md',
      'log',
      'conf',
      'ini',
      'sql',
      'c',
      'h',
    };
    return textExtensions.contains(extension);
  }
}

/// Result of compression operation
class CompressionResult {
  final Uint8List compressedData;
  final int originalSize;
  final int compressedSize;
  final CompressionAlgorithm algorithm;
  final double compressionRatio;
  final int? compressionTime; // microseconds
  final String? error;

  CompressionResult({
    required this.compressedData,
    required this.originalSize,
    required this.compressedSize,
    required this.algorithm,
    required this.compressionRatio,
    this.compressionTime,
    this.error,
  });

  /// Whether compression was beneficial (saved at least 10% space)
  bool get isBeneficial => compressionRatio > 1.1;

  /// Compression speed in MB/s
  double? get compressionSpeedMBps {
    if (compressionTime == null || compressionTime == 0) return null;
    return (originalSize / (1024 * 1024)) / (compressionTime! / 1000000);
  }

  @override
  String toString() {
    return 'CompressionResult('
        'algorithm: $algorithm, '
        'size: $originalSize → $compressedSize bytes, '
        'ratio: ${compressionRatio.toStringAsFixed(2)}x, '
        'time: ${compressionTime ?? 0}μs'
        ')';
  }
}
