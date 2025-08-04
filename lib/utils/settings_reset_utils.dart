import 'package:p2lantransfer/models/settings_models.dart';
import 'package:p2lantransfer/models/p2p_models.dart';
import 'package:p2lantransfer/services/settings_models_service.dart';
import 'package:p2lantransfer/services/app_logger.dart';

/// Utility class for resetting settings to safe defaults
class SettingsResetUtils {
  /// Reset P2P settings to safe defaults (no encryption, no compression)
  static Future<void> resetP2PSettingsToSafeDefaults() async {
    try {
      logInfo('SettingsResetUtils: Resetting P2P settings to safe defaults');

      // Create safe default settings
      final safeSettings = P2PTransferSettingsData(
        // Keep existing download path if any
        downloadPath: '',
        createDateFolders: false,
        createSenderFolders: true,
        maxReceiveFileSize: 1073741824, // 1GB
        maxTotalReceiveSize: 5368709120, // 5GB
        maxConcurrentTasks: 3,
        sendProtocol: 'TCP',
        maxChunkSize: 1024, // 1MB chunks - safe for all devices
        customDisplayName: null,
        uiRefreshRateSeconds: 0,
        enableNotifications: false,
        rememberBatchExpandState: false,
        encryptionType: EncryptionType.none, // No encryption for stability
        enableCompression: false, // No compression to avoid crashes
        compressionAlgorithm: 'none',
        compressionThreshold: 1.1,
        adaptiveCompression: false,
      );

      // Save the safe settings
      await ExtensibleSettingsService.updateP2PTransferSettings(safeSettings);

      logInfo(
          'SettingsResetUtils: P2P settings reset to safe defaults successfully');
    } catch (e) {
      logError('SettingsResetUtils: Failed to reset P2P settings: $e');
      rethrow;
    }
  }

  /// Reset only the performance-related settings while keeping user preferences
  static Future<void> resetPerformanceSettings() async {
    try {
      logInfo('SettingsResetUtils: Resetting performance settings only');

      // Get current settings
      final currentSettings =
          await ExtensibleSettingsService.getP2PTransferSettings();

      // Update only performance-related fields
      final updatedSettings = currentSettings.copyWith(
        encryptionType: EncryptionType.none,
        enableCompression: false,
        compressionAlgorithm: 'none',
        adaptiveCompression: false,
        maxChunkSize: 1024, // Safe chunk size
        maxConcurrentTasks: 3, // Conservative concurrency
      );

      await ExtensibleSettingsService.updateP2PTransferSettings(
          updatedSettings);

      logInfo('SettingsResetUtils: Performance settings reset successfully');
    } catch (e) {
      logError('SettingsResetUtils: Failed to reset performance settings: $e');
      rethrow;
    }
  }

  /// Get current settings summary for debugging
  static Future<Map<String, dynamic>> getSettingsSummary() async {
    try {
      final settings = await ExtensibleSettingsService.getP2PTransferSettings();

      return {
        'encryptionType': settings.encryptionType.name,
        'enableCompression': settings.enableCompression,
        'compressionAlgorithm': settings.compressionAlgorithm,
        'adaptiveCompression': settings.adaptiveCompression,
        'maxChunkSize': settings.maxChunkSize,
        'maxConcurrentTasks': settings.maxConcurrentTasks,
        'sendProtocol': settings.sendProtocol,
      };
    } catch (e) {
      logError('SettingsResetUtils: Failed to get settings summary: $e');
      return {'error': e.toString()};
    }
  }
}
