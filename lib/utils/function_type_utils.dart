/// Enum for different function types used throughout the application
enum FunctionType {
  /// P2Lan transfer related functions
  p2lanTransfer,

  /// General application settings
  appSettings,

  /// Cache/Storage management
  storageManagement,

  /// User interface settings
  userInterface,

  /// Network settings
  networkSettings,

  /// Security settings
  securitySettings,

  /// Notification settings
  notificationSettings,

  /// File management settings
  fileManagement,
}

/// Extension to provide display names for function types
extension FunctionTypeExtension on FunctionType {
  String get displayName {
    switch (this) {
      case FunctionType.p2lanTransfer:
        return 'P2Lan Transfer Settings';
      case FunctionType.appSettings:
        return 'Application Settings';
      case FunctionType.storageManagement:
        return 'Storage Management';
      case FunctionType.userInterface:
        return 'User Interface Settings';
      case FunctionType.networkSettings:
        return 'Network Settings';
      case FunctionType.securitySettings:
        return 'Security Settings';
      case FunctionType.notificationSettings:
        return 'Notification Settings';
      case FunctionType.fileManagement:
        return 'File Management Settings';
    }
  }

  String get identifier {
    switch (this) {
      case FunctionType.p2lanTransfer:
        return 'p2lan_transfer';
      case FunctionType.appSettings:
        return 'app_settings';
      case FunctionType.storageManagement:
        return 'storage_management';
      case FunctionType.userInterface:
        return 'user_interface';
      case FunctionType.networkSettings:
        return 'network_settings';
      case FunctionType.securitySettings:
        return 'security_settings';
      case FunctionType.notificationSettings:
        return 'notification_settings';
      case FunctionType.fileManagement:
        return 'file_management';
    }
  }
}
