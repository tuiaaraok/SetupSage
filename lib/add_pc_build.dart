import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:pc_builder/add_components_page.dart';
import 'package:pc_builder/hive/hive_box.dart';
import 'package:pc_builder/hive/model/assembled_model.dart';
import 'package:pc_builder/hive/model/component_model.dart';
import 'package:pc_builder/provider/them_provider.dart';
import 'package:provider/provider.dart';

class AddPcBuild extends StatefulWidget {
  const AddPcBuild({super.key});

  @override
  State<AddPcBuild> createState() {
    // TODO: implement createState
    return _SettingPageState();
  }
}

class _SettingPageState extends State<AddPcBuild> {
  Map<String, ComponentModel> currentComponents = {};
  Map<String, bool> currentKeyComponents = {};
  TextEditingController assemblyType = TextEditingController();
  List<ComponentModel> listText = [];

  List<String> _currencies = [];

  // ignore: unused_field
  String? _currentSelectedValue;
  @override
  void initState() {
    super.initState();
    Box<ComponentListModel> componentListModel =
        Hive.box<ComponentListModel>(HiveBoxes.componentListModel);
    if (componentListModel.isNotEmpty) {
      for (var element in componentListModel.keys) {
        componentListModel.get(element)!.infoComponents.map((toElement) {
          currentComponents[element] = toElement;
          setState(() {});
        });
      }
    }
    Box<AssembledCatalogModel> assembledCatalogModel =
        Hive.box<AssembledCatalogModel>(HiveBoxes.assembledCatalogModel);
    if (assembledCatalogModel.isNotEmpty) {
      _currencies = assembledCatalogModel.getAt(0)!.assemblyType.toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable:
              Hive.box<ComponentListModel>(HiveBoxes.componentListModel)
                  .listenable(),
          builder: (context, Box<ComponentListModel> box, _) {
            return SingleChildScrollView(
              child: Padding(
                padding:
                    EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20.w),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back,
                            size: 24.w,
                          ),
                        ),
                      ),
                    ),
                    CustomWidgets.catalog(
                      "Assembly type",
                      context.watch<ThemeProvider>().textFieldForm,
                      context.watch<ThemeProvider>().titleColor,
                      assemblyType,
                      _currencies,
                      onChanged: (p0) {
                        _currentSelectedValue = p0 ?? "";
                        setState(() {});
                      },
                    ),
                    for (var key in box.keys) ...[
                      CustomWidgets.catalogComponent(
                        key,
                        currentComponents[key]?.name ?? "",
                        context.watch<ThemeProvider>().textFieldForm,
                        context.watch<ThemeProvider>().titleColor,
                        box
                            .get(key)!
                            .infoComponents
                            .map((ComponentModel toElement) => toElement.name)
                            .toList(),
                        currentKeyComponents[key] ?? false,
                        onChangedIcon: (p0) {
                          currentKeyComponents[key] = p0 ?? false;
                          setState(() {});
                        },
                        onChanged: (p0) {
                          // Get the current component model for the specified key

                          var currentComponent = currentComponents[key];

// Check if the current component exists before trying to assign

                          // Find the first matching ComponentModel
                          var matchingComponent = box
                              .get(key)!
                              .infoComponents
                              .firstWhere((test) => test.name == p0,
                                  orElse: () => ComponentModel(
                                      componentTypeController: '',
                                      name: '',
                                      manufacturer: '',
                                      model: '',
                                      price: ''));

                          // Check if a matching component was found
                          if (matchingComponent !=
                              ComponentModel(
                                  componentTypeController: '',
                                  name: '',
                                  manufacturer: '',
                                  model: '',
                                  price: '')) {
                            // Assign the found component to the current one, if needed
                            currentComponent?.name = matchingComponent.name;
                            // You can also assign the entire model if necessary
                            currentComponents[key] =
                                matchingComponent; // If you want to replace the whole model
                          } else {
                            // Handle the case where no matching component was found
                            // For example, you could set the name to null or do something else
                            currentComponent?.name =
                                ""; // or some default value
                          }

                          setState(() {});
                        },
                      ),
                    ],
                    SizedBox(
                      height: 34.h,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  const AddComponentsPage(),
                            ),
                          );
                        },
                        child: Text(
                          "+Add components",
                          style: TextStyle(
                              fontSize: 18.sp, fontWeight: FontWeight.bold),
                        )),
                    SizedBox(
                      height: 64.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (assemblyType.text.isNotEmpty) {
                          Box<AssembledModel> assembledModel =
                              Hive.box<AssembledModel>(
                                  HiveBoxes.assembledModel);
                          Box<AssembledCatalogModel> assembledCatalogModel =
                              Hive.box<AssembledCatalogModel>(
                                  HiveBoxes.assembledCatalogModel);
                          int price = 0;
                          // ignore: avoid_function_literals_in_foreach_calls
                          currentComponents.values.forEach((action) {
                            price += int.tryParse(action.price) ?? 0;
                          });
                          if (assembledCatalogModel.isEmpty) {
                            Set<String> assemblyTyp = {};
                            assemblyTyp.add(assemblyType.text);
                            assembledCatalogModel.add(AssembledCatalogModel(
                                assemblyType: assemblyTyp));
                          }
                          assembledModel.add(AssembledModel(
                              assemblyTypeName: assemblyType.text,
                              component: currentComponents,
                              price: price));
                          Navigator.pop(context);
                        }
                        // componentModel.add(ComponentModel(
                        //     name: nameController.text,
                        //     manufacturer: manufacturerController.text,
                        //     model: modelController.text,
                        //     price: priceController.text,
                        //     componentTypeController: assemblyTypeController.text));
                        // if (componentListModel.keys
                        //     .contains(assemblyTypeController.text)) {
                        //   componentListModel.put(
                        //       assemblyTypeController.text,
                        //       ComponentListModel(infoComponents: [
                        //         ...componentListModel
                        //             .get(assemblyTypeController.text)!
                        //             .infoComponents,
                        //         ComponentModel(
                        //             name: nameController.text,
                        //             manufacturer: manufacturerController.text,
                        //             model: modelController.text,
                        //             price: priceController.text,
                        //             componentTypeController:
                        //                 assemblyTypeController.text)
                        //       ]));
                        // } else {
                        //   componentListModel.put(
                        //       assemblyTypeController.text,
                        //       ComponentListModel(infoComponents: [
                        //         ComponentModel(
                        //             name: nameController.text,
                        //             manufacturer: manufacturerController.text,
                        //             model: modelController.text,
                        //             price: priceController.text,
                        //             componentTypeController:
                        //                 assemblyTypeController.text)
                        //       ]));
                        // }
                      },
                      child: CustomWidgets.infoBtn(
                          "Add to the PC build",
                          context.watch<ThemeProvider>().containerColor,
                          context.read<ThemeProvider>().textContainerColor),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
