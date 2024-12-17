import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pc_builder/firebase_options.dart';
import 'package:pc_builder/hive/hive_box.dart';
import 'package:pc_builder/hive/model/assembled_model.dart';
import 'package:pc_builder/hive/model/component_model.dart';
import 'package:pc_builder/menu_paga.dart';
import 'package:pc_builder/provider/them_provider.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter(); // Инициализация Hive
  await Hive.openBox('Settings');
  Hive.registerAdapter(AssembledModelAdapter());
  Hive.registerAdapter(AssembledCatalogModelAdapter());
  Hive.registerAdapter(ComponentModelAdapter());
  Hive.registerAdapter(ComponentListModelAdapter());
  await Hive.openBox<AssembledModel>(HiveBoxes.assembledModel);
  await Hive.openBox<AssembledCatalogModel>(HiveBoxes.assembledCatalogModel);
  await Hive.openBox<ComponentModel>(HiveBoxes.componentModel);
  await Hive.openBox<ComponentListModel>(HiveBoxes.componentListModel);

  // SystemChrome.setSystemUIOverlayStyle(
  //     SystemUiOverlayStyle(statusBarColor: Colors.black));
  await _initializeRemoteConfig().then((onValue) {
    runApp(MyApp(
      link: onValue,
    ));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.link});
  final String link;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(402, 874),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return ValueListenableBuilder<Box>(
              valueListenable: Hive.box('Settings').listenable(),
              builder: (context, box, _) {
                return ChangeNotifierProvider(
                  create: (_) => ThemeProvider(box),
                  child:
                      Consumer<ThemeProvider>(builder: (context, provider, _) {
                    return MaterialApp(
                        title: 'Flutter Demo',
                        debugShowCheckedModeBanner: false,
                        // onGenerateRoute: NavigationApp.generateRoute,

                        theme: ThemeData(
                          scaffoldBackgroundColor: const Color(0xFFC9DBBE),
                          appBarTheme: const AppBarTheme(
                              backgroundColor: Colors.transparent,
                              systemOverlayStyle: SystemUiOverlayStyle.dark),
                        ),
                        darkTheme: ThemeData(
                          scaffoldBackgroundColor: const Color(0xFF3C522D),
                          brightness: Brightness.dark,
                        ),
                        themeMode: provider.isDarkMode
                            ? ThemeMode.dark
                            : ThemeMode.light,
                        home: Hive.box("privacyLink").isEmpty
                            ? WebViewScreen(
                                link: link,
                              )
                            : Hive.box("privacyLink")
                                    .get('link')
                                    .contains("showAgreebutton")
                                ? const MenuPage()
                                : WebViewScreen(
                                    link: link,
                                  ));
                  }),
                );
              });
        });
  }
}

Future<String> _initializeRemoteConfig() async {
  final remoteConfig = FirebaseRemoteConfig.instance;
  var box = await Hive.openBox('privacyLink');
  String link = '';

  if (box.isEmpty) {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(minutes: 1),
    ));

    // Defaults setup

    try {
      await remoteConfig.fetchAndActivate();

      link = remoteConfig.getString("link");
    } catch (e) {
      log("Failed to fetch remote config: $e");
    }
  } else {
    if (box.get('link').contains("showAgreebutton")) {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(minutes: 1),
      ));

      try {
        await remoteConfig.fetchAndActivate();

        link = remoteConfig.getString("link");
      } catch (e) {
        log("Failed to fetch remote config: $e");
      }
      if (!link.contains("showAgreebutton")) {
        box.put('link', link);
      }
    } else {
      link = box.get('link');
    }
  }

  return link == ""
      ? "https://telegra.ph/AntiqueAtlas-Keep-Collection-Privacy-Policy-11-08?showAgreebutton"
      : link;
}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key, required this.link});
  final String link;

  @override
  State<WebViewScreen> createState() {
    return _WebViewScreenState();
  }
}

class _WebViewScreenState extends State<WebViewScreen> {
  bool loadAgree = false;
  WebViewController controller = WebViewController();
  final remoteConfig = FirebaseRemoteConfig.instance;

  @override
  void initState() {
    super.initState();
    if (Hive.box("privacyLink").isEmpty) {
      Hive.box("privacyLink").put('link', widget.link);
    }

    _initializeWebView(widget.link); // Initialize WebViewController
  }

  void _initializeWebView(String url) {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress == 100) {
              loadAgree = true;
              setState(() {});
            }
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
    setState(() {}); // Optional, if you want to trigger a rebuild elsewhere
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
        child: Stack(children: [
          WebViewWidget(controller: controller),
          if (loadAgree)
            GestureDetector(
                onTap: () async {
                  await Hive.openBox('privacyLink').then((box) {
                    box.put('link', widget.link);
                    Navigator.push(
                      // ignore: use_build_context_synchronously
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const MenuPage(),
                      ),
                    );
                  });
                },
                child: widget.link.contains("showAgreebutton")
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Container(
                            width: 200,
                            height: 60,
                            color: Colors.amber,
                            child: const Center(child: Text("AGREE")),
                          ),
                        ))
                    : null),
        ]),
      ),
    );
  }
}
