import 'package:isar/isar.dart';
import 'package:p2lantransfer/services/generation_history_service_isar.dart';
import 'package:p2lantransfer/models/unified_history_data.dart';
import 'package:p2lantransfer/services/isar_service.dart';

class GenerationHistoryService {
  // Maximum number of items to keep in history
  static const int maxHistoryItems = 100;

  /// Check if history saving is enabled
  static Future<bool> isHistoryEnabled() async {
    return await GenerationHistoryServiceIsar.isHistoryEnabled();
  }

  /// Enable or disable history saving
  static Future<void> setHistoryEnabled(bool enabled) async {
    return await GenerationHistoryServiceIsar.setHistoryEnabled(enabled);
  }

  /// Add a new item to history
  static Future<void> addHistoryItem(UnifiedHistoryData item) async {
    return await GenerationHistoryServiceIsar.addHistoryItem(item);
  }

  /// Get history items for a specific type
  static Future<List<UnifiedHistoryData>> getHistory(String type) async {
    return await GenerationHistoryServiceIsar.getHistory(type);
  }

  /// Clear history for a specific type
  static Future<void> clearHistory(String type) async {
    return await GenerationHistoryServiceIsar.clearHistory(type);
  }

  /// Clear all history
  static Future<void> clearAllHistory() async {
    return await GenerationHistoryServiceIsar.clearAllHistory();
  }

  /// Delete a specific history item by its ID
  static Future<void> deleteHistoryItem(Id id) async {
    return await GenerationHistoryServiceIsar.deleteHistoryItem(id);
  }

  /// Get all unique history types
  static Future<List<String>> getHistoryTypes() async {
    return await GenerationHistoryServiceIsar.getHistoryTypes();
  }

  /// Get history count for a specific type
  static Future<int> getHistoryCount(String type) async {
    return await GenerationHistoryServiceIsar.getHistoryCount(type);
  }

  /// Get total history count across all types
  static Future<int> getTotalHistoryCount() async {
    final types = await getHistoryTypes();
    int total = 0;
    for (final type in types) {
      total += await getHistoryCount(type);
    }
    return total;
  }

  /// Get estimated data size of history in bytes
  static Future<int> getHistoryDataSize() async {
    return await GenerationHistoryServiceIsar.getHistoryDataSize();
  }

  static Future<void> deleteHistoryItemById(int id) async {
    final isar = IsarService.isar;
    await isar.writeTxn(() async {
      await isar.unifiedHistoryDatas.delete(id);
    });
  }
}
