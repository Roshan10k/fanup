// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_wallet_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DashboardWalletHiveModelAdapter
    extends TypeAdapter<DashboardWalletHiveModel> {
  @override
  final int typeId = 2;

  @override
  DashboardWalletHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DashboardWalletHiveModel(
      storedAt: fields[0] as DateTime,
      summaryJson: (fields[1] as Map?)?.cast<String, dynamic>(),
      transactionsJson: (fields[2] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, DashboardWalletHiveModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.storedAt)
      ..writeByte(1)
      ..write(obj.summaryJson)
      ..writeByte(2)
      ..write(obj.transactionsJson);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashboardWalletHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
