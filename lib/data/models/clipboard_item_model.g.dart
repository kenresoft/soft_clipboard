// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clipboard_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClipboardItemModelAdapter extends TypeAdapter<ClipboardItemModel> {
  @override
  final int typeId = 0;

  @override
  ClipboardItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClipboardItemModel(
      id: fields[0] as String,
      content: fields[1] as String,
      timestamp: fields[2] as DateTime,
      typeValue: fields[3] as int,
      isPinned: fields[4] as bool,
      isFavorite: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ClipboardItemModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.timestamp)
      ..writeByte(3)
      ..write(obj.typeValue)
      ..writeByte(4)
      ..write(obj.isPinned)
      ..writeByte(5)
      ..write(obj.isFavorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClipboardItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
