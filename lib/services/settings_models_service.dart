import 'dart:convert';
import 'package:isar/isar.dart';
import 'package:p2lantransfer/models/settings_models.dart';
import 'package:p2lantransfer/services/app_logger.dart';
import 'package:p2lantransfer/services/isar_service.dart';

/// Service for managing ExtensibleSettings with extensible architecture
class ExtensibleSettingsService {
  // Model codes for different settings types
  static const String globalSettingsCode = 'global_settings';
  static const String userInterfaceSettingsCode = 'user_interface_settings';
  static const String converterToolsSettingsCode = 'converter_tools_settings';
  static const String randomToolsSettingsCode = 'random_tools_settings';
  static const String calculatorToolsSettingsCode = 'calculator_tools_settings';
  static const String textTemplateSettingsCode = 'text_template_settings';
  static const String p2pTransferSettingsCode = 'p2p_transfer_settings';

  /// Initialize the settings system and create defaults if needed
  /// Internal beta v0.5.0 - No migration needed
  static Future<void> initialize() async {
    logInfo("ExtensibleSettingsService: Initializing settings system...");

    // Ensure all default settings exist
    await _ensureDefaultSettings();

    logInfo("ExtensibleSettingsService: Initialization completed.");
  }

  /// Alias for initialize() for backward compatibility
  static Future<void> performMigration() async {
    await initialize();
  }

  /// Ensure all default settings exist
  static Future<void> _ensureDefaultSettings() async {
    await _ensureGlobalSettings();
    await _ensureUserInterfaceSettings();
    await _ensureP2PTransferSettings();
  }

  /// Ensure global settings exist with defaults
  static Future<void> _ensureGlobalSettings() async {
    final existing = await getSettingsModel(globalSettingsCode);
    if (existing == null) {
      final defaultData = GlobalSettingsData();
      await saveSettingsModel(
        globalSettingsCode,
        SettingsModelType.global,
        defaultData.toJson(),
      );
    }
  }

  /// Ensure user interface settings exist with defaults
  static Future<void> _ensureUserInterfaceSettings() async {
    final existing = await getSettingsModel(userInterfaceSettingsCode);
    if (existing == null) {
      final defaultData = UserInterfaceSettingsData();
      await saveSettingsModel(
        userInterfaceSettingsCode,
        SettingsModelType.userInterface,
        defaultData.toJson(),
      );
    }
  }

  /// Ensure P2P transfer settings exist with defaults
  static Future<void> _ensureP2PTransferSettings() async {
    final existing = await getSettingsModel(p2pTransferSettingsCode);
    if (existing == null) {
      final defaultData = P2PTransferSettingsData();
      await saveSettingsModel(
        p2pTransferSettingsCode,
        SettingsModelType.p2pTransfer,
        defaultData.toJson(),
      );
    }
  }

  /// Get a settings model by its code
  static Future<ExtensibleSettings?> getSettingsModel(String modelCode) async {
    final isar = IsarService.isar;
    return await isar.extensibleSettings
        .where()
        .modelCodeEqualTo(modelCode)
        .findFirst();
  }

  /// Save a settings model
  static Future<void> saveSettingsModel(
    String modelCode,
    SettingsModelType modelType,
    Map<String, dynamic> settingsData,
  ) async {
    final isar = IsarService.isar;

    await isar.writeTxn(() async {
      final existing = await isar.extensibleSettings
          .where()
          .modelCodeEqualTo(modelCode)
          .findFirst();

      if (existing != null) {
        // Update existing
        final updated = existing.copyWith(
          settingsJson: jsonEncode(settingsData),
        );
        await isar.extensibleSettings.put(updated);
      } else {
        // Create new
        final newModel = ExtensibleSettings(
          modelCode: modelCode,
          modelType: modelType,
          settingsJson: jsonEncode(settingsData),
        );
        await isar.extensibleSettings.put(newModel);
      }
    });

    logInfo("ExtensibleSettingsService: Settings saved for $modelCode");
  }

  /// Get global settings
  static Future<GlobalSettingsData> getGlobalSettings() async {
    final model = await getSettingsModel(globalSettingsCode);
    if (model == null) {
      await _ensureGlobalSettings();
      return GlobalSettingsData();
    }

    final json = jsonDecode(model.settingsJson) as Map<String, dynamic>;
    return GlobalSettingsData.fromJson(json);
  }

  /// Update global settings
  static Future<void> updateGlobalSettings(GlobalSettingsData data) async {
    await saveSettingsModel(
      globalSettingsCode,
      SettingsModelType.global,
      data.toJson(),
    );
  }

  /// Get user interface settings
  static Future<UserInterfaceSettingsData> getUserInterfaceSettings() async {
    final model = await getSettingsModel(userInterfaceSettingsCode);
    if (model == null) {
      await _ensureUserInterfaceSettings();
      return UserInterfaceSettingsData();
    }

    final json = jsonDecode(model.settingsJson) as Map<String, dynamic>;
    return UserInterfaceSettingsData.fromJson(json);
  }

  /// Update user interface settings
  static Future<void> updateUserInterfaceSettings(
      UserInterfaceSettingsData data) async {
    await saveSettingsModel(
      userInterfaceSettingsCode,
      SettingsModelType.userInterface,
      data.toJson(),
    );
  }

  /// Get P2P transfer settings
  static Future<P2PTransferSettingsData> getP2PTransferSettings() async {
    final model = await getSettingsModel(p2pTransferSettingsCode);
    if (model == null) {
      await _ensureP2PTransferSettings();
      return P2PTransferSettingsData();
    }

    final json = jsonDecode(model.settingsJson) as Map<String, dynamic>;
    return P2PTransferSettingsData.fromJson(json);
  }

  /// Update P2P transfer settings
  static Future<void> updateP2PTransferSettings(
      P2PTransferSettingsData data) async {
    await saveSettingsModel(
      p2pTransferSettingsCode,
      SettingsModelType.p2pTransfer,
      data.toJson(),
    );
  }

  /// Get all settings models
  static Future<List<ExtensibleSettings>> getAllSettingsModels() async {
    final isar = IsarService.isar;
    return await isar.extensibleSettings.where().findAll();
  }

  /// Delete a settings model by code
  static Future<void> deleteSettingsModel(String modelCode) async {
    final isar = IsarService.isar;

    await isar.writeTxn(() async {
      final existing = await isar.extensibleSettings
          .where()
          .modelCodeEqualTo(modelCode)
          .findFirst();

      if (existing != null) {
        await isar.extensibleSettings.delete(existing.id);
        logInfo("ExtensibleSettingsService: Deleted settings model $modelCode");
      }
    });
  }

  /// Clear all settings models (for debug/reset purposes)
  static Future<void> clearAllSettingsModels() async {
    final isar = IsarService.isar;

    await isar.writeTxn(() async {
      await isar.extensibleSettings.clear();
    });

    logInfo("ExtensibleSettingsService: All settings models cleared");
  }
}
