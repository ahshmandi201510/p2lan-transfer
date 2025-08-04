import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:p2lantransfer/models/unified_history_data.dart';
import 'package:p2lantransfer/services/isar_service.dart';

class GenerationHistoryServiceIsar {
  static const String _historyEnabledKey = 'generation_history_enabled';
  static const int maxHistoryItems = 100;

  /// Check if history saving is enabled
  static Future<bool> isHistoryEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_historyEnabledKey) ?? true; // Default to true
  }

  /// Enable or disable history saving
  static Future<void> setHistoryEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_historyEnabledKey, enabled);
  }

  /// Add a new item to the history
  static Future<void> addHistoryItem(UnifiedHistoryData newItem) async {
    if (!await isHistoryEnabled()) return;

    try {
      final isar = IsarService.isar;

      await isar.writeTxn(() async {
        // Add new item
        await isar.unifiedHistoryDatas.put(newItem);

        // Cleanup old items if we exceed the limit
        final count = await isar.unifiedHistoryDatas
            .filter()
            .typeEqualTo(newItem.type)
            .count();

        if (count > maxHistoryItems) {
          // Get oldest items to delete
          final oldItems = await isar.unifiedHistoryDatas
              .filter()
              .typeEqualTo(newItem.type)
              .sortByTimestamp()
              .limit(count - maxHistoryItems)
              .findAll();

          for (final item in oldItems) {
            await isar.unifiedHistoryDatas.delete(item.id);
          }
        }
      });
    } catch (e) {
      throw Exception('Failed to add history item: $e');
    }
  }

  /// Get history items for a specific type
  static Future<List<UnifiedHistoryData>> getHistory(String type) async {
    try {
      final isar = IsarService.isar;
      return await isar.unifiedHistoryDatas
          .filter()
          .typeEqualTo(type)
          .sortByTimestampDesc()
          .findAll();
    } catch (e) {
      return [];
    }
  }

  /// Clear history for a specific type
  static Future<void> clearHistory(String type) async {
    try {
      final isar = IsarService.isar;
      await isar.writeTxn(() async {
        await isar.unifiedHistoryDatas.filter().typeEqualTo(type).deleteAll();
      });
    } catch (e) {
      throw Exception('Failed to clear history: $e');
    }
  }

  /// Clear all history
  static Future<void> clearAllHistory() async {
    try {
      final isar = IsarService.isar;
      await isar.writeTxn(() async {
        await isar.unifiedHistoryDatas.clear();
      });
    } catch (e) {
      throw Exception('Failed to clear all history: $e');
    }
  }

  /// Get all unique history types
  static Future<List<String>> getHistoryTypes() async {
    try {
      final isar = IsarService.isar;
      final items =
          await isar.unifiedHistoryDatas.where().distinctByType().findAll();
      return items.map((item) => item.type).toList();
    } catch (e) {
      return [];
    }
  }

  /// Get history count for a specific type
  static Future<int> getHistoryCount(String type) async {
    try {
      final isar = IsarService.isar;
      return await isar.unifiedHistoryDatas.filter().typeEqualTo(type).count();
    } catch (e) {
      return 0;
    }
  }

  /// Get estimated data size of history in bytes
  static Future<int> getHistoryDataSize() async {
    try {
      final isar = IsarService.isar;
      final items = await isar.unifiedHistoryDatas.where().findAll();

      int totalSize = 0;
      for (final item in items) {
        // Estimate size: value + type + timestamp overhead
        totalSize += (item.value.length * 2); // UTF-16 encoding
        totalSize += (item.type.length * 2);
        totalSize += 8; // timestamp (int64)
        totalSize += 16; // object overhead
      }

      return totalSize;
    } catch (e) {
      return 0;
    }
  }

  static Future<void> deleteHistoryItem(Id id) async {
    final isar = IsarService.isar;
    await isar.writeTxn(() async {
      await isar.unifiedHistoryDatas.delete(id);
    });
  }
}
