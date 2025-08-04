import 'package:isar/isar.dart';
import 'package:p2lantransfer/models/p2p_cache_models.dart';
import 'package:p2lantransfer/services/app_logger.dart';
import 'package:p2lantransfer/services/isar_service.dart';

/// Service for managing P2P data cache using the unified P2PDataCache model
class P2PDataCacheService {
  /// Create a cache entry from PairingRequest data
  static Future<P2PDataCache> createPairingRequestCache(
      Map<String, dynamic> pairingData) async {
    final cache = P2PDataCache.fromPairingRequest(pairingData);
    await saveCache(cache);
    logInfo('Created pairing request cache: ${cache.id}');
    return cache;
  }

  /// Create a cache entry from DataTransferTask data
  static Future<P2PDataCache> createDataTransferTaskCache(
      Map<String, dynamic> taskData) async {
    final cache = P2PDataCache.fromDataTransferTask(taskData);
    await saveCache(cache);
    logInfo('Created data transfer task cache: ${cache.id}');
    return cache;
  }

  /// Create a cache entry from FileTransferRequest data
  static Future<P2PDataCache> createFileTransferRequestCache(
      Map<String, dynamic> requestData) async {
    final cache = P2PDataCache.fromFileTransferRequest(requestData);
    await saveCache(cache);
    logInfo('Created file transfer request cache: ${cache.id}');
    return cache;
  }

  /// Save a cache entry to Isar
  static Future<void> saveCache(P2PDataCache cache) async {
    final isar = IsarService.isar;
    await isar.writeTxn(() async {
      await isar.p2PDataCaches.put(cache);
    });
  }

  /// Get a cache entry by ID
  static Future<P2PDataCache?> getCache(String id) async {
    final isar = IsarService.isar;
    return await isar.p2PDataCaches.where().idEqualTo(id).findFirst();
  }

  /// Get all cache entries of a specific type
  static Future<List<P2PDataCache>> getCachesByType(
      P2PDataCacheType type) async {
    final isar = IsarService.isar;
    return await isar.p2PDataCaches
        .filter()
        .typeEqualTo(type)
        .sortByPriorityDesc()
        .thenByCreatedTimestampDesc()
        .findAll();
  }

  /// Get all unprocessed cache entries of a specific type
  static Future<List<P2PDataCache>> getUnprocessedCachesByType(
      P2PDataCacheType type) async {
    final isar = IsarService.isar;
    return await isar.p2PDataCaches
        .filter()
        .typeEqualTo(type)
        .and()
        .isProcessedEqualTo(false)
        .sortByPriorityDesc()
        .thenByCreatedTimestampDesc()
        .findAll();
  }

  /// Get cache entries by user ID
  static Future<List<P2PDataCache>> getCachesByUserId(String userId) async {
    final isar = IsarService.isar;
    return await isar.p2PDataCaches
        .filter()
        .userIdEqualTo(userId)
        .sortByCreatedTimestampDesc()
        .findAll();
  }

  /// Get cache entries by batch ID
  static Future<List<P2PDataCache>> getCachesByBatchId(String batchId) async {
    final isar = IsarService.isar;
    return await isar.p2PDataCaches
        .filter()
        .batchIdEqualTo(batchId)
        .sortByCreatedTimestampDesc()
        .findAll();
  }

  /// Get cache entries by status
  static Future<List<P2PDataCache>> getCachesByStatus(String status) async {
    final isar = IsarService.isar;
    return await isar.p2PDataCaches
        .filter()
        .statusEqualTo(status)
        .sortByCreatedTimestampDesc()
        .findAll();
  }

  /// Mark a cache entry as processed
  static Future<void> markAsProcessed(String id) async {
    final cache = await getCache(id);
    if (cache != null) {
      cache.markAsProcessed();
      await saveCache(cache);
      logInfo('Marked cache as processed: $id');
    }
  }

  /// Update cache status
  static Future<void> updateStatus(String id, String status) async {
    final cache = await getCache(id);
    if (cache != null) {
      cache.updateStatus(status);
      await saveCache(cache);
      logInfo('Updated cache status: $id -> $status');
    }
  }

  /// Update cache metadata
  static Future<void> updateMetaData(
      String id, Map<String, dynamic> metadata) async {
    final cache = await getCache(id);
    if (cache != null) {
      cache.setMetaDataFromMap(metadata);
      await saveCache(cache);
      logInfo('Updated cache metadata: $id');
    }
  }

  /// Update cache value
  static Future<void> updateValue(String id, Map<String, dynamic> value) async {
    final cache = await getCache(id);
    if (cache != null) {
      cache.setValueFromMap(value);
      await saveCache(cache);
      logInfo('Updated cache value: $id');
    }
  }

  /// Delete a cache entry by ID
  static Future<void> deleteCache(String id) async {
    final isar = IsarService.isar;
    await isar.writeTxn(() async {
      await isar.p2PDataCaches.deleteByIndex('id', [id]);
    });
    logInfo('Deleted cache: $id');
  }

  /// Delete cache entries by type
  static Future<int> deleteCachesByType(P2PDataCacheType type) async {
    final isar = IsarService.isar;
    int count = 0;
    await isar.writeTxn(() async {
      count = await isar.p2PDataCaches.filter().typeEqualTo(type).deleteAll();
    });
    logInfo('Deleted $count cache entries of type: ${type.name}');
    return count;
  }

  /// Delete cache entries by user ID
  static Future<int> deleteCachesByUserId(String userId) async {
    final isar = IsarService.isar;
    int count = 0;
    await isar.writeTxn(() async {
      count =
          await isar.p2PDataCaches.filter().userIdEqualTo(userId).deleteAll();
    });
    logInfo('Deleted $count cache entries for user: $userId');
    return count;
  }

  /// Delete cache entries by batch ID
  static Future<int> deleteCachesByBatchId(String batchId) async {
    final isar = IsarService.isar;
    int count = 0;
    await isar.writeTxn(() async {
      count =
          await isar.p2PDataCaches.filter().batchIdEqualTo(batchId).deleteAll();
    });
    logInfo('Deleted $count cache entries for batch: $batchId');
    return count;
  }

  /// Clean up expired cache entries
  static Future<int> cleanupExpiredCaches() async {
    final isar = IsarService.isar;
    final now = DateTime.now();
    int count = 0;

    await isar.writeTxn(() async {
      count = await isar.p2PDataCaches
          .filter()
          .expiredTimestampIsNotNull()
          .and()
          .expiredTimestampLessThan(now)
          .deleteAll();
    });

    logInfo('Cleaned up $count expired cache entries');
    return count;
  }

  /// Clean up old processed cache entries (older than specified days)
  static Future<int> cleanupOldProcessedCaches({int olderThanDays = 7}) async {
    final isar = IsarService.isar;
    final cutoffDate = DateTime.now().subtract(Duration(days: olderThanDays));
    int count = 0;

    await isar.writeTxn(() async {
      count = await isar.p2PDataCaches
          .filter()
          .isProcessedEqualTo(true)
          .and()
          .updatedTimestampLessThan(cutoffDate)
          .deleteAll();
    });

    logInfo(
        'Cleaned up $count old processed cache entries (>${olderThanDays}d)');
    return count;
  }

  /// Get cache statistics
  static Future<Map<String, int>> getCacheStatistics() async {
    final isar = IsarService.isar;

    final totalCount = await isar.p2PDataCaches.count();
    final pairingRequestCount = await isar.p2PDataCaches
        .filter()
        .typeEqualTo(P2PDataCacheType.pairingRequest)
        .count();
    final dataTransferTaskCount = await isar.p2PDataCaches
        .filter()
        .typeEqualTo(P2PDataCacheType.dataTransferTask)
        .count();
    final fileTransferRequestCount = await isar.p2PDataCaches
        .filter()
        .typeEqualTo(P2PDataCacheType.fileTransferRequest)
        .count();
    final unprocessedCount =
        await isar.p2PDataCaches.filter().isProcessedEqualTo(false).count();
    final expiredCount = await isar.p2PDataCaches
        .filter()
        .expiredTimestampIsNotNull()
        .and()
        .expiredTimestampLessThan(DateTime.now())
        .count();

    return {
      'total': totalCount,
      'pairingRequests': pairingRequestCount,
      'dataTransferTasks': dataTransferTaskCount,
      'fileTransferRequests': fileTransferRequestCount,
      'unprocessed': unprocessedCount,
      'expired': expiredCount,
    };
  }

  /// Clear all P2P cache data
  static Future<void> clearAllCaches() async {
    final isar = IsarService.isar;
    await isar.writeTxn(() async {
      await isar.p2PDataCaches.clear();
    });
    logInfo('Cleared all P2P cache data');
  }

  /// Get all cache entries (for debugging/admin purposes)
  static Future<List<P2PDataCache>> getAllCaches() async {
    final isar = IsarService.isar;
    return await isar.p2PDataCaches
        .where()
        .sortByCreatedTimestampDesc()
        .findAll();
  }

  // Migration helpers for converting old data structures

  /// Migrate PairingRequest to P2PDataCache
  static Future<P2PDataCache> migratePairingRequest(
      dynamic pairingRequest) async {
    Map<String, dynamic> data;
    if (pairingRequest is Map<String, dynamic>) {
      data = pairingRequest;
    } else {
      // Assume it has toJson() method
      data = pairingRequest.toJson();
    }
    return await createPairingRequestCache(data);
  }

  /// Migrate DataTransferTask to P2PDataCache
  static Future<P2PDataCache> migrateDataTransferTask(dynamic task) async {
    Map<String, dynamic> data;
    if (task is Map<String, dynamic>) {
      data = task;
    } else {
      // Assume it has toJson() method
      data = task.toJson();
    }
    return await createDataTransferTaskCache(data);
  }

  /// Migrate FileTransferRequest to P2PDataCache
  static Future<P2PDataCache> migrateFileTransferRequest(
      dynamic request) async {
    Map<String, dynamic> data;
    if (request is Map<String, dynamic>) {
      data = request;
    } else {
      // Assume it has toJson() method
      data = request.toJson();
    }
    return await createFileTransferRequestCache(data);
  }

  /// Batch migrate multiple items
  static Future<List<P2PDataCache>> batchMigrate(
      List<dynamic> items, P2PDataCacheType type) async {
    final results = <P2PDataCache>[];

    for (final item in items) {
      try {
        P2PDataCache cache;
        switch (type) {
          case P2PDataCacheType.pairingRequest:
            cache = await migratePairingRequest(item);
            break;
          case P2PDataCacheType.dataTransferTask:
            cache = await migrateDataTransferTask(item);
            break;
          case P2PDataCacheType.fileTransferRequest:
            cache = await migrateFileTransferRequest(item);
            break;
        }
        results.add(cache);
      } catch (e) {
        logError('Failed to migrate ${type.name} item: $e');
      }
    }

    logInfo(
        'Batch migrated ${results.length}/${items.length} items of type: ${type.name}');
    return results;
  }
}
