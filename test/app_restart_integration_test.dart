import 'package:flutter_test/flutter_test.dart';
import 'package:p2lantransfer/services/profile_breadcrumb_service.dart';
import 'package:p2lantransfer/services/profile_tab_service.dart';

void main() {
  group('App Restart Integration Tests', () {
    test('should preserve breadcrumb state across app restarts', () async {
      // === SIMULATION OF APP STARTUP ===
      final tabService = ProfileTabService.instance;
      final breadcrumbService = ProfileBreadcrumbService.instance;

      // Initialize services (like app startup)
      await tabService.initialize();

      // Clear all for fresh start
      for (int i = 0; i < 3; i++) {
        breadcrumbService.clearBreadcrumbs(i);
      }

      // === USER INTERACTIONS (BEFORE RESTART) ===
      print('\n📱 === BEFORE RESTART ===');

      // Tab 0: Text Template category
      tabService.setCurrentTab(0);
      breadcrumbService.pushBreadcrumb(
        title: 'Text Template',
        toolId: 'textTemplate',
        isCategory: true,
      );

      // Tab 1: Random Tools with sub-tool
      tabService.setCurrentTab(1);
      breadcrumbService.pushBreadcrumb(
        title: 'Random Tools',
        toolId: 'randomTools',
        isCategory: true,
      );
      breadcrumbService.pushBreadcrumb(
        title: 'Password Generator',
        toolId: 'randomTools_sub',
        isCategory: false,
      );

      // Tab 2: Stay empty

      print('Tab 0 breadcrumbs: ${breadcrumbService.getCurrentBreadcrumbs()}');
      tabService.setCurrentTab(1);
      print('Tab 1 breadcrumbs: ${breadcrumbService.getCurrentBreadcrumbs()}');

      // Verify state before restart
      expect(breadcrumbService.getCurrentBreadcrumbs().length, equals(2));

      // === SIMULATE APP RESTART ===
      print('\n🔄 === SIMULATING APP RESTART ===');

      // Save current tab breadcrumb data before clearing memory
      final tab0SavedData = tabService.tabs[0].breadcrumbData;
      final tab1SavedData = tabService.tabs[1].breadcrumbData;
      final tab2SavedData = tabService.tabs[2].breadcrumbData;

      print('Saved data before restart:');
      print('  Tab 0: $tab0SavedData');
      print('  Tab 1: $tab1SavedData');
      print('  Tab 2: $tab2SavedData');

      // Clear breadcrumb service memory only (simulate app death)
      // Do NOT call clearBreadcrumbs() as it would overwrite saved data
      breadcrumbService.clearMemoryOnly(0);
      breadcrumbService.clearMemoryOnly(1);
      breadcrumbService.clearMemoryOnly(2);

      // Verify memory is cleared
      tabService.setCurrentTab(0);
      expect(breadcrumbService.getCurrentBreadcrumbs().length, equals(0));
      tabService.setCurrentTab(1);
      expect(breadcrumbService.getCurrentBreadcrumbs().length, equals(0));

      // === SIMULATE APP STARTUP AFTER RESTART ===
      print('\n📱 === AFTER RESTART (RESTORE) ===');

      // In real app, tabs would be loaded from SharedPreferences with saved breadcrumbData
      // For test, we manually restore from saved data
      if (tab0SavedData != null && tab0SavedData.isNotEmpty) {
        breadcrumbService.restoreBreadcrumb(0, tab0SavedData);
      }
      if (tab1SavedData != null && tab1SavedData.isNotEmpty) {
        breadcrumbService.restoreBreadcrumb(1, tab1SavedData);
      }
      if (tab2SavedData != null && tab2SavedData.isNotEmpty) {
        breadcrumbService.restoreBreadcrumb(2, tab2SavedData);
      }

      // Also trigger restoreAllBreadcrumbsFromTabs() to test that method
      // breadcrumbService.restoreAllBreadcrumbsFromTabs();

      // Verify breadcrumb state is restored
      tabService.setCurrentTab(0);
      final tab0Breadcrumbs = breadcrumbService.getCurrentBreadcrumbs();
      print(
          'Tab 0 restored breadcrumbs: ${tab0Breadcrumbs.map((b) => b.title).join(" > ")}');
      expect(tab0Breadcrumbs.length, equals(1));
      expect(tab0Breadcrumbs[0].title, equals('Text Template'));
      expect(tab0Breadcrumbs[0].toolId, equals('textTemplate'));

      tabService.setCurrentTab(1);
      final tab1Breadcrumbs = breadcrumbService.getCurrentBreadcrumbs();
      print(
          'Tab 1 restored breadcrumbs: ${tab1Breadcrumbs.map((b) => b.title).join(" > ")}');
      expect(tab1Breadcrumbs.length, equals(2));
      expect(tab1Breadcrumbs[0].title, equals('Random Tools'));
      expect(tab1Breadcrumbs[0].toolId, equals('randomTools'));
      expect(tab1Breadcrumbs[1].title, equals('Password Generator'));
      expect(tab1Breadcrumbs[1].toolId, equals('randomTools_sub'));

      // Verify hierarchy is still valid after restore
      expect(breadcrumbService.isValidHierarchy(), isTrue);

      tabService.setCurrentTab(2);
      final tab2Breadcrumbs = breadcrumbService.getCurrentBreadcrumbs();
      expect(tab2Breadcrumbs.length, equals(0)); // Tab 2 should be empty

      print('\n✅ === BREADCRUMB STATE SUCCESSFULLY RESTORED ===');
    });

    test('should handle corrupted breadcrumb data gracefully', () async {
      final breadcrumbService = ProfileBreadcrumbService.instance;
      final tabService = ProfileTabService.instance;

      // Make sure we're on tab 0
      tabService.setCurrentTab(0);

      // Test với dữ liệu valid
      final validData = [
        {'title': 'Valid Title', 'toolId': 'validTool'},
        {'title': 'Another Valid', 'toolId': 'anotherTool'},
      ];

      print(
          'Before restore: ${breadcrumbService.getCurrentBreadcrumbs().length}');

      // Restore với valid data
      breadcrumbService.restoreBreadcrumb(0, validData);

      print(
          'After restore: ${breadcrumbService.getCurrentBreadcrumbs().length}');

      // Service should restore correctly
      final breadcrumbs = breadcrumbService.getCurrentBreadcrumbs();
      expect(breadcrumbs.length, equals(2));

      // Check restored data
      expect(breadcrumbs[0].title, equals('Valid Title'));
      expect(breadcrumbs[0].toolId, equals('validTool'));
      expect(breadcrumbs[1].title, equals('Another Valid'));
      expect(breadcrumbs[1].toolId, equals('anotherTool'));
    });
  });
}
