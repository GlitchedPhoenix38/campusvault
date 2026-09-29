import 'package:flutter/material.dart';
import 'package:campusvault/admin/screens/admin_login_screen.dart';
import 'package:campusvault/screens/home_screen.dart';
import 'package:campusvault/theme/app_theme.dart';

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
      themeMode: ThemeMode.system,
      // '/' is the student-facing entry point.
      // '/admin' is the admin login — accessible via a hidden route.
      routes: {
        '/': (_) => const HomeScreen(),
        '/admin': (_) => const AdminLoginScreen(),
      },
    );
  }
}
