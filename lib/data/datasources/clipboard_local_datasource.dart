import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:soft_clipboard/data/models/clipboard_item_model.dart';

abstract class ClipboardLocalDataSource {
  Stream<List<ClipboardItemModel>> getClipboardItems();

  Future<void> addClipboardItem(ClipboardItemModel item);

  Future<void> updateClipboardItem(ClipboardItemModel item);

  Future<void> deleteClipboardItem(String id);

  Future<void> clearAllItems();

  Future<ClipboardItemModel?> getClipboardItemById(String id);

  Future<ClipboardItemModel?> getLatestClipboardItem();

  Future<bool> contentExists(String content);

  void dispose();
}

class ClipboardLocalDataSourceImpl implements ClipboardLocalDataSource {
  final Box<ClipboardItemModel> clipboardBox;
  final StreamController<List<ClipboardItemModel>> _clipboardStreamController = StreamController<List<ClipboardItemModel>>.broadcast();

  ClipboardLocalDataSourceImpl({required this.clipboardBox}) {
    // Initialize the stream with existing data
    _updateStream();

    // Listen to Hive changes and update the stream
    clipboardBox.listenable().addListener(_updateStream);
  }

  void _updateStream() {
    if (_clipboardStreamController.isClosed) return;

    Future.microtask(() {
      final items = clipboardBox.values.toList();

      // Sort items: Pinned items first, then by timestamp (newest first)
      items.sort((a, b) {
        if (a.isPinned && !b.isPinned) return -1;
        if (!a.isPinned && b.isPinned) return 1;
        return b.timestamp.compareTo(a.timestamp);
      });

      _clipboardStreamController.add(items);
    });
  }

  @override
  Stream<List<ClipboardItemModel>> getClipboardItems() {
    return _clipboardStreamController.stream;
  }

  @override
  Future<void> addClipboardItem(ClipboardItemModel item) async {
    await clipboardBox.put(item.id, item);
    _updateStream();
  }

  @override
  Future<void> updateClipboardItem(ClipboardItemModel item) async {
    await clipboardBox.put(item.id, item);
    _updateStream();
  }

  @override
  Future<void> deleteClipboardItem(String id) async {
    await clipboardBox.delete(id);
    _updateStream();
  }

  @override
  Future<void> clearAllItems() async {
    // Keep pinned and favorite items
    final keysToKeep = <String>{};
    for (final item in clipboardBox.values) {
      if (item.isPinned || item.isFavorite) {
        keysToKeep.add(item.id);
      }
    }

    // Collect keys to delete
    final keysToDelete = clipboardBox.keys.where((key) => !keysToKeep.contains(key)).toList();
    await clipboardBox.deleteAll(keysToDelete);

    _updateStream();
  }

  @override
  Future<ClipboardItemModel?> getClipboardItemById(String id) async {
    return clipboardBox.get(id);
  }

  @override
  Future<ClipboardItemModel?> getLatestClipboardItem() async {
    if (clipboardBox.isEmpty) return null;

    final items = clipboardBox.values.toList()..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return items.isNotEmpty ? items.first : null;
  }

  @override
  Future<bool> contentExists(String content) async {
    final normalizedContent = content.trim();
    return clipboardBox.values.any((item) => item.content.trim() == normalizedContent);
  }

  @override
  void dispose() {
    clipboardBox.listenable().removeListener(_updateStream);
    _clipboardStreamController.close();
  }
}
