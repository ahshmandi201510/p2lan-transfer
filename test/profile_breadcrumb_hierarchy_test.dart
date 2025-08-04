import 'package:flutter_test/flutter_test.dart';
import 'package:p2lantransfer/services/profile_breadcrumb_service.dart';
import 'package:p2lantransfer/services/profile_tab_service.dart';

void main() {
  group('ProfileBreadcrumbService Hierarchy Tests', () {
    late ProfileBreadcrumbService breadcrumbService;
    late ProfileTabService tabService;

    setUp(() async {
      breadcrumbService = ProfileBreadcrumbService.instance;
      tabService = ProfileTabService.instance;

      // Initialize tab service
      await tabService.initialize();

      // Clear all breadcrumbs
      for (int i = 0; i < 3; i++) {
        breadcrumbService.clearBreadcrumbs(i);
      }
    });

    test('should maintain proper hierarchy when adding category tool', () {
      // Thêm category tool
      breadcrumbService.pushBreadcrumb(
        title: 'Text Template',
        toolId: 'textTemplate',
        isCategory: true,
      );

      final breadcrumbs = breadcrumbService.getCurrentBreadcrumbs();
      expect(breadcrumbs.length, equals(1));
      expect(breadcrumbs.first.title, equals('Text Template'));
      expect(breadcrumbService.isValidHierarchy(), isTrue);
    });

    test('should replace category when adding new category', () {
      // Thêm category đầu tiên
      breadcrumbService.pushBreadcrumb(
        title: 'Text Template',
        toolId: 'textTemplate',
        isCategory: true,
      );

      // Thêm category khác - nên thay thế category cũ
      breadcrumbService.pushBreadcrumb(
        title: 'Random Tools',
        toolId: 'randomTools',
        isCategory: true,
      );

      final breadcrumbs = breadcrumbService.getCurrentBreadcrumbs();
      expect(breadcrumbs.length, equals(1));
      expect(breadcrumbs.first.title, equals('Random Tools'));
      expect(breadcrumbService.isValidHierarchy(), isTrue);
    });

    test('should add sub-tool to category', () {
      // Thêm category
      breadcrumbService.pushBreadcrumb(
        title: 'Random Tools',
        toolId: 'randomTools',
        isCategory: true,
      );

      // Thêm sub-tool
      breadcrumbService.pushBreadcrumb(
        title: 'Date Generator',
        toolId: 'randomTools_sub',
        isCategory: false,
      );

      final breadcrumbs = breadcrumbService.getCurrentBreadcrumbs();
      expect(breadcrumbs.length, equals(2));
      expect(breadcrumbs.first.title, equals('Random Tools'));
      expect(breadcrumbs.last.title, equals('Date Generator'));
      expect(breadcrumbService.isValidHierarchy(), isTrue);
    });

    test('should replace sub-tool when adding new sub-tool', () {
      // Thêm category và sub-tool
      breadcrumbService.pushBreadcrumb(
        title: 'Random Tools',
        toolId: 'randomTools',
        isCategory: true,
      );
      breadcrumbService.pushBreadcrumb(
        title: 'Date Generator',
        toolId: 'randomTools_sub',
        isCategory: false,
      );

      // Thêm sub-tool khác - nên thay thế sub-tool cũ
      breadcrumbService.pushBreadcrumb(
        title: 'Password Generator',
        toolId: 'randomTools_sub2',
        isCategory: false,
      );

      final breadcrumbs = breadcrumbService.getCurrentBreadcrumbs();
      expect(breadcrumbs.length, equals(2));
      expect(breadcrumbs.first.title, equals('Random Tools'));
      expect(breadcrumbs.last.title, equals('Password Generator'));
      expect(breadcrumbService.isValidHierarchy(), isTrue);
    });

    test('should not allow sub-tool without category', () {
      // Thử thêm sub-tool mà không có category
      breadcrumbService.pushBreadcrumb(
        title: 'Date Generator',
        toolId: 'randomTools_sub',
        isCategory: false,
      );

      final breadcrumbs = breadcrumbService.getCurrentBreadcrumbs();
      expect(breadcrumbs.length, equals(0)); // Không được thêm
      expect(breadcrumbService.isValidHierarchy(), isTrue);
    });

    test('should maintain hierarchy per tab', () {
      // Tab 0: Text Template
      tabService.setCurrentTab(0);
      breadcrumbService.pushBreadcrumb(
        title: 'Text Template',
        toolId: 'textTemplate',
        isCategory: true,
      );

      // Tab 1: Random Tools
      tabService.setCurrentTab(1);
      breadcrumbService.pushBreadcrumb(
        title: 'Random Tools',
        toolId: 'randomTools',
        isCategory: true,
      );

      // Kiểm tra Tab 0
      tabService.setCurrentTab(0);
      var breadcrumbs = breadcrumbService.getCurrentBreadcrumbs();
      expect(breadcrumbs.length, equals(1));
      expect(breadcrumbs.first.title, equals('Text Template'));

      // Kiểm tra Tab 1
      tabService.setCurrentTab(1);
      breadcrumbs = breadcrumbService.getCurrentBreadcrumbs();
      expect(breadcrumbs.length, equals(1));
      expect(breadcrumbs.first.title, equals('Random Tools'));
    });
  });
}
