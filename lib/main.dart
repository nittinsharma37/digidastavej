import 'package:digidastavej/app/utils/dark_theme.dart';
import 'package:digidastavej/app/utils/light_theme.dart';

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

  runApp(const DigiDastavejApp());
}

class DigiDastavejApp extends StatelessWidget {
  const DigiDastavejApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Digidastavej',
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.home,
      getPages: AppPages.pages,
      darkTheme: DarkTheme.theme,
      theme: LightTheme.theme,
      themeMode: ThemeMode.system,
    );
  }
}
