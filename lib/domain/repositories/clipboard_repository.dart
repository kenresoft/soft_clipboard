import 'package:soft_clipboard/domain/entities/clipboard_item.dart';

abstract class ClipboardRepository {
  /// Stream of clipboard items
  Stream<List<ClipboardItem>> getClipboardItems();

  /// Add a new clipboard item
  Future<void> addClipboardItem(ClipboardItem item);

  /// Update an existing clipboard item
  Future<void> updateClipboardItem(ClipboardItem item);

  /// Delete a clipboard item by id
  Future<void> deleteClipboardItem(String id);

  /// Delete all clipboard items
  Future<void> clearAllItems();

  /// Get a clipboard item by id
  Future<ClipboardItem?> getClipboardItemById(String id);

  /// Get the latest clipboard item
  Future<ClipboardItem?> getLatestClipboardItem();

  /// Check if content already exists in clipboard history
  Future<bool> contentExists(String content);
}
