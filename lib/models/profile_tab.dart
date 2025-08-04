import 'package:flutter/material.dart';
import 'package:p2lantransfer/utils/icon_data_utils.dart';

/// Model để lưu trữ thông tin của một tab profile
class ProfileTab {
  final int index;
  final String toolId;
  final String toolTitle;
  final IconData icon;
  final Color iconColor;
  final Widget toolWidget;
  final String? parentCategory;
  final DateTime lastAccessed;
  final List<Map<String, dynamic>>? breadcrumbData; // Lưu breadcrumb state

  ProfileTab({
    required this.index,
    required this.toolId,
    required this.toolTitle,
    required this.icon,
    required this.iconColor,
    required this.toolWidget,
    this.parentCategory,
    this.breadcrumbData,
    DateTime? lastAccessed,
  }) : lastAccessed = lastAccessed ?? DateTime.now();

  /// Tạo ProfileTab mặc định (màn hình chọn tool)
  factory ProfileTab.defaultTab(int index) {
    return ProfileTab(
      index: index,
      toolId: 'tool_selection',
      toolTitle: 'Select Tool',
      icon: Icons.apps,
      iconColor: Colors.grey,
      toolWidget: Container(), // Sẽ được replace bằng ToolSelectionScreen
      lastAccessed: DateTime.now(),
    );
  }

  /// Copy với thông tin tool mới
  ProfileTab copyWith({
    String? toolId,
    String? toolTitle,
    IconData? icon,
    Color? iconColor,
    Widget? toolWidget,
    String? parentCategory,
    List<Map<String, dynamic>>? breadcrumbData,
    DateTime? lastAccessed,
  }) {
    return ProfileTab(
      index: index,
      toolId: toolId ?? this.toolId,
      toolTitle: toolTitle ?? this.toolTitle,
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
      toolWidget: toolWidget ?? this.toolWidget,
      parentCategory: parentCategory ?? this.parentCategory,
      breadcrumbData: breadcrumbData ?? this.breadcrumbData,
      lastAccessed: lastAccessed ?? DateTime.now(),
    );
  }

  /// Convert to Map để lưu vào SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'toolId': toolId,
      'toolTitle': toolTitle,
      'iconCodePoint': icon.codePoint,
      'iconFontFamily': icon.fontFamily,
      'iconColorValue': iconColor.value,
      'parentCategory': parentCategory,
      'breadcrumbData': breadcrumbData,
      'lastAccessed': lastAccessed.millisecondsSinceEpoch,
    };
  }

  /// Create from Map
  factory ProfileTab.fromJson(Map<String, dynamic> json) {
    // Tạo IconData constant trước
    final int codePoint = json['iconCodePoint'] ?? Icons.apps.codePoint;

    return ProfileTab(
      index: json['index'] ?? 0,
      toolId: json['toolId'] ?? 'tool_selection',
      toolTitle: json['toolTitle'] ?? 'Select Tool',
      icon: IconDataHelper.getConstantIconData(
          codePoint), // Sử dụng constant IconData
      iconColor: Color(json['iconColorValue'] ?? Colors.grey.value),
      toolWidget: Container(),
      parentCategory: json['parentCategory'],
      breadcrumbData: json['breadcrumbData'] != null
          ? List<Map<String, dynamic>>.from(json['breadcrumbData'])
          : null,
      lastAccessed: DateTime.fromMillisecondsSinceEpoch(
        json['lastAccessed'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}
