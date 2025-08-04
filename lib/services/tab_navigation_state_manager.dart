import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:p2lantransfer/services/app_logger.dart';
import 'package:p2lantransfer/variables.dart';

/// Quản lý state và navigation stack riêng biệt cho từng profile tab
class TabNavigationStateManager extends ChangeNotifier {
  static TabNavigationStateManager? _instance;
  static TabNavigationStateManager get instance {
    _instance ??= TabNavigationStateManager._();
    return _instance!;
  }

  TabNavigationStateManager._();

  static const String _prefsKey = 'tab_navigation_states';
  static const int maxTabs = 4;

  // Per-tab state storage
  final Map<String, TabNavigationState> _tabStates = {};
  String _currentTabKey = 'tab_0';

  /// Get or create tab state
  TabNavigationState getTabState(String tabKey) {
    return _tabStates[tabKey] ??= TabNavigationState(tabKey: tabKey);
  }

  /// Get current tab state
  TabNavigationState get currentTabState => getTabState(_currentTabKey);

  /// Switch current tab context
  void setCurrentTab(String tabKey) {
    if (_currentTabKey != tabKey) {
      final oldTabKey = _currentTabKey;
      _currentTabKey = tabKey;

      logDebug(
          'TabNavigationStateManager: Switched from $oldTabKey to $tabKey');
      notifyListeners();
    }
  }

  /// Save tab state to persistent storage
  Future<void> saveState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final Map<String, dynamic> data = {
        'currentTabKey': _currentTabKey,
        'tabStates':
            _tabStates.map((key, state) => MapEntry(key, state.toJson())),
      };
      await prefs.setString(_prefsKey, jsonEncode(data));
      logDebug('TabNavigationStateManager: State saved');
    } catch (e) {
      logError('Error saving TabNavigationStateManager state', e);
    }
  }

  /// Load tab states from persistent storage
  Future<void> loadState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? savedData = prefs.getString(_prefsKey);

      if (savedData != null) {
        final Map<String, dynamic> data = jsonDecode(savedData);
        _currentTabKey = data['currentTabKey'] ?? 'tab_0';

        final Map<String, dynamic> tabStatesData = data['tabStates'] ?? {};
        _tabStates.clear();

        for (final entry in tabStatesData.entries) {
          _tabStates[entry.key] = TabNavigationState.fromJson(entry.value);
        }

        logInfo(
            'TabNavigationStateManager: Loaded state for ${_tabStates.length} tabs');
      }
    } catch (e) {
      logError('Error loading TabNavigationStateManager state', e);
    }
  }

  /// Reset all tab states
  void resetAllTabs() {
    _tabStates.clear();
    _currentTabKey = 'tab_0';
    saveState();
    notifyListeners();
    logInfo('TabNavigationStateManager: Reset all tabs');
  }

  /// Reset specific tab
  void resetTab(String tabKey) {
    _tabStates.remove(tabKey);
    saveState();
    notifyListeners();
    logInfo('TabNavigationStateManager: Reset tab $tabKey');
  }
}

/// State cho một profile tab cụ thể
class TabNavigationState {
  final String tabKey;

  // Tool information
  String toolId = 'tool_selection';
  String toolTitle = '';
  IconData icon = Icons.apps;
  Color iconColor = Colors.grey;
  String? parentCategory;

  // AppBar state
  String appBarTitle = appName;
  List<Map<String, dynamic>> appBarActions = [];
  bool showBackButton = false;

  // Navigation stack (serializable representation)
  List<Map<String, dynamic>> navigationStack = [];

  // Breadcrumb data
  List<Map<String, dynamic>> breadcrumbData = [];

  DateTime lastAccessed = DateTime.now();

  TabNavigationState({required this.tabKey});

  /// Update tool information
  void updateTool({
    required String toolId,
    required String toolTitle,
    required IconData icon,
    required Color iconColor,
    String? parentCategory,
  }) {
    this.toolId = toolId;
    this.toolTitle = toolTitle;
    this.icon = icon;
    this.iconColor = iconColor;
    this.parentCategory = parentCategory;
    lastAccessed = DateTime.now();
  }

  /// Update AppBar state
  void updateAppBar({
    String? title,
    List<Map<String, dynamic>>? actions,
    bool? showBackButton,
  }) {
    if (title != null) appBarTitle = title;
    if (actions != null) appBarActions = List.from(actions);
    if (showBackButton != null) this.showBackButton = showBackButton;
  }

  /// Push navigation item to stack
  void pushNavigation(Map<String, dynamic> item) {
    navigationStack.add(item);
  }

  /// Pop navigation item from stack
  bool popNavigation() {
    if (navigationStack.isNotEmpty) {
      navigationStack.removeLast();
      return true;
    }
    return false;
  }

  /// Clear navigation stack
  void clearNavigation() {
    navigationStack.clear();
    appBarTitle = appName;
    showBackButton = false;
  }

  /// Check if at root (empty navigation stack)
  bool get isAtRoot => navigationStack.isEmpty;

  /// Get current navigation depth
  int get navigationDepth => navigationStack.length;

  /// Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'tabKey': tabKey,
      'toolId': toolId,
      'toolTitle': toolTitle,
      'iconCodePoint': icon.codePoint,
      'iconColorValue': iconColor.value,
      'parentCategory': parentCategory,
      'appBarTitle': appBarTitle,
      'appBarActions': appBarActions,
      'showBackButton': showBackButton,
      'navigationStack': navigationStack,
      'breadcrumbData': breadcrumbData,
      'lastAccessed': lastAccessed.millisecondsSinceEpoch,
    };
  }

  /// Deserialize from JSON
  static TabNavigationState fromJson(Map<String, dynamic> json) {
    final state = TabNavigationState(tabKey: json['tabKey']);

    state.toolId = json['toolId'] ?? 'tool_selection';
    state.toolTitle = json['toolTitle'] ?? '';
    state.icon = IconData(json['iconCodePoint'] ?? Icons.apps.codePoint,
        fontFamily: 'MaterialIcons');
    state.iconColor = Color(json['iconColorValue'] ?? Colors.grey.value);
    state.parentCategory = json['parentCategory'];
    state.appBarTitle = json['appBarTitle'] ?? appName;
    state.appBarActions =
        List<Map<String, dynamic>>.from(json['appBarActions'] ?? []);
    state.showBackButton = json['showBackButton'] ?? false;
    state.navigationStack =
        List<Map<String, dynamic>>.from(json['navigationStack'] ?? []);
    state.breadcrumbData =
        List<Map<String, dynamic>>.from(json['breadcrumbData'] ?? []);
    state.lastAccessed = DateTime.fromMillisecondsSinceEpoch(
        json['lastAccessed'] ?? DateTime.now().millisecondsSinceEpoch);

    return state;
  }

  @override
  String toString() {
    return 'TabNavigationState($tabKey: $toolTitle, depth: $navigationDepth, back: $showBackButton)';
  }
}
