import 'package:daily_planner/const/strings.dart';
import 'package:daily_planner/controller/settings_controller.dart';
import 'package:daily_planner/login_screen.dart/wellcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    ChangeNotifierProvider(
      create: (_) => SettingsController(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsController>(
      // Lắng nghe SettingsController
      builder: (context, settingsController, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Daily Planner',
          theme: ThemeData(
            primaryColor: settingsController.primaryColor, // Sử dụng màu chính
            textTheme: TextTheme(
              bodyLarge: TextStyle(fontFamily: settingsController.fontFamily),
              bodyMedium: TextStyle(fontFamily: settingsController.fontFamily),
              bodySmall: TextStyle(fontFamily: settingsController.fontFamily),
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            primaryColor: settingsController.primaryColor, // Sử dụng màu chính
            textTheme: TextTheme(
              bodyLarge: TextStyle(fontFamily: settingsController.fontFamily),
              bodyMedium: TextStyle(fontFamily: settingsController.fontFamily),
              bodySmall: TextStyle(fontFamily: settingsController.fontFamily),
            ),
          ),
          themeMode:
              settingsController.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: WellcomeScreen(),
        );
      },
    );
  }
}
