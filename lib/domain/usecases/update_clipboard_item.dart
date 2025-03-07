import 'package:soft_clipboard/domain/entities/clipboard_item.dart';
import 'package:soft_clipboard/domain/repositories/clipboard_repository.dart';

class UpdateClipboardItem {
  final ClipboardRepository repository;

  UpdateClipboardItem(this.repository);

  Future<void> call(ClipboardItem item) {
    return repository.updateClipboardItem(item);
  }
}
