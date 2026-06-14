import 'package:flutter/material.dart';
import 'package:campusvault/theme/app_theme.dart';
import 'package:campusvault/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusVault',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Dynamically responds to system light/dark settings
      home: const HomeScreen(),
    );
  }
}
