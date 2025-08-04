import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:crypto/crypto.dart';
// Thêm dependency này

/// Enum cho các loại clipboard content
enum ClipboardContentType {
  text,
  image,
  files,
  html,
  empty,
  unknown,
}

/// Class đại diện cho nội dung clipboard với type safety
class ClipboardContent {
  final ClipboardContentType type;
  final dynamic _content;
  final String? _hash; // Hash để so sánh nhanh
  final int? _contentSize;
  final DateTime timestamp;

  ClipboardContent._({
    required this.type,
    required dynamic rawContent,
    String? contentHash,
    int? contentSize,
    DateTime? timestamp,
  })  : _content = rawContent,
        _hash = contentHash,
        _contentSize = contentSize,
        timestamp = timestamp ?? DateTime.now();

  /// Factory constructors cho từng loại content
  factory ClipboardContent.text(String content) {
    return ClipboardContent._(
      type: ClipboardContentType.text,
      rawContent: content,
      contentHash: _generateHash(content),
      contentSize: content.length,
    );
  }

  factory ClipboardContent.image(Uint8List imageData) {
    return ClipboardContent._(
      type: ClipboardContentType.image,
      rawContent: imageData,
      contentHash: _generateHash(imageData),
      contentSize: imageData.length,
    );
  }

  factory ClipboardContent.files(List<String> filePaths) {
    final pathsString = filePaths.join('|');
    return ClipboardContent._(
      type: ClipboardContentType.files,
      rawContent: filePaths,
      contentHash: _generateHash(pathsString),
      contentSize: filePaths.length,
    );
  }

  factory ClipboardContent.html(String htmlContent) {
    return ClipboardContent._(
      type: ClipboardContentType.html,
      rawContent: htmlContent,
      contentHash: _generateHash(htmlContent),
      contentSize: htmlContent.length,
    );
  }

  factory ClipboardContent.empty() {
    return ClipboardContent._(
      type: ClipboardContentType.empty,
      rawContent: null,
      contentHash: null,
      contentSize: 0,
    );
  }

  factory ClipboardContent.unknown(dynamic content) {
    return ClipboardContent._(
      type: ClipboardContentType.unknown,
      rawContent: content,
      contentHash: _generateHash(content.toString()),
      contentSize: content.toString().length,
    );
  }

  /// Getters với type safety
  String get asText {
    if (type != ClipboardContentType.text) {
      throw StateError('Content is not text type');
    }
    return _content as String;
  }

  Uint8List get asImage {
    if (type != ClipboardContentType.image) {
      throw StateError('Content is not image type');
    }
    return _content as Uint8List;
  }

  List<String> get asFiles {
    if (type != ClipboardContentType.files) {
      throw StateError('Content is not files type');
    }
    return _content as List<String>;
  }

  String get asHtml {
    if (type != ClipboardContentType.html) {
      throw StateError('Content is not HTML type');
    }
    return _content as String;
  }

  /// Safe getters (trả về null nếu không đúng type)
  String? get textOrNull =>
      type == ClipboardContentType.text ? _content as String : null;
  Uint8List? get imageOrNull =>
      type == ClipboardContentType.image ? _content as Uint8List : null;
  List<String>? get filesOrNull =>
      type == ClipboardContentType.files ? _content as List<String> : null;
  String? get htmlOrNull =>
      type == ClipboardContentType.html ? _content as String : null;

  /// Properties
  bool get isText => type == ClipboardContentType.text;
  bool get isImage => type == ClipboardContentType.image;
  bool get isFiles => type == ClipboardContentType.files;
  bool get isHtml => type == ClipboardContentType.html;
  bool get isUnknown => type == ClipboardContentType.unknown;
  bool get isEmpty => type == ClipboardContentType.empty;
  bool get hasContent => !isEmpty && type != ClipboardContentType.unknown;
  String? get contentHash => _hash;
  int get contentSize => _contentSize ?? 0;

  /// So sánh nội dung dựa trên hash
  bool isEqualTo(ClipboardContent? other) {
    if (other == null) return false;
    if (type != other.type) return false;
    return _hash == other._hash;
  }

  /// Tạo hash cho nội dung
  static String _generateHash(dynamic content) {
    if (content is Uint8List) {
      // Với image, chỉ hash một phần để tối ưu performance
      final sampleSize = content.length > 1024 ? 1024 : content.length;
      final sample = content.sublist(0, sampleSize);
      return md5.convert(sample).toString();
    } else {
      return md5.convert(utf8.encode(content.toString())).toString();
    }
  }

  /// Tạo preview string cho debug/display
  String get preview {
    switch (type) {
      case ClipboardContentType.text:
        final text = _content as String;
        return text.length > 100 ? '${text.substring(0, 100)}...' : text;
      case ClipboardContentType.image:
        final bytes = _content as Uint8List;
        return 'Image (${_formatBytes(bytes.length)})';
      case ClipboardContentType.files:
        final files = _content as List<String>;
        return 'Files (${files.length}): ${files.take(3).join(', ')}${files.length > 3 ? '...' : ''}';
      case ClipboardContentType.html:
        final html = _content as String;
        return 'HTML (${_formatBytes(html.length)})';
      case ClipboardContentType.empty:
        return 'Empty';
      case ClipboardContentType.unknown:
        return 'Unknown: ${_content.toString()}';
    }
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  @override
  String toString() {
    return 'ClipboardContent(type: $type, size: ${_formatBytes(contentSize)}, hash: ${_hash?.substring(0, 8)}...)';
  }
}

/// Enhanced ClipboardChangeEvent với ClipboardContent
class ClipboardChangeEvent {
  final ClipboardContent newContent;
  final ClipboardContent? previousContent;
  final DateTime timestamp;
  final bool isInitial;
  final String? error;

  const ClipboardChangeEvent({
    required this.newContent,
    this.previousContent,
    required this.timestamp,
    this.isInitial = false,
    this.error,
  });

  bool get hasError => error != null;
  bool get hasContent => newContent.hasContent;
  bool get isContentChanged => !newContent.isEqualTo(previousContent);
  ClipboardContentType get contentType => newContent.type;

  @override
  String toString() {
    return 'ClipboardChangeEvent(type: $contentType, changed: $isContentChanged, time: $timestamp, error: $error)';
  }
}

/// Enhanced ClipboardWatcher với multi-type support
class ClipboardWatcher {
  static ClipboardWatcher? _instance;
  static ClipboardWatcher get instance => _instance ??= ClipboardWatcher._();

  ClipboardWatcher._();

  Timer? _timer;
  ClipboardContent? _lastClipboardContent;
  Duration _pollingInterval = const Duration(milliseconds: 500);
  bool _isWatching = false;

  // Configuration
  bool _enableImageDetection = true;
  bool _enableFileDetection = true;
  bool _enableHtmlDetection = true;
  int _maxImageSize = 10 * 1024 * 1024; // 10MB max for images

  /// Stream controller để phát sự kiện thay đổi clipboard
  final StreamController<ClipboardChangeEvent> _changeController =
      StreamController<ClipboardChangeEvent>.broadcast();

  /// Stream để lắng nghe thay đổi clipboard
  Stream<ClipboardChangeEvent> get onClipboardChanged =>
      _changeController.stream;

  /// Configuration getters/setters
  bool get enableImageDetection => _enableImageDetection;
  bool get enableFileDetection => _enableFileDetection;
  bool get enableHtmlDetection => _enableHtmlDetection;
  int get maxImageSize => _maxImageSize;

  void setImageDetection(bool enabled) => _enableImageDetection = enabled;
  void setFileDetection(bool enabled) => _enableFileDetection = enabled;
  void setHtmlDetection(bool enabled) => _enableHtmlDetection = enabled;
  void setMaxImageSize(int bytes) => _maxImageSize = bytes;

  /// Properties
  bool get isWatching => _isWatching;
  Duration get pollingInterval => _pollingInterval;
  ClipboardContent? get lastContent => _lastClipboardContent;

  /// Bắt đầu theo dõi clipboard
  Future<void> startWatching({
    Duration? pollingInterval,
    bool checkInitialContent = true,
  }) async {
    if (_isWatching) {
      debugPrint('ClipboardWatcher: Already watching');
      return;
    }

    if (pollingInterval != null) {
      _pollingInterval = pollingInterval;
    }

    _isWatching = true;

    // Lấy nội dung ban đầu nếu cần
    if (checkInitialContent) {
      await _checkClipboardContent(isInitial: true);
    }

    // Bắt đầu polling
    _timer = Timer.periodic(_pollingInterval, (_) async {
      await _checkClipboardContent();
    });

    debugPrint(
        'ClipboardWatcher: Started watching with interval ${_pollingInterval.inMilliseconds}ms');
  }

  /// Dừng theo dõi clipboard
  void stopWatching() {
    if (!_isWatching) {
      debugPrint('ClipboardWatcher: Not watching');
      return;
    }

    _timer?.cancel();
    _timer = null;
    _isWatching = false;
    _lastClipboardContent = null;

    debugPrint('ClipboardWatcher: Stopped watching');
  }

  /// Thay đổi thời gian polling
  void setPollingInterval(Duration interval) {
    _pollingInterval = interval;

    if (_isWatching) {
      _timer?.cancel();
      _timer = Timer.periodic(_pollingInterval, (_) async {
        await _checkClipboardContent();
      });
      debugPrint(
          'ClipboardWatcher: Updated polling interval to ${interval.inMilliseconds}ms');
    }
  }

  /// Kiểm tra nội dung clipboard với multi-type support
  Future<void> _checkClipboardContent({bool isInitial = false}) async {
    try {
      ClipboardContent? currentContent = await _detectClipboardContent();

      // logDebug(
      //     'ClipboardWatcher: Detected content type: ${currentContent?.type}, size: ${currentContent?.contentSize} bytes');

      // Kiểm tra thay đổi
      if (currentContent != null &&
          !currentContent.isEqualTo(_lastClipboardContent)) {
        final previousContent = _lastClipboardContent;
        _lastClipboardContent = currentContent;

        // logDebug(
        //     'ClipboardWatcher: Content changed from ${previousContent?.type} to ${currentContent.type}');

        // Phát sự kiện thay đổi
        if (!isInitial || previousContent != null) {
          _changeController.add(ClipboardChangeEvent(
            newContent: currentContent,
            previousContent: previousContent,
            timestamp: DateTime.now(),
            isInitial: isInitial,
          ));
        }
      }
    } catch (e) {
      debugPrint('ClipboardWatcher: Error checking clipboard - $e');

      _changeController.add(ClipboardChangeEvent(
        newContent: ClipboardContent.empty(),
        previousContent: _lastClipboardContent,
        timestamp: DateTime.now(),
        error: e.toString(),
      ));
    }
  }

  /// Detect clipboard content type và content
  Future<ClipboardContent?> _detectClipboardContent() async {
    if (Platform.isMacOS) {
      return await _detectMacOSClipboard();
    } else {
      return await _detectOtherPlatformClipboard();
    }
  }

  /// Detect clipboard content trên macOS sử dụng pasteboard
  Future<ClipboardContent?> _detectMacOSClipboard() async {
    // Kiểm tra theo thứ tự ưu tiên: text -> files -> image -> html

    // 1. Text (ưu tiên cao nhất)
    final text = await Pasteboard.text;
    if (text != null && text.isNotEmpty) {
      return ClipboardContent.text(text);
    }

    // 2. Files
    if (_enableFileDetection) {
      final files = await Pasteboard.files();
      if (files.isNotEmpty) {
        return ClipboardContent.files(files);
      }
    }

    // 3. Image (kiểm tra size trước khi load)
    if (_enableImageDetection) {
      try {
        final imageData = await Pasteboard.image;
        if (imageData != null) {
          if (imageData.length > _maxImageSize) {
            debugPrint(
                'ClipboardWatcher: Image too large (${imageData.length} bytes), skipping');
            return ClipboardContent.unknown(
                'Large image (${imageData.length} bytes)');
          }
          return ClipboardContent.image(imageData);
        }
      } catch (e) {
        debugPrint('ClipboardWatcher: Error reading image - $e');
      }

      // Nếu không có image, kiểm tra HTML
      final html = await Pasteboard.html;
      if (html != null && html.isNotEmpty) {
        return ClipboardContent.html(html);
      }
    }

    // 4. HTML
    if (_enableHtmlDetection) {
      final html = await Pasteboard.html;
      if (html != null && html.isNotEmpty) {
        return ClipboardContent.html(html);
      }
    }

    return ClipboardContent.empty();
  }

  /// Detect clipboard content trên các platform khác
  Future<ClipboardContent?> _detectOtherPlatformClipboard() async {
    try {
      // Text
      dynamic content = await Pasteboard.text;
      if (content != null && content!.isNotEmpty) {
        return ClipboardContent.text(content);
      }
      // File
      content = await Pasteboard.files();
      if (content != null && content.isNotEmpty) {
        return ClipboardContent.files(List<String>.from(content));
      }
      // Html
      content = await Pasteboard.html;
      if (content != null && content.isNotEmpty) {
        return ClipboardContent.html(content);
      }
      // Image
      content = await Pasteboard.image;
      if (content != null && content is Uint8List) {
        if (content.length > _maxImageSize) {
          debugPrint(
              '[${DateTime.now().toIso8601String()}] ClipboardWatcher: Image too large (${content.length} bytes), skipping');
          return ClipboardContent.unknown(
              'Large image (${content.length} bytes)');
        }
        return ClipboardContent.image(content);
      }
      // Nếu không có nội dung nào, trả về empty
      return ClipboardContent.empty();
    } catch (e) {
      debugPrint('ClipboardWatcher: Error reading text - $e');
    }

    return ClipboardContent.empty();
  }

  /// Lấy nội dung clipboard hiện tại
  Future<ClipboardContent?> getCurrentContent() async {
    try {
      return await _detectClipboardContent();
    } catch (e) {
      debugPrint('ClipboardWatcher: Error getting current content - $e');
      return null;
    }
  }

  /// Set nội dung clipboard
  Future<bool> setContent(ClipboardContent content) async {
    try {
      bool success = false;

      if (Platform.isMacOS) {
        switch (content.type) {
          case ClipboardContentType.text:
            Pasteboard.writeText(content.asText);
            success = true;
            break;
          case ClipboardContentType.image:
            await Pasteboard.writeImage(content.asImage);
            success = true;
            break;
          case ClipboardContentType.files:
            await Pasteboard.writeFiles(content.asFiles);
            success = true;
            break;
          default:
            debugPrint(
                'ClipboardWatcher: Unsupported content type for macOS: ${content.type}');
        }
      } else {
        if (content.type == ClipboardContentType.text) {
          await FlutterClipboard.copy(content.asText);
          success = true;
        } else {
          debugPrint('ClipboardWatcher: Only text supported on this platform');
        }
      }

      if (success) {
        // Cập nhật nội dung cuối cùng để tránh trigger false positive
        _lastClipboardContent = content;
      }

      return success;
    } catch (e) {
      debugPrint('ClipboardWatcher: Error setting content - $e');
      return false;
    }
  }

  /// Convenience method để set text
  Future<bool> setText(String text) async {
    return await setContent(ClipboardContent.text(text));
  }

  /// Dispose resources
  void dispose() {
    stopWatching();
    _changeController.close();
  }
}

/// Mixin để dễ dàng sử dụng ClipboardWatcher trong StatefulWidget
mixin ClipboardWatcherMixin<T extends StatefulWidget> {
  StreamSubscription<ClipboardChangeEvent>? _clipboardSubscription;

  /// Override method này để xử lý thay đổi clipboard
  void onClipboardChanged(ClipboardChangeEvent event) {}

  /// Bắt đầu lắng nghe clipboard
  void startListeningClipboard({
    Duration? pollingInterval,
    bool autoStartWatching = true,
  }) {
    _clipboardSubscription =
        ClipboardWatcher.instance.onClipboardChanged.listen(
      onClipboardChanged,
      onError: (error) {
        debugPrint('ClipboardWatcherMixin: Error - $error');
      },
    );

    if (autoStartWatching && !ClipboardWatcher.instance.isWatching) {
      ClipboardWatcher.instance.startWatching(pollingInterval: pollingInterval);
    }
  }

  /// Dừng lắng nghe clipboard
  void stopListeningClipboard({bool stopWatcher = false}) {
    _clipboardSubscription?.cancel();
    _clipboardSubscription = null;

    if (stopWatcher) {
      ClipboardWatcher.instance.stopWatching();
    }
  }
}

/// Static helper functions cho clipboard operations
class ClipboardHelper {
  /// Quick start watching với default settings
  static Future<void> startWatching({
    Duration pollingInterval = const Duration(milliseconds: 500),
  }) async {
    await ClipboardWatcher.instance.startWatching(
      pollingInterval: pollingInterval,
    );
  }

  /// Quick stop watching
  static void stopWatching() {
    ClipboardWatcher.instance.stopWatching();
  }

  /// Listen to clipboard changes
  static StreamSubscription<ClipboardChangeEvent> listen(
    void Function(ClipboardChangeEvent) onChanged, {
    Duration? pollingInterval,
    bool autoStart = true,
  }) {
    if (autoStart && !ClipboardWatcher.instance.isWatching) {
      ClipboardWatcher.instance.startWatching(pollingInterval: pollingInterval);
    }

    return ClipboardWatcher.instance.onClipboardChanged.listen(onChanged);
  }

  /// Get current clipboard content
  static Future<ClipboardContent?> getCurrentContent() {
    return ClipboardWatcher.instance.getCurrentContent();
  }

  /// Set clipboard content
  static Future<bool> setContent(String content) {
    return ClipboardWatcher.instance.setContent(content as ClipboardContent);
  }
}

// Usage:
// ClipboardHelper.listen((event) => print('Clipboard changed: ${event.newContent}'));

/*

----- 1. Basic Usage với Singleton:

import 'package:flutter/material.dart';

class ClipboardMonitorPage extends StatefulWidget {
  @override
  _ClipboardMonitorPageState createState() => _ClipboardMonitorPageState();
}

class _ClipboardMonitorPageState extends State<ClipboardMonitorPage> {
  final List<ClipboardChangeEvent> _clipboardHistory = [];
  StreamSubscription<ClipboardChangeEvent>? _subscription;

  @override
  void initState() {
    super.initState();
    _startMonitoring();
  }

  void _startMonitoring() {
    // Lắng nghe thay đổi clipboard
    _subscription = ClipboardWatcher.instance.onClipboardChanged.listen(
      (event) {
        setState(() {
          _clipboardHistory.insert(0, event);
          // Giữ tối đa 50 items
          if (_clipboardHistory.length > 50) {
            _clipboardHistory.removeLast();
          }
        });
      },
    );

    // Bắt đầu theo dõi với interval 300ms
    ClipboardWatcher.instance.startWatching(
      pollingInterval: Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    // Không stop watcher ở đây nếu có widget khác cũng đang dùng
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clipboard Monitor'),
        actions: [
          IconButton(
            icon: Icon(ClipboardWatcher.instance.isWatching 
                ? Icons.pause : Icons.play_arrow),
            onPressed: () {
              if (ClipboardWatcher.instance.isWatching) {
                ClipboardWatcher.instance.stopWatching();
              } else {
                ClipboardWatcher.instance.startWatching();
              }
              setState(() {});
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Control Panel
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Text('Polling Interval: '),
                DropdownButton<int>(
                  value: ClipboardWatcher.instance.pollingInterval.inMilliseconds,
                  items: [100, 300, 500, 1000, 2000].map((ms) => 
                    DropdownMenuItem(
                      value: ms,
                      child: Text('${ms}ms'),
                    ),
                  ).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      ClipboardWatcher.instance.setPollingInterval(
                        Duration(milliseconds: value),
                      );
                      setState(() {});
                    }
                  },
                ),
              ],
            ),
          ),
          
          // History List
          Expanded(
            child: _clipboardHistory.isEmpty
                ? Center(child: Text('No clipboard changes yet'))
                : ListView.builder(
                    itemCount: _clipboardHistory.length,
                    itemBuilder: (context, index) {
                      final event = _clipboardHistory[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: ListTile(
                          title: Text(
                            event.newContent.length > 50
                                ? '${event.newContent.substring(0, 50)}...'
                                : event.newContent,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            '${event.timestamp.toString().substring(11, 19)} - '
                            '${event.newContent.length} chars',
                          ),
                          trailing: event.hasError
                              ? Icon(Icons.error, color: Colors.red)
                              : Icon(Icons.content_copy),
                          onTap: () {
                            // Copy lại vào clipboard
                            ClipboardWatcher.instance.setContent(event.newContent);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Copied to clipboard')),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}


----- 2. Usage với Mixin:

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> with ClipboardWatcherMixin {
  String _lastClipboardContent = '';

  @override
  void initState() {
    super.initState();
    // Bắt đầu lắng nghe với polling 500ms
    startListeningClipboard(
      pollingInterval: Duration(milliseconds: 500),
    );
  }

  @override
  void onClipboardChanged(ClipboardChangeEvent event) {
    setState(() {
      _lastClipboardContent = event.newContent;
    });
    
    // Xử lý logic khác
    if (event.newContent.contains('http')) {
      print('URL detected: ${event.newContent}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Last Clipboard Content:'),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _lastClipboardContent.isEmpty 
                    ? 'No content yet' 
                    : _lastClipboardContent,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



*/
