import 'package:flutter/material.dart';
import 'package:p2lantransfer/services/profile_tab_service.dart';
import 'package:p2lantransfer/utils/icon_data_utils.dart';

/// Data model cho breadcrumb item
class ProfileBreadcrumbItem {
  final String title;
  final String toolId;
  final Widget? toolWidget;
  final IconData? icon;
  final VoidCallback? onTap;

  const ProfileBreadcrumbItem({
    required this.title,
    required this.toolId,
    this.toolWidget,
    this.icon,
    this.onTap,
  });
}

/// Service để quản lý breadcrumb navigation cho Profile Tab system
class ProfileBreadcrumbService extends ChangeNotifier {
  static ProfileBreadcrumbService? _instance;
  static ProfileBreadcrumbService get instance {
    _instance ??= ProfileBreadcrumbService._();
    return _instance!;
  }

  ProfileBreadcrumbService._() {
    // Lắng nghe tab changes để đồng bộ breadcrumb
    ProfileTabService.instance.addListener(_onTabChanged);
  }

  // Map từ tab index đến breadcrumb stack
  final Map<int, List<ProfileBreadcrumbItem>> _breadcrumbStacks = {};

  /// Callback khi tab thay đổi - notify để UI cập nhật breadcrumb
  void _onTabChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    ProfileTabService.instance.removeListener(_onTabChanged);
    super.dispose();
  }

  /// Lấy breadcrumb stack cho tab hiện tại
  List<ProfileBreadcrumbItem> getCurrentBreadcrumbs() {
    final currentTab = ProfileTabService.instance.currentTabIndex;
    return _breadcrumbStacks[currentTab] ?? [];
  }

  /// Thêm breadcrumb item vào stack của tab hiện tại
  /// Nếu isCategory=true, sẽ clear stack cũ và bắt đầu hierarchy mới
  void pushBreadcrumb({
    required String title,
    required String toolId,
    Widget? toolWidget,
    IconData? icon,
    VoidCallback? onTap,
    bool isCategory = false,
  }) {
    final currentTab = ProfileTabService.instance.currentTabIndex;

    if (_breadcrumbStacks[currentTab] == null) {
      _breadcrumbStacks[currentTab] = [];
    }

    final item = ProfileBreadcrumbItem(
      title: title,
      toolId: toolId,
      toolWidget: toolWidget,
      icon: icon,
      onTap: onTap,
    );

    // Nếu là category tool, clear breadcrumb cũ và bắt đầu hierarchy mới
    if (isCategory) {
      _breadcrumbStacks[currentTab] = [item];
    } else {
      // Đối với sub-tool, chỉ cho phép thêm nếu có category parent
      // Và đảm bảo chỉ có tối đa 2 levels: Category > Sub-tool
      if (_breadcrumbStacks[currentTab]!.isEmpty) {
        // Nếu chưa có category, không cho phép thêm sub-tool trực tiếp
        return;
      }

      // Nếu đã có 2 levels (Category > Sub-tool), thay thế sub-tool
      if (_breadcrumbStacks[currentTab]!.length >= 2) {
        _breadcrumbStacks[currentTab] = [
          _breadcrumbStacks[currentTab]!.first, // Keep category
          item, // Replace sub-tool
        ];
      } else {
        // Thêm sub-tool vào category
        _breadcrumbStacks[currentTab]!.add(item);
      }
    }

    // Log breadcrumb change cho debugging
    _logBreadcrumbChange('PUSH', title, toolId, isCategory);

    // Tự động lưu breadcrumb state vào tab
    saveBreadcrumbToTab(currentTab);

    notifyListeners();
  }

  /// Method để log breadcrumb changes cho debugging
  void _logBreadcrumbChange(
      String action, String title, String toolId, bool isCategory) {
    final currentTab = ProfileTabService.instance.currentTabIndex;
    final breadcrumbs = getCurrentBreadcrumbs();

    print('🍞 Breadcrumb $action: Tab $currentTab');
    print(
        '   Tool: $title ($toolId) - ${isCategory ? "CATEGORY" : "SUB-TOOL"}');
    print('   Result: ${breadcrumbs.map((b) => b.title).join(" > ")}');
    print('   Valid: ${isValidHierarchy()}');
  }

  /// Xóa breadcrumb item cuối cùng (back navigation)
  void popBreadcrumb() {
    final currentTab = ProfileTabService.instance.currentTabIndex;

    if (_breadcrumbStacks[currentTab] != null &&
        _breadcrumbStacks[currentTab]!.isNotEmpty) {
      _breadcrumbStacks[currentTab]!.removeLast();

      // Nếu stack trống, reset tab về tool selection
      if (_breadcrumbStacks[currentTab]!.isEmpty) {
        ProfileTabService.instance.resetTab(currentTab);
      } else {
        // Cập nhật tab với breadcrumb item trước đó
        final previousItem = _breadcrumbStacks[currentTab]!.last;
        if (previousItem.toolWidget != null) {
          ProfileTabService.instance.updateTabTool(
            tabIndex: currentTab,
            toolId: previousItem.toolId,
            toolTitle: previousItem.title,
            icon: previousItem.icon ?? Icons.extension,
            iconColor: Colors.blue,
            toolWidget: previousItem.toolWidget!,
          );
        }
      }

      // Tự động lưu breadcrumb state
      saveBreadcrumbToTab(currentTab);

      notifyListeners();
    }
  }

  /// Reset breadcrumb về category level (xóa sub-tools)
  void resetToCategory() {
    final currentTab = ProfileTabService.instance.currentTabIndex;

    if (_breadcrumbStacks[currentTab] != null &&
        _breadcrumbStacks[currentTab]!.isNotEmpty) {
      // Giữ lại chỉ category level (item đầu tiên)
      final categoryItem = _breadcrumbStacks[currentTab]!.first;
      _breadcrumbStacks[currentTab] = [categoryItem];

      // Cập nhật tab về category
      if (categoryItem.toolWidget != null) {
        ProfileTabService.instance.updateTabTool(
          tabIndex: currentTab,
          toolId: categoryItem.toolId,
          toolTitle: categoryItem.title,
          icon: categoryItem.icon ?? Icons.extension,
          iconColor: Colors.blue,
          toolWidget: categoryItem.toolWidget!,
        );
      }

      notifyListeners();
    }
  }

  /// Xóa toàn bộ breadcrumb stack cho tab
  void clearBreadcrumbs(int tabIndex) {
    _breadcrumbStacks[tabIndex] = [];
    saveBreadcrumbToTab(tabIndex);
    notifyListeners();
  }

  /// Xóa toàn bộ breadcrumb stack cho tab hiện tại
  void clearCurrentBreadcrumbs() {
    final currentTab = ProfileTabService.instance.currentTabIndex;
    clearBreadcrumbs(currentTab);
  }

  /// Kiểm tra xem có thể back không
  bool canGoBack() {
    final currentTab = ProfileTabService.instance.currentTabIndex;
    return _breadcrumbStacks[currentTab] != null &&
        _breadcrumbStacks[currentTab]!.isNotEmpty;
  }

  /// Navigate đến breadcrumb item cụ thể
  void navigateToBreadcrumb(int index) {
    final currentTab = ProfileTabService.instance.currentTabIndex;

    if (_breadcrumbStacks[currentTab] != null &&
        index < _breadcrumbStacks[currentTab]!.length) {
      // Xóa các items sau index
      _breadcrumbStacks[currentTab] =
          _breadcrumbStacks[currentTab]!.take(index + 1).toList();

      final targetItem = _breadcrumbStacks[currentTab]![index];

      if (targetItem.toolWidget != null) {
        ProfileTabService.instance.updateTabTool(
          tabIndex: currentTab,
          toolId: targetItem.toolId,
          toolTitle: targetItem.title,
          icon: targetItem.icon ?? Icons.extension,
          iconColor: Colors.blue,
          toolWidget: targetItem.toolWidget!,
        );
      }

      notifyListeners();
    }
  }

  /// Debug method để kiểm tra tính hợp lệ của breadcrumb hierarchy
  bool isValidHierarchy() {
    final breadcrumbs = getCurrentBreadcrumbs();

    // Breadcrumb không được quá 2 levels: Category > Sub-tool
    if (breadcrumbs.length > 2) {
      return false;
    }

    // Nếu có 2 levels, level đầu phải là category tool
    if (breadcrumbs.length == 2) {
      final categoryTool = breadcrumbs.first;
      return _isCategoryTool(categoryTool.toolId);
    }

    return true;
  }

  /// Kiểm tra xem tool có phải là category tool không
  bool _isCategoryTool(String toolId) {
    const categoryTools = [
      'textTemplate',
      'randomTools',
      'converterTools',
      'calculatorTools',
      'p2lanTransfer',
    ];
    return categoryTools.contains(toolId);
  }

  /// Debug method để log trạng thái breadcrumb hiện tại
  void debugPrintBreadcrumbs() {
    final currentTab = ProfileTabService.instance.currentTabIndex;
    final breadcrumbs = getCurrentBreadcrumbs();

    print('=== Breadcrumb Debug (Tab $currentTab) ===');
    print('Count: ${breadcrumbs.length}');
    print('Valid: ${isValidHierarchy()}');

    for (int i = 0; i < breadcrumbs.length; i++) {
      final item = breadcrumbs[i];
      final type = _isCategoryTool(item.toolId) ? 'CATEGORY' : 'SUB-TOOL';
      print('[$i] $type: ${item.title} (${item.toolId})');
    }
    print('=====================================');
  }

  /// Method để test toàn bộ hệ thống breadcrumb
  void debugFullSystemTest() {
    print('\n🧪 === BREADCRUMB SYSTEM DEBUG TEST ===');

    // Test 1: Category tools
    print('\n1. Testing Category Tools:');
    pushBreadcrumb(
        title: 'Text Template', toolId: 'textTemplate', isCategory: true);
    pushBreadcrumb(
        title: 'Random Tools', toolId: 'randomTools', isCategory: true);

    // Test 2: Sub-tools
    print('\n2. Testing Sub-tools:');
    pushBreadcrumb(
        title: 'Date Generator', toolId: 'randomTools_sub', isCategory: false);
    pushBreadcrumb(
        title: 'Password Generator',
        toolId: 'randomTools_sub2',
        isCategory: false);

    // Test 3: Invalid operations
    print('\n3. Testing Invalid Operations:');
    clearCurrentBreadcrumbs();
    pushBreadcrumb(
        title: 'Should Fail', toolId: 'invalid_sub', isCategory: false);

    // Final state
    print('\n4. Final State Check:');
    debugPrintBreadcrumbs();

    print('\n✅ === BREADCRUMB SYSTEM TEST COMPLETE ===\n');
  }

  /// Serialize breadcrumb cho tab cụ thể thành Map để lưu
  List<Map<String, dynamic>> serializeBreadcrumb(int tabIndex) {
    final breadcrumbs = _breadcrumbStacks[tabIndex];
    if (breadcrumbs == null || breadcrumbs.isEmpty) {
      return []; // Return empty array instead of null
    }

    return breadcrumbs
        .map((item) => {
              'title': item.title,
              'toolId': item.toolId,
              'iconCodePoint': item.icon?.codePoint,
              'iconFontFamily': item.icon?.fontFamily,
            })
        .toList();
  }

  /// Deserialize và khôi phục breadcrumb cho tab từ saved data
  void restoreBreadcrumb(
      int tabIndex, List<Map<String, dynamic>>? breadcrumbData) {
    if (breadcrumbData == null || breadcrumbData.isEmpty) {
      _breadcrumbStacks[tabIndex] = [];
      return;
    }

    _breadcrumbStacks[tabIndex] = breadcrumbData.map((data) {
      // Tạo constant IconData
      final int? codePoint = data['iconCodePoint'];

      return ProfileBreadcrumbItem(
        title: data['title'] ?? '',
        toolId: data['toolId'] ?? '',
        icon: codePoint != null
            ? IconDataHelper.getConstantIconData(codePoint)
            : null,
        // Sử dụng constant IconData hoặc null
        toolWidget: null,
      );
    }).toList();
  }

  /// Lưu breadcrumb state của tab hiện tại vào ProfileTab
  void saveBreadcrumbToTab(int tabIndex) {
    final breadcrumbData = serializeBreadcrumb(tabIndex);
    ProfileTabService.instance.updateTabBreadcrumb(tabIndex, breadcrumbData);
  }

  /// Khôi phục tất cả breadcrumb state từ ProfileTabService
  void restoreAllBreadcrumbsFromTabs() {
    final tabs = ProfileTabService.instance.tabs;
    for (int i = 0; i < tabs.length; i++) {
      final tab = tabs[i];
      restoreBreadcrumb(i, tab.breadcrumbData);
    }
    notifyListeners();
  }

  /// Cập nhật tool widget cho breadcrumb item cụ thể
  void updateBreadcrumbWidget(
      int tabIndex, int breadcrumbIndex, Widget toolWidget) {
    if (_breadcrumbStacks[tabIndex] != null &&
        breadcrumbIndex < _breadcrumbStacks[tabIndex]!.length) {
      final oldItem = _breadcrumbStacks[tabIndex]![breadcrumbIndex];
      _breadcrumbStacks[tabIndex]![breadcrumbIndex] = ProfileBreadcrumbItem(
        title: oldItem.title,
        toolId: oldItem.toolId,
        icon: oldItem.icon,
        onTap: oldItem.onTap,
        toolWidget: toolWidget,
      );

      // Lưu lại state
      saveBreadcrumbToTab(tabIndex);
    }
  }

  /// Kiểm tra xem breadcrumb có cần tái tạo widgets không
  bool needsWidgetRecreation(int tabIndex) {
    final breadcrumbs = _breadcrumbStacks[tabIndex];
    if (breadcrumbs == null || breadcrumbs.isEmpty) return false;

    return breadcrumbs.any((item) => item.toolWidget == null);
  }

  /// Clear breadcrumb memory without saving to tab (for testing app restart)
  void clearMemoryOnly(int tabIndex) {
    _breadcrumbStacks[tabIndex] = [];
    notifyListeners();
  }
}
