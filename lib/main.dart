import 'package:device_preview/device_preview.dart';
import 'package:digidastavej/app/controllers/document_controller.dart';
import 'package:digidastavej/app/utils/dark_theme.dart';
import 'package:digidastavej/app/utils/light_theme.dart';
import 'package:get/get.dart';

import 'app/data/models/document_model.dart';
import 'routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Hive and register adapter
  await Hive.initFlutter();
  Hive.registerAdapter(DocumentModelAdapter());

  // Open the box to store documents
  await Hive.openBox<DocumentModel>('documents');

  // runApp(
  //   DevicePreview(
  //     enabled: false,
  //     tools: const [
  //       ...DevicePreview.defaultTools,
  //     ],
  //     builder: (context) => DigiDastavejApp(),
  //   ),
  // );
  runApp(DigiDastavejApp());
}

class DigiDastavejApp extends StatelessWidget {
  DigiDastavejApp({super.key});

  final DocumentController controller = Get.put(DocumentController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GetMaterialApp(
        title: 'Digidastavej - your own Digital Document Manager!',
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.home,
        getPages: AppPages.pages,
        darkTheme: DarkTheme.theme,
        theme: LightTheme.theme,
        themeMode: controller.themeMode.value,
      );
    });
  }
}
