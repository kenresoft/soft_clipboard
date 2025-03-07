import 'dart:async';

import 'package:clipboard_watcher/clipboard_watcher.dart';
import 'package:flutter/services.dart';
import 'package:soft_clipboard/domain/entities/clipboard_item.dart';
import 'package:uuid/uuid.dart';

abstract class ClipboardService {
  Stream<ClipboardItem> get clipboardChanges;

  Future<String> getCurrentClipboardContent();

  Future<void> startListening();

  Future<void> stopListening();

  Future<void> copyToClipboard(String content);

  void dispose();
}

class ClipboardServiceImpl with ClipboardListener implements ClipboardService {
  final StreamController<ClipboardItem> _clipboardChangesController = StreamController<ClipboardItem>.broadcast();
  final Uuid _uuid = Uuid();
  String? _lastContent;

  @override
  Stream<ClipboardItem> get clipboardChanges => _clipboardChangesController.stream;

  @override
  Future<String> getCurrentClipboardContent() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    return clipboardData?.text ?? '';
  }

  @override
  Future<void> startListening() async {
    // Fetch initial clipboard content
    _lastContent = await getCurrentClipboardContent();

    // Start listening for clipboard changes
    clipboardWatcher.addListener(this);
    clipboardWatcher.start();
  }

  @override
  void onClipboardChanged() async {
    final currentContent = await getCurrentClipboardContent();

    // Only process if the content has actually changed
    if (currentContent.isNotEmpty && currentContent != _lastContent) {
      _lastContent = currentContent;

      final item = ClipboardItem(
        id: _uuid.v4(),
        content: currentContent,
        timestamp: DateTime.now(),
        type: ClipboardItem.detectType(currentContent),
      );

      _clipboardChangesController.add(item);
    }
  }

  @override
  Future<void> stopListening() async {
    clipboardWatcher.removeListener(this);
    clipboardWatcher.stop();
  }

  @override
  Future<void> copyToClipboard(String content) async {
    await Clipboard.setData(ClipboardData(text: content));
  }

  @override
  void dispose() {
    stopListening();
    _clipboardChangesController.close();
  }
}
