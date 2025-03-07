import 'package:hive/hive.dart';
import 'package:soft_clipboard/domain/entities/clipboard_item.dart';

part 'clipboard_item_model.g.dart';

@HiveType(typeId: 0)
class ClipboardItemModel extends ClipboardItem {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String content;

  @HiveField(2)
  final DateTime timestamp;

  @HiveField(3)
  final int typeValue;

  @HiveField(4)
  final bool isPinned;

  @HiveField(5)
  final bool isFavorite;

  ClipboardItemModel({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.typeValue,
    this.isPinned = false,
    this.isFavorite = false,
  }) : super(
          id: id,
          content: content,
          timestamp: timestamp,
          type: ClipboardItemType.values[typeValue],
          isPinned: isPinned,
          isFavorite: isFavorite,
        );

  factory ClipboardItemModel.fromEntity(ClipboardItem entity) {
    return ClipboardItemModel(
      id: entity.id,
      content: entity.content,
      timestamp: entity.timestamp,
      typeValue: entity.type.index,
      isPinned: entity.isPinned,
      isFavorite: entity.isFavorite,
    );
  }

  ClipboardItem toEntity() {
    return ClipboardItem(
      id: id,
      content: content,
      timestamp: timestamp,
      type: ClipboardItemType.values[typeValue],
      isPinned: isPinned,
      isFavorite: isFavorite,
    );
  }
}
