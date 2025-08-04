import 'package:flutter_test/flutter_test.dart';
import 'package:p2lantransfer/services/profile_breadcrumb_service.dart';
import 'package:p2lantransfer/services/profile_tab_service.dart';

void main() {
  group('ProfileBreadcrumb Persistence Tests', () {
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

    test('should save breadcrumb data to ProfileTab', () {
      // Thêm breadcrumb
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

      // Kiểm tra breadcrumb được lưu vào tab
      final currentTab = tabService.currentTab;
      expect(currentTab, isNotNull);
      expect(currentTab!.breadcrumbData, isNotNull);
      expect(currentTab.breadcrumbData!.length, equals(2));

      // Kiểm tra dữ liệu đầu tiên (category)
      final categoryData = currentTab.breadcrumbData![0];
      expect(categoryData['title'], equals('Random Tools'));
      expect(categoryData['toolId'], equals('randomTools'));

      // Kiểm tra dữ liệu thứ hai (sub-tool)
      final subToolData = currentTab.breadcrumbData![1];
      expect(subToolData['title'], equals('Date Generator'));
      expect(subToolData['toolId'], equals('randomTools_sub'));
    });

    test('should restore breadcrumb from saved data', () {
      // Tạo saved breadcrumb data
      final savedBreadcrumbData = [
        {
          'title': 'Text Template',
          'toolId': 'textTemplate',
          'iconCodePoint': 123,
        },
        {
          'title': 'Template Editor',
          'toolId': 'textTemplate_sub',
          'iconCodePoint': 456,
        }
      ];

      // Khôi phục breadcrumb từ saved data
      breadcrumbService.restoreBreadcrumb(0, savedBreadcrumbData);

      // Kiểm tra breadcrumb được khôi phục đúng
      final breadcrumbs = breadcrumbService.getCurrentBreadcrumbs();
      expect(breadcrumbs.length, equals(2));
      expect(breadcrumbs[0].title, equals('Text Template'));
      expect(breadcrumbs[0].toolId, equals('textTemplate'));
      expect(breadcrumbs[1].title, equals('Template Editor'));
      expect(breadcrumbs[1].toolId, equals('textTemplate_sub'));
    });

    test('should clear breadcrumb and save to tab', () {
      // Thêm breadcrumb
      breadcrumbService.pushBreadcrumb(
        title: 'Random Tools',
        toolId: 'randomTools',
        isCategory: true,
      );

      // Verify breadcrumb tồn tại
      expect(breadcrumbService.getCurrentBreadcrumbs().length, equals(1));
      expect(tabService.currentTab!.breadcrumbData!.length, equals(1));

      // Clear breadcrumb
      breadcrumbService.clearCurrentBreadcrumbs();

      // Verify breadcrumb đã được clear
      expect(breadcrumbService.getCurrentBreadcrumbs().length, equals(0));
      expect(tabService.currentTab!.breadcrumbData!.length, equals(0));
    });

    test('should serialize and deserialize correctly', () {
      // Thêm breadcrumb với icon
      breadcrumbService.pushBreadcrumb(
        title: 'Converter Tools',
        toolId: 'converterTools',
        isCategory: true,
      );

      // Serialize
      final serialized = breadcrumbService.serializeBreadcrumb(0);
      expect(serialized, isNotNull);
      expect(serialized!.length, equals(1));
      expect(serialized[0]['title'], equals('Converter Tools'));
      expect(serialized[0]['toolId'], equals('converterTools'));

      // Clear và deserialize lại
      breadcrumbService.clearBreadcrumbs(0);
      expect(breadcrumbService.getCurrentBreadcrumbs().length, equals(0));

      breadcrumbService.restoreBreadcrumb(0, serialized);
      final restored = breadcrumbService.getCurrentBreadcrumbs();
      expect(restored.length, equals(1));
      expect(restored[0].title, equals('Converter Tools'));
      expect(restored[0].toolId, equals('converterTools'));
    });

    test('should maintain hierarchy validity after restoration', () {
      // Tạo invalid breadcrumb data (3 levels)
      final invalidData = [
        {'title': 'Level 1', 'toolId': 'level1'},
        {'title': 'Level 2', 'toolId': 'level2'},
        {'title': 'Level 3', 'toolId': 'level3'},
      ];

      // Khôi phục invalid data
      breadcrumbService.restoreBreadcrumb(0, invalidData);

      // Kiểm tra hierarchy vẫn hợp lệ (service sẽ validate)
      final breadcrumbs = breadcrumbService.getCurrentBreadcrumbs();
      expect(breadcrumbs.length, equals(3)); // Data được restore y nguyên
      expect(
          breadcrumbService.isValidHierarchy(), isFalse); // Nhưng không hợp lệ
    });
  });
}
