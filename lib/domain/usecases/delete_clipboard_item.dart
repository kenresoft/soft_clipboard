import 'package:soft_clipboard/domain/repositories/clipboard_repository.dart';

class DeleteClipboardItem {
  final ClipboardRepository repository;

  DeleteClipboardItem(this.repository);

  Future<void> call(String id) {
    return repository.deleteClipboardItem(id);
  }
}