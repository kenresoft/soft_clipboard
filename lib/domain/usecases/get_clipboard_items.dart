import 'package:soft_clipboard/domain/entities/clipboard_item.dart';
import 'package:soft_clipboard/domain/repositories/clipboard_repository.dart';

class GetClipboardItems {
  final ClipboardRepository repository;

  GetClipboardItems(this.repository);

  Stream<List<ClipboardItem>> call() {
    return repository.getClipboardItems();
  }
}