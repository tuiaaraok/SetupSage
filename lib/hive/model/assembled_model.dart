import 'package:pc_builder/hive/model/component_model.dart';
import 'package:hive/hive.dart';
part 'assembled_model.g.dart';

@HiveType(typeId: 1)
class AssembledModel {
  @HiveField(1)
  String assemblyTypeName;
  @HiveField(2)
  Map<String, ComponentModel> component;
  @HiveField(3)
  int price;
  AssembledModel(
      {required this.assemblyTypeName,
      required this.component,
      required this.price});
}

@HiveType(typeId: 4)
class AssembledCatalogModel {
  @HiveField(0)
  Set<String> assemblyType;
  AssembledCatalogModel({required this.assemblyType});
}
