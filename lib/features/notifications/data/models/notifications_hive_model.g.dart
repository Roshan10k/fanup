// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationsHiveModelAdapter
    extends TypeAdapter<NotificationsHiveModel> {
  @override
  final int typeId = 3;

  @override
  NotificationsHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationsHiveModel(
      storedAt: fields[0] as DateTime,
      itemsJson: (fields[1] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      unreadCount: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationsHiveModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.storedAt)
      ..writeByte(1)
      ..write(obj.itemsJson)
      ..writeByte(2)
      ..write(obj.unreadCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationsHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
