import 'package:soft_clipboard/domain/entities/clipboard_item.dart';
import 'package:soft_clipboard/domain/repositories/clipboard_repository.dart';

class AddClipboardItem {
  final ClipboardRepository repository;

  AddClipboardItem(this.repository);

  Future<void> call(ClipboardItem item) async {
    // Check if this content already exists to prevent duplicates
    final exists = await repository.contentExists(item.content);
    if (!exists) {
      return repository.addClipboardItem(item);
    }
  }
}