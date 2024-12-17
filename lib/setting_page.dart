import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:pc_builder/provider/them_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() {
    // TODO: implement createState
    return _SettingPageState();
  }
}

class _SettingPageState extends State<SettingPage> {
  // ignore: unused_field, prefer_final_fields
  bool _lights = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Padding(
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
            SizedBox(
              height: 67.h,
            ),
            Container(
              width: 331.w,
              alignment: Alignment.centerRight,
              child: SwitchListTile.adaptive(
                activeTrackColor: const Color(0xFF76EE59),
                activeColor: Colors.white,
                inactiveTrackColor: Colors.white,
                inactiveThumbColor: const Color(0xFFEFEFEF),
                title: Text(
                  context.watch<ThemeProvider>().isDarkMode ? 'Dark' : 'Lights',
                  style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w500,
                      color: context.read<ThemeProvider>().textContainerColor),
                ),
                value: context.watch<ThemeProvider>().isDarkMode,
                onChanged: (bool value) {
                  context.read<ThemeProvider>().toggleTheme();
                },
                secondary: Icon(
                  Icons.lightbulb_outline,
                  color: context.watch<ThemeProvider>().containerColor,
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            SizedBox(
              height: 256.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () async {
                      String? encodeQueryParameters(
                          Map<String, String> params) {
                        return params.entries
                            .map((MapEntry<String, String> e) =>
                                '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                            .join('&');
                      }

                      // ···
                      final Uri emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: 'hasanyildiz1705@icloud.com',
                        query: encodeQueryParameters(<String, String>{
                          '': '',
                        }),
                      );
                      try {
                        if (await canLaunchUrl(emailLaunchUri)) {
                          await launchUrl(emailLaunchUri);
                        } else {
                          throw Exception("Could not launch $emailLaunchUri");
                        }
                      } catch (e) {
                        log('Error launching email client: $e'); // Log the error
                      }
                    },
                    child: menuBtn(
                        "Contact Us",
                        context.watch<ThemeProvider>().containerColor,
                        context.read<ThemeProvider>().textContainerColor),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final Uri url = Uri.parse(
                          'https://docs.google.com/document/d/1Wd7CEKNIetZ-0U_tkAcrlO2KCDJozU4iFwZmsume20E/mobilebasic');
                      if (!await launchUrl(url)) {
                        throw Exception('Could not launch $url');
                      }
                    },
                    child: menuBtn(
                        "Privacy Policy",
                        context.watch<ThemeProvider>().containerColor,
                        context.read<ThemeProvider>().textContainerColor),
                  ),
                  GestureDetector(
                    onTap: () async {
                      InAppReview.instance.openStoreListing(
                        appStoreId: '6739065995',
                      );
                      // 6739065995
                    },
                    child: menuBtn(
                        "Rate Us",
                        context.watch<ThemeProvider>().containerColor,
                        context.read<ThemeProvider>().textContainerColor),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Image(
                width: double.infinity,
                height: 337.h,
                image: const AssetImage(
                  "assets/menu.png",
                )),
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
