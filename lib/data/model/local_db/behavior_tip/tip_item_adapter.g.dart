// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tip_item_adapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TipItemAdapter extends TypeAdapter<TipItem> {
  @override
  final int typeId = 1;

  @override
  TipItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TipItem(
      fields[0] as String,
      fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TipItem obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.checked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TipItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
