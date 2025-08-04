import 'dart:convert';
import 'package:isar/isar.dart';
import 'package:p2lantransfer/utils/isar_utils.dart';

part 'p2p_cache_models.g.dart';

/// Enum for different types of P2P data cache
enum P2PDataCacheType {
  pairingRequest,
  dataTransferTask,
  fileTransferRequest,
}

/// Unified P2P data cache model to replace PairingRequest, DataTransferTask, FileTransferRequest
@Collection()
class P2PDataCache {
  Id get isarId => fastHash(id);

  @Index(unique: true, replace: true)
  String id;

  /// Human-readable title for UI display
  String title;

  /// Subtitle or description for UI display
  String subtitle;

  /// Type of P2P data this cache represents
  @Enumerated(EnumType.ordinal)
  @Index()
  P2PDataCacheType type;

  /// JSON string containing the original data structure
  String value;

  /// Additional metadata for quick access without parsing value
  String metaData; // JSON string for flexible metadata

  /// Timestamp when this cache entry was created
  @Index()
  DateTime createdTimestamp;

  /// Timestamp when this cache entry was last updated
  DateTime updatedTimestamp;

  /// Optional expiry timestamp for automatic cleanup
  @Index()
  DateTime? expiredTimestamp;

  /// Whether this cache entry has been processed/handled
  @Index()
  bool isProcessed;

  /// Generic status field for different workflows
  String? status;

  /// User ID for quick filtering (fromUserId or targetUserId)
  @Index()
  String? userId;

  /// Batch ID for grouping related entries
  @Index()
  String? batchId;

  /// Priority for sorting (higher = more important)
  int priority;

  P2PDataCache({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.value,
    this.metaData = '{}',
    required this.createdTimestamp,
    required this.updatedTimestamp,
    this.expiredTimestamp,
    this.isProcessed = false,
    this.status,
    this.userId,
    this.batchId,
    this.priority = 0,
  });

  /// Get metadata as Map
  Map<String, dynamic> getMetaDataAsMap() {
    try {
      return Map<String, dynamic>.from(jsonDecode(metaData));
    } catch (e) {
      return <String, dynamic>{};
    }
  }

  /// Set metadata from Map
  void setMetaDataFromMap(Map<String, dynamic> data) {
    metaData = jsonEncode(data);
    updatedTimestamp = DateTime.now();
  }

  /// Get value as Map
  Map<String, dynamic> getValueAsMap() {
    try {
      return Map<String, dynamic>.from(jsonDecode(value));
    } catch (e) {
      return <String, dynamic>{};
    }
  }

  /// Set value from Map
  void setValueFromMap(Map<String, dynamic> data) {
    value = jsonEncode(data);
    updatedTimestamp = DateTime.now();
  }

  /// Check if this cache entry is expired
  bool get isExpired {
    if (expiredTimestamp == null) return false;
    return DateTime.now().isAfter(expiredTimestamp!);
  }

  /// Mark as processed
  void markAsProcessed() {
    isProcessed = true;
    updatedTimestamp = DateTime.now();
  }

  /// Update status
  void updateStatus(String newStatus) {
    status = newStatus;
    updatedTimestamp = DateTime.now();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'type': type.index,
        'value': value,
        'metaData': metaData,
        'createdTimestamp': createdTimestamp.toIso8601String(),
        'updatedTimestamp': updatedTimestamp.toIso8601String(),
        'expiredTimestamp': expiredTimestamp?.toIso8601String(),
        'isProcessed': isProcessed,
        'status': status,
        'userId': userId,
        'batchId': batchId,
        'priority': priority,
      };

  factory P2PDataCache.fromJson(Map<String, dynamic> json) => P2PDataCache(
        id: json['id'] as String,
        title: json['title'] as String,
        subtitle: json['subtitle'] as String,
        type: P2PDataCacheType.values[json['type'] as int],
        value: json['value'] as String,
        metaData: json['metaData'] as String? ?? '{}',
        createdTimestamp: DateTime.parse(json['createdTimestamp'] as String),
        updatedTimestamp: DateTime.parse(json['updatedTimestamp'] as String),
        expiredTimestamp: json['expiredTimestamp'] != null
            ? DateTime.parse(json['expiredTimestamp'] as String)
            : null,
        isProcessed: json['isProcessed'] as bool? ?? false,
        status: json['status'] as String?,
        userId: json['userId'] as String?,
        batchId: json['batchId'] as String?,
        priority: json['priority'] as int? ?? 0,
      );

  /// Factory for creating from PairingRequest
  factory P2PDataCache.fromPairingRequest(Map<String, dynamic> pairingData) {
    final now = DateTime.now();
    return P2PDataCache(
      id: pairingData['id'] as String,
      title: 'Pairing Request',
      subtitle: 'From ${pairingData['fromUserName']}',
      type: P2PDataCacheType.pairingRequest,
      value: jsonEncode(pairingData),
      metaData: jsonEncode({
        'fromUserId': pairingData['fromUserId'],
        'fromUserName': pairingData['fromUserName'],
        'fromIpAddress': pairingData['fromIpAddress'],
        'wantsSaveConnection': pairingData['wantsSaveConnection'],
      }),
      createdTimestamp:
          DateTime.tryParse(pairingData['requestTime'] as String) ?? now,
      updatedTimestamp: now,
      expiredTimestamp:
          now.add(const Duration(hours: 1)), // Expire after 1 hour
      isProcessed: pairingData['isProcessed'] as bool? ?? false,
      status: 'pending',
      userId: pairingData['fromUserId'] as String,
      priority: 10, // High priority for pairing requests
    );
  }

  /// Factory for creating from DataTransferTask
  factory P2PDataCache.fromDataTransferTask(Map<String, dynamic> taskData) {
    final now = DateTime.now();
    final fileName = taskData['fileName'] as String? ?? 'Unknown File';
    final status = taskData['status'] as int? ?? 0;
    final isOutgoing = taskData['isOutgoing'] as bool? ?? false;
    final targetUserName =
        taskData['targetUserName'] as String? ?? 'Unknown User';

    return P2PDataCache(
      id: taskData['id'] as String,
      title: isOutgoing ? 'Sending: $fileName' : 'Receiving: $fileName',
      subtitle: isOutgoing ? 'To $targetUserName' : 'From $targetUserName',
      type: P2PDataCacheType.dataTransferTask,
      value: jsonEncode(taskData),
      metaData: jsonEncode({
        'fileName': fileName,
        'fileSize': taskData['fileSize'],
        'targetUserId': taskData['targetUserId'],
        'targetUserName': targetUserName,
        'isOutgoing': isOutgoing,
        'transferredBytes': taskData['transferredBytes'] ?? 0,
      }),
      createdTimestamp:
          DateTime.tryParse(taskData['createdAt'] as String) ?? now,
      updatedTimestamp: now,
      expiredTimestamp: null, // No expiry for transfer tasks
      isProcessed: status >= 3, // completed, failed, cancelled, rejected
      status: _getStatusFromTaskStatus(status),
      userId: taskData['targetUserId'] as String,
      batchId: taskData['batchId'] as String?,
      priority: 5, // Medium priority for transfers
    );
  }

  /// Factory for creating from FileTransferRequest
  factory P2PDataCache.fromFileTransferRequest(
      Map<String, dynamic> requestData) {
    final now = DateTime.now();
    final filesList = requestData['files'] as List<dynamic>? ?? [];
    final fileCount = filesList.length;
    final fromUserName =
        requestData['fromUserName'] as String? ?? 'Unknown User';

    return P2PDataCache(
      id: requestData['requestId'] as String,
      title: 'File Transfer Request',
      subtitle:
          '$fileCount file${fileCount != 1 ? 's' : ''} from $fromUserName',
      type: P2PDataCacheType.fileTransferRequest,
      value: jsonEncode(requestData),
      metaData: jsonEncode({
        'fromUserId': requestData['fromUserId'],
        'fromUserName': fromUserName,
        'fileCount': fileCount,
        'totalSize': requestData['totalSize'],
        'protocol': requestData['protocol'] ?? 'tcp',
      }),
      createdTimestamp:
          DateTime.tryParse(requestData['requestTime'] as String) ?? now,
      updatedTimestamp: now,
      expiredTimestamp:
          now.add(const Duration(minutes: 5)), // Expire after 5 minutes
      isProcessed: requestData['isProcessed'] as bool? ?? false,
      status: 'pending',
      userId: requestData['fromUserId'] as String,
      batchId: requestData['batchId'] as String,
      priority: 8, // High priority for file transfer requests
    );
  }

  /// Helper to convert task status index to string
  static String _getStatusFromTaskStatus(int statusIndex) {
    const statusNames = [
      'pending',
      'requesting',
      'waitingForApproval',
      'transferring',
      'completed',
      'failed',
      'cancelled',
      'rejected'
    ];
    if (statusIndex >= 0 && statusIndex < statusNames.length) {
      return statusNames[statusIndex];
    }
    return 'unknown';
  }
}
