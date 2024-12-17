// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'component_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ComponentListModelAdapter extends TypeAdapter<ComponentListModel> {
  @override
  final int typeId = 2;

  @override
  ComponentListModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ComponentListModel(
      infoComponents: (fields[1] as List).cast<ComponentModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, ComponentListModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(1)
      ..write(obj.infoComponents);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ComponentListModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ComponentModelAdapter extends TypeAdapter<ComponentModel> {
  @override
  final int typeId = 3;

  @override
  ComponentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ComponentModel(
      componentTypeController: fields[1] as String,
      name: fields[2] as String,
      manufacturer: fields[3] as String,
      model: fields[4] as String,
      price: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ComponentModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(1)
      ..write(obj.componentTypeController)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.manufacturer)
      ..writeByte(4)
      ..write(obj.model)
      ..writeByte(5)
      ..write(obj.price);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ComponentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
