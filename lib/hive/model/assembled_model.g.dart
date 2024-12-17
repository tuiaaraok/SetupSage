// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assembled_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AssembledModelAdapter extends TypeAdapter<AssembledModel> {
  @override
  final int typeId = 1;

  @override
  AssembledModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AssembledModel(
      assemblyTypeName: fields[1] as String,
      component: (fields[2] as Map).cast<String, ComponentModel>(),
      price: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, AssembledModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.assemblyTypeName)
      ..writeByte(2)
      ..write(obj.component)
      ..writeByte(3)
      ..write(obj.price);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssembledModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AssembledCatalogModelAdapter extends TypeAdapter<AssembledCatalogModel> {
  @override
  final int typeId = 4;

  @override
  AssembledCatalogModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AssembledCatalogModel(
      assemblyType: (fields[0] as List).cast<String>().toSet(),
    );
  }

  @override
  void write(BinaryWriter writer, AssembledCatalogModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.assemblyType.toList());
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssembledCatalogModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
