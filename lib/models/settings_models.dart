import 'dart:convert';
import 'package:isar/isar.dart';
import 'package:p2lantransfer/models/p2p_models.dart';

part 'settings_models.g.dart';

/// Enum for different types of settings models
enum SettingsModelType {
  global, // Global app settings
  userInterface, // User interface settings (theme, language, compact layout)
  converterTools, // Converter-specific settings
  randomTools, // Random tools-specific settings
  calculatorTools, // Calculator-specific settings
  textTemplate, // Text template-specific settings
  p2pTransfer, // P2P transfer-specific settings
  userProfile, // User profile settings (future)
}

@Collection()
class ExtensibleSettings {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  String modelCode; // Unique identifier for each settings type

  @Enumerated(EnumType.ordinal)
  SettingsModelType modelType;

  String settingsJson; // JSON string containing the actual settings data

  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  ExtensibleSettings({
    required this.modelCode,
    required this.modelType,
    required this.settingsJson,
  });

  ExtensibleSettings copyWith({
    String? modelCode,
    SettingsModelType? modelType,
    String? settingsJson,
  }) {
    final result = ExtensibleSettings(
      modelCode: modelCode ?? this.modelCode,
      modelType: modelType ?? this.modelType,
      settingsJson: settingsJson ?? this.settingsJson,
    );
    result.id = id;
    result.updatedAt = DateTime.now();
    return result;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'modelCode': modelCode,
      'modelType': modelType.index,
      'settingsJson': settingsJson,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory ExtensibleSettings.fromJson(Map<String, dynamic> json) {
    final result = ExtensibleSettings(
      modelCode: json['modelCode'] ?? '',
      modelType: SettingsModelType.values[json['modelType'] ?? 0],
      settingsJson: json['settingsJson'] ?? '{}',
    );
    result.id = json['id'] ?? Isar.autoIncrement;
    result.createdAt =
        DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now();
    result.updatedAt =
        DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now();
    return result;
  }

  /// Parse the settings JSON and return as a Map
  Map<String, dynamic> getSettingsAsMap() {
    try {
      final decoded =
          Map<String, dynamic>.from(const JsonDecoder().convert(settingsJson));
      return decoded;
    } catch (e) {
      // Return empty map if JSON parsing fails
      return <String, dynamic>{};
    }
  }
}

/// Global app settings data structure
class GlobalSettingsData {
  final bool featureStateSavingEnabled;
  final int logRetentionDays;
  final bool focusModeEnabled;

  GlobalSettingsData({
    this.featureStateSavingEnabled = true,
    this.logRetentionDays = 5,
    this.focusModeEnabled = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'featureStateSavingEnabled': featureStateSavingEnabled,
      'logRetentionDays': logRetentionDays,
      'focusModeEnabled': focusModeEnabled,
    };
  }

  factory GlobalSettingsData.fromJson(Map<String, dynamic> json) {
    return GlobalSettingsData(
      featureStateSavingEnabled: json['featureStateSavingEnabled'] ?? true,
      logRetentionDays: json['logRetentionDays'] ?? 5,
      focusModeEnabled: json['focusModeEnabled'] ?? false,
    );
  }

  GlobalSettingsData copyWith({
    bool? featureStateSavingEnabled,
    int? logRetentionDays,
    bool? focusModeEnabled,
  }) {
    return GlobalSettingsData(
      featureStateSavingEnabled:
          featureStateSavingEnabled ?? this.featureStateSavingEnabled,
      logRetentionDays: logRetentionDays ?? this.logRetentionDays,
      focusModeEnabled: focusModeEnabled ?? this.focusModeEnabled,
    );
  }
}

/// User Interface settings data structure
class UserInterfaceSettingsData {
  final String themeMode; // 'system', 'light', 'dark'
  final String languageCode; // 'en', 'vi', etc.
  final bool
      useCompactLayoutOnMobile; // Use compact mode for mobile tab layouts
  final bool showShortcutsInTooltips; // Show keyboard shortcuts in tooltips

  UserInterfaceSettingsData({
    this.themeMode = 'system',
    this.languageCode = 'en',
    this.useCompactLayoutOnMobile = false,
    this.showShortcutsInTooltips = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode,
      'languageCode': languageCode,
      'useCompactLayoutOnMobile': useCompactLayoutOnMobile,
      'showShortcutsInTooltips': showShortcutsInTooltips,
    };
  }

  factory UserInterfaceSettingsData.fromJson(Map<String, dynamic> json) {
    return UserInterfaceSettingsData(
      themeMode: json['themeMode'] ?? 'system',
      languageCode: json['languageCode'] ?? 'en',
      useCompactLayoutOnMobile: json['useCompactLayoutOnMobile'] ?? false,
      showShortcutsInTooltips: json['showShortcutsInTooltips'] ?? true,
    );
  }

  UserInterfaceSettingsData copyWith({
    String? themeMode,
    String? languageCode,
    bool? useCompactLayoutOnMobile,
    bool? showShortcutsInTooltips,
  }) {
    return UserInterfaceSettingsData(
      themeMode: themeMode ?? this.themeMode,
      languageCode: languageCode ?? this.languageCode,
      useCompactLayoutOnMobile:
          useCompactLayoutOnMobile ?? this.useCompactLayoutOnMobile,
      showShortcutsInTooltips:
          showShortcutsInTooltips ?? this.showShortcutsInTooltips,
    );
  }
}

/// P2P transfer settings data structure (replaces P2PDataTransferSettings and P2PFileStorageSettings)
class P2PTransferSettingsData {
  final String downloadPath;
  final bool createDateFolders;
  final bool createSenderFolders;
  final int maxReceiveFileSize; // In bytes
  final int maxTotalReceiveSize; // In bytes
  final int maxConcurrentTasks;
  final String sendProtocol; // e.g., 'TCP', 'UDP'
  final int maxChunkSize; // In kilobytes
  final String? customDisplayName;
  final int uiRefreshRateSeconds;
  final bool enableNotifications;
  final bool rememberBatchExpandState;
  final EncryptionType encryptionType;
  final bool enableCompression;
  final String compressionAlgorithm; // 'auto', 'gzip', 'deflate', 'none'
  final double compressionThreshold; // Only compress if ratio > this value
  final bool adaptiveCompression; // Let system choose best algorithm
  final bool autoCleanupCompletedTasks; // Auto cleanup completed transfer tasks
  final bool autoCleanupCancelledTasks; // Auto cleanup cancelled transfer tasks
  final bool autoCleanupFailedTasks; // Auto cleanup failed transfer tasks
  final int autoCleanupDelaySeconds; // Delay before auto cleanup (seconds)

  P2PTransferSettingsData({
    this.downloadPath = '',
    this.createDateFolders = false,
    this.createSenderFolders = true,
    this.maxReceiveFileSize = 1073741824, // 1GB in bytes
    this.maxTotalReceiveSize = 5368709120, // 5GB in bytes
    this.maxConcurrentTasks = 3,
    this.sendProtocol = 'TCP',
    this.maxChunkSize = 1024, // 1MB in KB
    this.customDisplayName,
    this.uiRefreshRateSeconds = 0,
    this.enableNotifications =
        false, // Default to false to reduce notification spam
    this.rememberBatchExpandState = false,
    this.encryptionType =
        EncryptionType.none, // Default to no encryption for stability
    this.enableCompression = false, // Default to false to avoid Android crashes
    this.compressionAlgorithm = 'none', // Default to no compression
    this.compressionThreshold = 1.1, // Only compress if 10% or better reduction
    this.adaptiveCompression = false, // Disable adaptive compression by default
    this.autoCleanupCompletedTasks =
        true, // Auto cleanup completed tasks by default
    this.autoCleanupCancelledTasks =
        true, // Auto cleanup cancelled tasks by default
    this.autoCleanupFailedTasks = true, // Auto cleanup failed tasks by default
    this.autoCleanupDelaySeconds =
        5, // Default 5 seconds delay for completed tasks
  });

  Map<String, dynamic> toJson() {
    return {
      'downloadPath': downloadPath,
      'createDateFolders': createDateFolders,
      'createSenderFolders': createSenderFolders,
      'maxReceiveFileSize': maxReceiveFileSize,
      'maxTotalReceiveSize': maxTotalReceiveSize,
      'maxConcurrentTasks': maxConcurrentTasks,
      'sendProtocol': sendProtocol,
      'maxChunkSize': maxChunkSize,
      'customDisplayName': customDisplayName,
      'uiRefreshRateSeconds': uiRefreshRateSeconds,
      'enableNotifications': enableNotifications,
      'rememberBatchExpandState': rememberBatchExpandState,
      'encryptionType': encryptionType.name,
      'enableCompression': enableCompression,
      'compressionAlgorithm': compressionAlgorithm,
      'compressionThreshold': compressionThreshold,
      'adaptiveCompression': adaptiveCompression,
      'autoCleanupCompletedTasks': autoCleanupCompletedTasks,
      'autoCleanupCancelledTasks': autoCleanupCancelledTasks,
      'autoCleanupFailedTasks': autoCleanupFailedTasks,
      'autoCleanupDelaySeconds': autoCleanupDelaySeconds,
    };
  }

  factory P2PTransferSettingsData.fromJson(Map<String, dynamic> json) {
    return P2PTransferSettingsData(
      downloadPath: json['downloadPath'] ?? '',
      createDateFolders: json['createDateFolders'] ?? false,
      createSenderFolders: json['createSenderFolders'] ?? true,
      maxReceiveFileSize: json['maxReceiveFileSize'] ?? 1073741824,
      maxTotalReceiveSize: json['maxTotalReceiveSize'] ?? 5368709120,
      maxConcurrentTasks: json['maxConcurrentTasks'] ?? 3,
      sendProtocol: json['sendProtocol'] ?? 'TCP',
      maxChunkSize:
          json['maxChunkSize'] ?? 2048, // 🚀 Tăng từ 1024KB lên 2048KB (2MB)
      customDisplayName: json['customDisplayName'],
      uiRefreshRateSeconds: json['uiRefreshRateSeconds'] ?? 0,
      enableNotifications: json['enableNotifications'] ?? false,
      rememberBatchExpandState: json['rememberBatchExpandState'] ?? false,
      encryptionType: EncryptionType.values.firstWhere(
        (e) => e.name == json['encryptionType'],
        orElse: () => EncryptionType.none, // Safe default
      ),
      enableCompression: json['enableCompression'] ?? false, // Safe default
      compressionAlgorithm:
          json['compressionAlgorithm'] ?? 'none', // Safe default
      compressionThreshold: (json['compressionThreshold'] as double?) ?? 1.1,
      adaptiveCompression: json['adaptiveCompression'] ?? false, // Safe default
      autoCleanupCompletedTasks: json['autoCleanupCompletedTasks'] ?? true,
      autoCleanupCancelledTasks: json['autoCleanupCancelledTasks'] ?? true,
      autoCleanupFailedTasks: json['autoCleanupFailedTasks'] ?? true,
      autoCleanupDelaySeconds: json['autoCleanupDelaySeconds'] ?? 5,
    );
  }

  P2PTransferSettingsData copyWith({
    String? downloadPath,
    bool? createDateFolders,
    bool? createSenderFolders,
    int? maxReceiveFileSize,
    int? maxTotalReceiveSize,
    int? maxConcurrentTasks,
    String? sendProtocol,
    int? maxChunkSize,
    String? customDisplayName,
    int? uiRefreshRateSeconds,
    bool? enableNotifications,
    bool? rememberBatchExpandState,
    EncryptionType? encryptionType,
    bool? enableCompression,
    String? compressionAlgorithm,
    double? compressionThreshold,
    bool? adaptiveCompression,
    bool? autoCleanupCompletedTasks,
    bool? autoCleanupCancelledTasks,
    bool? autoCleanupFailedTasks,
    int? autoCleanupDelaySeconds,
  }) {
    return P2PTransferSettingsData(
      downloadPath: downloadPath ?? this.downloadPath,
      createDateFolders: createDateFolders ?? this.createDateFolders,
      createSenderFolders: createSenderFolders ?? this.createSenderFolders,
      maxReceiveFileSize: maxReceiveFileSize ?? this.maxReceiveFileSize,
      maxTotalReceiveSize: maxTotalReceiveSize ?? this.maxTotalReceiveSize,
      maxConcurrentTasks: maxConcurrentTasks ?? this.maxConcurrentTasks,
      sendProtocol: sendProtocol ?? this.sendProtocol,
      maxChunkSize: maxChunkSize ?? this.maxChunkSize,
      customDisplayName: customDisplayName ?? this.customDisplayName,
      uiRefreshRateSeconds: uiRefreshRateSeconds ?? this.uiRefreshRateSeconds,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      rememberBatchExpandState:
          rememberBatchExpandState ?? this.rememberBatchExpandState,
      encryptionType: encryptionType ?? this.encryptionType,
      enableCompression: enableCompression ?? this.enableCompression,
      compressionAlgorithm: compressionAlgorithm ?? this.compressionAlgorithm,
      compressionThreshold: compressionThreshold ?? this.compressionThreshold,
      adaptiveCompression: adaptiveCompression ?? this.adaptiveCompression,
      autoCleanupCompletedTasks:
          autoCleanupCompletedTasks ?? this.autoCleanupCompletedTasks,
      autoCleanupCancelledTasks:
          autoCleanupCancelledTasks ?? this.autoCleanupCancelledTasks,
      autoCleanupFailedTasks:
          autoCleanupFailedTasks ?? this.autoCleanupFailedTasks,
      autoCleanupDelaySeconds:
          autoCleanupDelaySeconds ?? this.autoCleanupDelaySeconds,
    );
  }
}
