import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:pc_builder/hive/hive_box.dart';
import 'package:pc_builder/hive/model/component_model.dart';
import 'package:pc_builder/provider/them_provider.dart';
import 'package:provider/provider.dart';

class AddComponentsPage extends StatefulWidget {
  const AddComponentsPage({super.key});

  @override
  State<AddComponentsPage> createState() {
    // TODO: implement createState
    return _SettingPageState();
  }
}

class _SettingPageState extends State<AddComponentsPage> {
  TextEditingController componentTypeController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController manufacturerController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  FocusNode priceNode = FocusNode();
  List<String> _currencies = [];
  // ignore: unused_field
  String? _currentSelectedValue;
  @override
  void initState() {
    super.initState();
    Box<ComponentListModel> componentListModel =
        Hive.box<ComponentListModel>(HiveBoxes.componentListModel);
    if (componentListModel.isNotEmpty) {
      _currencies = componentListModel.keys.toList().cast<String>();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: KeyboardActions(
        config: KeyboardActionsConfig(
          keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
          nextFocus: false,
          actions: [
            KeyboardActionsItem(
              focusNode: priceNode,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
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
                // componentTypeController.text = value ?? "";
                //                   setState(() {});
                CustomWidgets.catalog(
                  "Component type",
                  context.watch<ThemeProvider>().textFieldForm,
                  context.watch<ThemeProvider>().titleColor,
                  componentTypeController,
                  _currencies,
                  onChanged: (p0) {
                    componentTypeController.text = p0 ?? "";
                    setState(() {});
                  },
                ),
                CustomWidgets.textFieldForm(
                  "Name",
                  358.w,
                  nameController,
                  context.watch<ThemeProvider>().titleColor,
                  context.watch<ThemeProvider>().textFieldForm,
                  context.watch<ThemeProvider>().titleColor,
                ),
                CustomWidgets.textFieldForm(
                  "Manufacturer",
                  358.w,
                  manufacturerController,
                  context.watch<ThemeProvider>().titleColor,
                  context.watch<ThemeProvider>().textFieldForm,
                  context.watch<ThemeProvider>().titleColor,
                ),
                CustomWidgets.textFieldForm(
                  "Model",
                  358.w,
                  modelController,
                  context.watch<ThemeProvider>().titleColor,
                  context.watch<ThemeProvider>().textFieldForm,
                  context.watch<ThemeProvider>().titleColor,
                ),
                CustomWidgets.textFieldForm(
                  "Price",
                  358.w,
                  priceController,
                  myNode: priceNode,
                  keyboard: TextInputType.number,
                  context.watch<ThemeProvider>().titleColor,
                  context.watch<ThemeProvider>().textFieldForm,
                  context.watch<ThemeProvider>().titleColor,
                ),
                SizedBox(
                  height: 280.h,
                ),
                GestureDetector(
                  onTap: () {
                    if (nameController.text.isNotEmpty &&
                        manufacturerController.text.isNotEmpty &&
                        modelController.text.isNotEmpty &&
                        priceController.text.isNotEmpty &&
                        componentTypeController.text.isNotEmpty) {
                      Box<ComponentListModel> componentListModel =
                          Hive.box<ComponentListModel>(
                              HiveBoxes.componentListModel);
                      Box<ComponentModel> componentModel =
                          Hive.box<ComponentModel>(HiveBoxes.componentModel);
                      componentModel.add(ComponentModel(
                          name: nameController.text,
                          manufacturer: manufacturerController.text,
                          model: modelController.text,
                          price: priceController.text,
                          componentTypeController:
                              componentTypeController.text));
                      if (componentListModel.keys
                          .contains(componentTypeController.text)) {
                        componentListModel.put(
                            componentTypeController.text,
                            ComponentListModel(infoComponents: [
                              ComponentModel(
                                  name: nameController.text,
                                  manufacturer: manufacturerController.text,
                                  model: modelController.text,
                                  price: priceController.text,
                                  componentTypeController:
                                      componentTypeController.text),
                              ...componentListModel
                                  .get(componentTypeController.text)!
                                  .infoComponents,
                            ]));
                      } else {
                        componentListModel.put(
                            componentTypeController.text,
                            ComponentListModel(infoComponents: [
                              ComponentModel(
                                  name: nameController.text,
                                  manufacturer: manufacturerController.text,
                                  model: modelController.text,
                                  price: priceController.text,
                                  componentTypeController:
                                      componentTypeController.text)
                            ]));
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: CustomWidgets.infoBtn(
                      "Add to the component",
                      context.watch<ThemeProvider>().containerColor,
                      context.read<ThemeProvider>().textContainerColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomWidgets {
  static Widget infoBtn(String description, Color container, Color text) {
    return Container(
      width: 331.w,
      height: 45.h,
      decoration: BoxDecoration(color: container, boxShadow: [
        BoxShadow(color: Colors.black, offset: Offset(2.w, 4.h), blurRadius: 0)
      ]),
      child: Center(
        child: Text(
          description,
          style: TextStyle(
              fontSize: 18.sp, fontWeight: FontWeight.w500, color: text),
        ),
      ),
    );
  }

  static Widget textFieldForm(
      String description,
      double widthContainer,
      TextEditingController myController,
      Color title,
      Color container,
      Color stroke,
      {FocusNode? myNode,
      TextInputType? keyboard}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 14.h),
          child: SizedBox(
            width: widthContainer,
            child: Text(
              description,
              style: TextStyle(
                  fontSize: 18.sp, color: title, fontWeight: FontWeight.w400),
            ),
          ),
        ),
        Container(
          height: 48.h,
          width: widthContainer,
          decoration: BoxDecoration(
            border: DashedBorder.fromBorderSide(
                dashLength: 5, side: BorderSide(color: stroke, width: 2)),
            color: container,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Center(
              child: TextField(
                focusNode: myNode,
                controller: myController,
                decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: '',
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 15.sp)),
                keyboardType: keyboard ?? TextInputType.text,
                cursorColor: Colors.black,
                style: TextStyle(
                    color: title, fontWeight: FontWeight.bold, fontSize: 15.sp),
                onChanged: (text) {
                  // Additional functionality can be added here
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget textFieldViewCategory(
      String description,
      double widthContainer,
      TextEditingController myController,
      bool isOpenMenuCategory,
      VoidCallback onToggle,
      List<String> categoryMenu,
      void Function(String) onTapMenuElem) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20.h),
          child: SizedBox(
            width: widthContainer,
            child: Text(
              description,
              style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        Container(
          height: isOpenMenuCategory
              ? categoryMenu.isEmpty
                  ? 43.h
                  : null
              : 43.h,
          width: widthContainer,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
            color: Colors.white,
            border: Border.all(color: const Color(0xFFDAE0E6), width: 2.w),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: isOpenMenuCategory
                ? Stack(
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: categoryMenu.map((toElement) {
                            return GestureDetector(
                              onTap: () {
                                onTapMenuElem(toElement);
                              },
                              child: Text(
                                toElement,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.sp),
                              ),
                            );
                          }).toList()),
                      Positioned(
                        right: 0.w,
                        top: 0.h,
                        child: GestureDetector(
                            onTap: onToggle,
                            child: Icon(
                              isOpenMenuCategory
                                  ? Icons.keyboard_arrow_down
                                  : Icons.keyboard_arrow_up,
                              size: 20.w,
                            )),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: TextField(
                            controller: myController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintText: '',
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                    fontSize: 14.sp)),
                            keyboardType: TextInputType.text,
                            cursorColor: Colors.black,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp),
                            onChanged: (text) {},
                          ),
                        ),
                      ),
                      GestureDetector(
                          onTap: onToggle,
                          child: Icon(
                            isOpenMenuCategory
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: const Color(0xFF5F61F3),
                            size: 30.w,
                          )),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  static Widget catalog(String description, Color container, Color stroke,
      TextEditingController myController, List<String> catalog,
      {void Function(String?)? onChanged}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 14.h),
          child: SizedBox(
            width: 358.w,
            child: Text(
              description,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400),
            ),
          ),
        ),
        Container(
          width: 358.w,
          height: 48.h,
          decoration: BoxDecoration(
            border: DashedBorder.fromBorderSide(
                dashLength: 5, side: BorderSide(color: stroke, width: 2)),
            color: container,
            // color: context.watch<ThemeProvider>().textFieldForm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: TextField(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(25),
                    ],
                    controller: myController,
                    textAlign: TextAlign.start,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                        border: InputBorder.none, // Убираем обводку
                        focusedBorder:
                            InputBorder.none, // Убираем обводку при фокусе
                        hintText: '',
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 21.sp)),
                    keyboardType: TextInputType.multiline,
                    cursorColor: Colors.black,
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 21.sp),
                    onChanged: (text) {},
                    onSubmitted: (value) {},
                  ),
                ),
              ),
              DropdownButtonHideUnderline(
                child: DropdownButton2(
                  customButton: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 24.w,
                    ),
                  ),
                  items: catalog
                      .expand((String item) => [
                            DropdownMenuItem<String>(
                                value: item,
                                child: Center(
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                )),
                          ])
                      .toList(),
                  onChanged: (value) {
                    onChanged!(value);
                  },
                  dropdownStyleData: DropdownStyleData(
                    width: 358.w,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white,
                    ),
                    offset: Offset(-310.w, -20.h),
                  ),
                  menuItemStyleData: MenuItemStyleData(
                    customHeights: List.filled(catalog.length, 50.h),
                    padding: EdgeInsets.only(left: 16.w, right: 16.w),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget catalogComponent(String description, String component,
      Color container, Color stroke, List<String> catalog, bool isOpen,
      {void Function(bool?)? onChangedIcon,
      void Function(String?)? onChanged}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 14.h),
          child: SizedBox(
            width: 358.w,
            child: Text(
              description,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400),
            ),
          ),
        ),
        Container(
          width: 358.w,
          height: 48.h,
          decoration: BoxDecoration(
            border: DashedBorder.fromBorderSide(
                dashLength: 5, side: BorderSide(color: stroke, width: 2)),
            color: container,
            // color: context.watch<ThemeProvider>().textFieldForm,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2(
              customButton: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        component,
                        style: TextStyle(
                            fontSize: 21.sp, fontWeight: FontWeight.w400),
                      ),
                    ),
                    Icon(
                      isOpen
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 24.w,
                    ),
                  ],
                ),
              ),
              items: catalog
                  .expand((String item) => [
                        DropdownMenuItem<String>(
                            value: item,
                            child: Center(
                              child: Text(
                                item,
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            )),
                      ])
                  .toList(),
              onMenuStateChange: (isopen) {
                onChangedIcon!(isopen);
              },
              onChanged: (value) {
                onChanged!(value);
              },
              dropdownStyleData: DropdownStyleData(
                width: 358.w,
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white,
                ),
                offset: Offset(0, -20.h),
              ),
              menuItemStyleData: MenuItemStyleData(
                customHeights: List.filled(catalog.length, 50.h),
                padding: EdgeInsets.only(left: 16.w, right: 16.w),
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget descriptionTextFieldForm(
      String description,
      double widthContainer,
      TextEditingController myController,
      Color title,
      Color container,
      Color stroke,
      FocusNode focus) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20.h),
          child: SizedBox(
            width: widthContainer,
            child: Text(
              description,
              style: TextStyle(
                  fontSize: 15.sp, color: title, fontWeight: FontWeight.w400),
            ),
          ),
        ),
        Container(
          height: 108.h,
          width: widthContainer,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
              color: container,
              border: Border.all(color: stroke, width: 2.w)),
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: TextField(
                maxLines: null,
                focusNode: focus,
                controller: myController,
                decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: '',
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 16.sp)),
                keyboardType: TextInputType.multiline,
                cursorColor: title,
                style: TextStyle(
                    color: title, fontWeight: FontWeight.bold, fontSize: 16.sp),
                onChanged: (text) {},
              )),
        ),
      ],
    );
  }
}
