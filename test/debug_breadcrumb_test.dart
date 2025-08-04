import 'package:flutter_test/flutter_test.dart';
import 'package:p2lantransfer/services/profile_breadcrumb_service.dart';
import 'package:p2lantransfer/services/profile_tab_service.dart';

void main() {
  test('Debug breadcrumb save/restore', () async {
    final tabService = ProfileTabService.instance;
    final breadcrumbService = ProfileBreadcrumbService.instance;

    await tabService.initialize();

    // Clear all
    for (int i = 0; i < 3; i++) {
      breadcrumbService.clearBreadcrumbs(i);
    }

    print('\n=== DEBUG SAVE/RESTORE ===');

    // Set tab 0 and add breadcrumb
    tabService.setCurrentTab(0);
    print('Current tab: ${tabService.currentTabIndex}');

    breadcrumbService.pushBreadcrumb(
      title: 'Test Category',
      toolId: 'testCategory',
      isCategory: true,
    );

    print('After push breadcrumb:');
    print(
        '  Breadcrumb count: ${breadcrumbService.getCurrentBreadcrumbs().length}');
    print('  Tab breadcrumbData: ${tabService.currentTab?.breadcrumbData}');

    // Check serialization
    final serialized = breadcrumbService.serializeBreadcrumb(0);
    print('  Serialized: $serialized');

    // Simulate clear and restore
    breadcrumbService.clearBreadcrumbs(0);
    print('After clear:');
    print(
        '  Breadcrumb count: ${breadcrumbService.getCurrentBreadcrumbs().length}');
    print('  Tab breadcrumbData: ${tabService.currentTab?.breadcrumbData}');

    // Try manual restore
    final savedData = tabService.currentTab?.breadcrumbData;
    print('Saved data from tab: $savedData');

    if (savedData != null) {
      breadcrumbService.restoreBreadcrumb(0, savedData);
      print('After manual restore:');
      print(
          '  Breadcrumb count: ${breadcrumbService.getCurrentBreadcrumbs().length}');
    }
  });
}
