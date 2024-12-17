import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:pc_builder/add_components_page.dart';
import 'package:pc_builder/hive/hive_box.dart';
import 'package:pc_builder/hive/model/component_model.dart';
import 'package:pc_builder/provider/them_provider.dart';
import 'package:provider/provider.dart';

class ComponentsPage extends StatefulWidget {
  const ComponentsPage({super.key});

  @override
  State<ComponentsPage> createState() {
    // TODO: implement createState
    return _ComponentsPageState();
  }
}

class _ComponentsPageState extends State<ComponentsPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
        child: ValueListenableBuilder(
            valueListenable:
                Hive.box<ComponentModel>(HiveBoxes.componentModel).listenable(),
            builder: (context, Box<ComponentModel> box, _) {
              return SingleChildScrollView(
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
                    Padding(
                      padding: EdgeInsets.only(top: 20.h),
                      child: Text(
                        "Components",
                        style: TextStyle(
                            fontSize: 26.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.h),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  const AddComponentsPage(),
                            ),
                          );
                        },
                        child: CustomWidgets.infoBtn(
                            "Add components",
                            context.watch<ThemeProvider>().containerColor,
                            context.read<ThemeProvider>().textContainerColor),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    for (int i = box.values.length - 1; i >= 0; i--) ...[
                      Padding(
                        padding: EdgeInsets.only(top: 20.h),
                        child: Container(
                          width: 336.w,
                          decoration: BoxDecoration(
                            border: DashedBorder.fromBorderSide(
                                dashLength: 5,
                                side: BorderSide(
                                    color: context
                                        .watch<ThemeProvider>()
                                        .titleColor,
                                    width: 2)),
                            color: context.watch<ThemeProvider>().textFieldForm,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 17.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 14.h),
                                  child: Center(
                                    child: Text(
                                      box.getAt(i)!.componentTypeController,
                                      style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 11.h),
                                  child: Text(
                                    "Name: ${box.getAt(i)!.name}",
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 11.h),
                                  child: Text(
                                    "Manufacturer: ${box.getAt(i)!.manufacturer}",
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 11.h),
                                  child: Text(
                                    "Model: ${box.getAt(i)!.model}",
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 11.h),
                                  child: Text(
                                    "Price: \$${box.getAt(i)!.price}",
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                    SizedBox(
                      height: 67.h,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}

menuBtn(String description, Color container, Color text) {
  return Container(
    width: 331.w,
    height: 72.h,
    decoration: BoxDecoration(color: container, boxShadow: [
      BoxShadow(color: Colors.black, offset: Offset(2.w, 4.h), blurRadius: 0)
    ]),
    child: Center(
      child: Text(
        description,
        style: TextStyle(
            fontSize: 26.sp, fontWeight: FontWeight.w500, color: text),
      ),
    ),
  );
}
