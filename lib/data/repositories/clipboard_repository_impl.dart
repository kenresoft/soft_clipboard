import 'package:soft_clipboard/data/datasources/clipboard_local_datasource.dart';
import 'package:soft_clipboard/data/models/clipboard_item_model.dart';
import 'package:soft_clipboard/domain/entities/clipboard_item.dart';
import 'package:soft_clipboard/domain/repositories/clipboard_repository.dart';

class ClipboardRepositoryImpl implements ClipboardRepository {
  final ClipboardLocalDataSource localDataSource;

  ClipboardRepositoryImpl({required this.localDataSource});

  @override
  Stream<List<ClipboardItem>> getClipboardItems() {
    return localDataSource.getClipboardItems().map((items) => items.map((item) => item.toEntity()).toList());
  }

  @override
  Future<void> addClipboardItem(ClipboardItem item) async {
    final model = ClipboardItemModel.fromEntity(item);
    await localDataSource.addClipboardItem(model);
  }

  @override
  Future<void> updateClipboardItem(ClipboardItem item) async {
    final model = ClipboardItemModel.fromEntity(item);
    await localDataSource.updateClipboardItem(model);
  }

  @override
  Future<void> deleteClipboardItem(String id) async {
    await localDataSource.deleteClipboardItem(id);
  }

  @override
  Future<void> clearAllItems() async {
    await localDataSource.clearAllItems();
  }

  @override
  Future<ClipboardItem?> getClipboardItemById(String id) async {
    final model = await localDataSource.getClipboardItemById(id);
    return model?.toEntity();
  }

  @override
  Future<ClipboardItem?> getLatestClipboardItem() async {
    final model = await localDataSource.getLatestClipboardItem();
    return model?.toEntity();
  }

  @override
  Future<bool> contentExists(String content) {
    return localDataSource.contentExists(content);
  }
}
