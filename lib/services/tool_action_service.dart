import 'package:flutter/material.dart';

/// Service để quản lý actions của các tools
class ToolActionService extends ChangeNotifier {
  static ToolActionService? _instance;
  static ToolActionService get instance {
    _instance ??= ToolActionService._();
    return _instance!;
  }

  ToolActionService._();

  final Map<String, List<ActionDefinition>> _registeredActions = {};

  /// Register actions cho một tool
  void registerActions(String toolId, List<ActionDefinition> actions) {
    _registeredActions[toolId] = actions;
    notifyListeners();
  }

  /// Lấy actions cho một tool
  List<ActionDefinition> getActionsForTool(String toolId) {
    return _registeredActions[toolId] ?? [];
  }

  /// Clear actions cho một tool
  void clearActionsForTool(String toolId) {
    _registeredActions.remove(toolId);
    notifyListeners();
  }

  /// Clear tất cả actions
  void clearAllActions() {
    _registeredActions.clear();
    notifyListeners();
  }
}

/// Định nghĩa một action button
class ActionDefinition {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final Color? iconColor;

  const ActionDefinition({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.iconColor,
  });

  /// Convert to IconButton widget
  Widget toIconButton() {
    return IconButton(
      icon: Icon(icon, color: iconColor),
      onPressed: onPressed,
      tooltip: tooltip,
    );
  }
}
