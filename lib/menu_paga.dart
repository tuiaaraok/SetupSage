import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pc_builder/assembled_pcs_page.dart';
import 'package:pc_builder/components_page.dart';
import 'package:pc_builder/provider/them_provider.dart';
import 'package:pc_builder/setting_page.dart';
import 'package:provider/provider.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() {
    // TODO: implement createState
    return _MenuPageState();
  }
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
        child: Column(
          children: [
            SizedBox(
              height: 27.h,
            ),
            Image(
                width: double.infinity,
                height: 337.h,
                image: const AssetImage("assets/menu.png")),
            SizedBox(
              height: 80.h,
            ),
            SizedBox(
              height: 256.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              const ComponentsPage(),
                        ),
                      );
                    },
                    child: menuBtn(
                        "Components",
                        context.watch<ThemeProvider>().containerColor,
                        context.read<ThemeProvider>().textContainerColor),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              const AssembledPcsPage(),
                        ),
                      );
                    },
                    child: menuBtn(
                        "Assembled PCs",
                        context.watch<ThemeProvider>().containerColor,
                        context.read<ThemeProvider>().textContainerColor),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              const SettingPage(),
                        ),
                      );
                    },
                    child: menuBtn(
                        "Settings",
                        context.watch<ThemeProvider>().containerColor,
                        context.read<ThemeProvider>().textContainerColor),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget menuBtn(String description, Color container, Color text) {
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
