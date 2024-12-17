import 'package:hive/hive.dart';
part 'component_model.g.dart';

@HiveType(typeId: 2)
class ComponentListModel {
  @HiveField(1)
  List<ComponentModel> infoComponents;
  ComponentListModel({required this.infoComponents});
}

@HiveType(typeId: 3)
class ComponentModel {
  @HiveField(1)
  String componentTypeController;
  @HiveField(2)
  String name;
  @HiveField(3)
  String manufacturer;
  @HiveField(4)
  String model;
  @HiveField(5)
  String price;
  ComponentModel(
      {required this.componentTypeController,
      required this.name,
      required this.manufacturer,
      required this.model,
      required this.price});
}
