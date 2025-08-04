import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:p2lantransfer/models/profile_tab.dart';
import 'package:p2lantransfer/services/app_logger.dart';
import 'package:p2lantransfer/services/profile_breadcrumb_service.dart';

/// Enum để xác định view hiện tại của app
enum ProfileView {
  profile,
  routine,
  settings,
}

/// Service quản lý state của 3 Profile Tabs
class ProfileTabService extends ChangeNotifier {
  static ProfileTabService? _instance;
  static ProfileTabService get instance {
    _instance ??= ProfileTabService._();
    return _instance!;
  }

  ProfileTabService._();

  static const String _prefsKey = 'profile_tabs_state';
  static const int maxTabs = 3;

  List<ProfileTab> _tabs = [];
  int _currentTabIndex = 0;
  int _lastProfileTabIndex = 0; // Lưu tab profile cuối cùng
  ProfileView _currentView = ProfileView.profile;
  bool _isInitialized = false;

  List<ProfileTab> get tabs => List.unmodifiable(_tabs);
  int get currentTabIndex => _currentView == ProfileView.profile
      ? _currentTabIndex
      : _lastProfileTabIndex;
  int get routineTabIndex => _tabs.indexWhere((tab) => tab.toolId == 'routine');
  int get settingsTabIndex =>
      _tabs.indexWhere((tab) => tab.toolId == 'settings');
  int get currentProfileIndex => _currentTabIndex; // Alias cho quick actions
  ProfileView get currentView => _currentView;
  ProfileTab? get currentTab =>
      _currentTabIndex < _tabs.length ? _tabs[_currentTabIndex] : null;
  bool get isInitialized => _isInitialized;

  /// Khởi tạo service và load state từ SharedPreferences
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? savedData = prefs.getString(_prefsKey);

      if (savedData != null) {
        final Map<String, dynamic> data = jsonDecode(savedData);
        _currentTabIndex = data['currentTabIndex'] ?? 0;

        final List<dynamic> tabsData = data['tabs'] ?? [];
        _tabs =
            tabsData.map((tabData) => ProfileTab.fromJson(tabData)).toList();

        // Đảm bảo có đủ 3 tabs
        while (_tabs.length < maxTabs) {
          _tabs.add(ProfileTab.defaultTab(_tabs.length));
        }
      } else {
        // Tạo 3 tabs mặc định
        _tabs = List.generate(maxTabs, (index) => ProfileTab.defaultTab(index));
      }

      // Đảm bảo currentTabIndex hợp lệ
      _currentTabIndex = _currentTabIndex.clamp(0, maxTabs - 1);

      _isInitialized = true;

      // Khôi phục breadcrumb state từ saved tabs
      ProfileBreadcrumbService.instance.restoreAllBreadcrumbsFromTabs();

      logInfo('ProfileTabService initialized with ${_tabs.length} tabs');
    } catch (e) {
      logError('Error initializing ProfileTabService', e);
      // Fallback: tạo tabs mặc định
      _tabs = List.generate(maxTabs, (index) => ProfileTab.defaultTab(index));
      _currentTabIndex = 0;
      _isInitialized = true;
    }

    notifyListeners();
  }

  /// Lưu state hiện tại vào SharedPreferences
  Future<void> _saveState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final Map<String, dynamic> data = {
        'currentTabIndex': _currentTabIndex,
        'tabs': _tabs.map((tab) => tab.toJson()).toList(),
      };
      await prefs.setString(_prefsKey, jsonEncode(data));
      logDebug('ProfileTabService state saved');
    } catch (e) {
      logError('Error saving ProfileTabService state', e);
    }
  }

  /// Chuyển đến tab chỉ định
  void setCurrentTab(int index) {
    if (index >= 0 && index < maxTabs) {
      // Nếu đang ở routine/settings hoặc index khác tab hiện tại thì luôn cho phép chuyển
      final shouldNotify =
          (_currentView != ProfileView.profile) || (index != _currentTabIndex);
      _currentTabIndex = index;
      _lastProfileTabIndex = index;
      _currentView = ProfileView.profile;
      if (shouldNotify) {
        notifyListeners();
      }
      _saveState();
      logDebug('Switched to tab $index');
    }
  }

  /// Chuyển đến routine view
  void switchToRoutine() {
    // Nếu đang ở profile thì lưu lại tab cuối cùng
    if (_currentView == ProfileView.profile) {
      _lastProfileTabIndex = _currentTabIndex;
    }
    _currentView = ProfileView.routine;
    notifyListeners();
    logDebug('Switched to routine view');
  }

  /// Chuyển đến settings view
  void switchToSettings() {
    // Nếu đang ở profile thì lưu lại tab cuối cùng
    if (_currentView == ProfileView.profile) {
      _lastProfileTabIndex = _currentTabIndex;
    }
    _currentView = ProfileView.settings;
    notifyListeners();
    logDebug('Switched to settings view');
  }

  /// Cập nhật thông tin tool cho tab chỉ định
  void updateTabTool({
    required int tabIndex,
    required String toolId,
    required String toolTitle,
    required IconData icon,
    required Color iconColor,
    required Widget toolWidget,
    String? parentCategory,
  }) {
    if (tabIndex >= 0 && tabIndex < maxTabs) {
      // Tạo unique toolId cho mỗi tab để tránh conflict
      final uniqueToolId =
          '${toolId}_tab_${tabIndex}_${DateTime.now().millisecondsSinceEpoch}';

      _tabs[tabIndex] = _tabs[tabIndex].copyWith(
        toolId: uniqueToolId,
        toolTitle: toolTitle,
        icon: icon,
        iconColor: iconColor,
        toolWidget: toolWidget,
        parentCategory: parentCategory,
        lastAccessed: DateTime.now(),
      );

      notifyListeners();
      _saveState();
      logDebug(
          'Updated tab $tabIndex with tool: $toolTitle (unique ID: $uniqueToolId)');
    }
  }

  /// Reset tab về trạng thái mặc định (tool selection)
  void resetTab(int tabIndex) {
    if (tabIndex >= 0 && tabIndex < maxTabs) {
      _tabs[tabIndex] = ProfileTab.defaultTab(tabIndex);

      // Clear breadcrumb cho tab này
      ProfileBreadcrumbService.instance.clearBreadcrumbs(tabIndex);

      notifyListeners();
      _saveState();
      logDebug('Reset tab $tabIndex to default');
    }
  }

  /// Reset tất cả tabs về trạng thái mặc định
  void resetAllTabs() {
    _tabs = List.generate(maxTabs, (index) => ProfileTab.defaultTab(index));
    _currentTabIndex = 0;

    // Clear tất cả breadcrumb
    for (int i = 0; i < maxTabs; i++) {
      ProfileBreadcrumbService.instance.clearBreadcrumbs(i);
    }

    notifyListeners();
    _saveState();
    logInfo('Reset all tabs to default');
  }

  /// Lấy Widget của tab hiện tại
  Widget? getCurrentTabWidget() {
    final tab = currentTab;
    if (tab == null) return null;

    // Nếu là tool selection, trả về null để parent widget xử lý
    if (tab.toolId == 'tool_selection') {
      return null;
    }

    return tab.toolWidget;
  }

  /// Kiểm tra xem tab có đang ở tool selection không
  bool isTabOnToolSelection(int tabIndex) {
    if (tabIndex >= 0 && tabIndex < _tabs.length) {
      return _tabs[tabIndex].toolId == 'tool_selection';
    }
    return true;
  }

  /// Lấy thông tin hiển thị của tab (icon, title)
  Map<String, dynamic> getTabDisplayInfo(int tabIndex) {
    if (tabIndex >= 0 && tabIndex < _tabs.length) {
      final tab = _tabs[tabIndex];
      return {
        'icon': tab.icon,
        'iconColor': tab.iconColor,
        'title': tab.toolTitle,
        'isDefault': tab.toolId == 'tool_selection',
      };
    }

    return {
      'icon': Icons.apps,
      'iconColor': Colors.grey,
      'title': 'Tab ${tabIndex + 1}',
      'isDefault': true,
    };
  }

  /// Cập nhật breadcrumb data cho tab
  void updateTabBreadcrumb(
      int tabIndex, List<Map<String, dynamic>> breadcrumbData) {
    if (tabIndex >= 0 && tabIndex < maxTabs) {
      _tabs[tabIndex] =
          _tabs[tabIndex].copyWith(breadcrumbData: breadcrumbData);
      _saveState();
      logDebug('Updated breadcrumb for tab $tabIndex');
    }
  }

  @override
  void dispose() {
    _saveState();
    super.dispose();
  }
}
