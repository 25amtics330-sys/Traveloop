import 'package:flutter/material.dart';
import 'Pages/Authorization/auth_page.dart';
import 'Pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Traveloop',
      debugShowCheckedModeBanner: false,
      routes: {
        '/auth': (context) => const AuthPage(),
        '/login': (context) => const AuthPage(),
        '/signup': (context) => const AuthPage(),
        '/home': (context) => const HomePage(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFD98B2C)),
        fontFamily: 'Segoe UI',
      ),
      home: const AuthPage(),
    );
  }
}

class AppColors {
  static const Color primary = Color(0xFF1A1A2E);
  static const Color accent = Color.fromARGB(255, 217, 139, 44);
  static const Color accentLight = Color(0xFFFFF0D9);
  static const Color teal = Color(0xFF2EC4B6);
  static const Color tealLight = Color(0xFFE0F7F5);
  static const Color bg = Color(0xFFF8F7F4);
  static const Color card = Color(0xFFFFFFFF);
  static const Color text = Color(0xFF1A1A2E);
  static const Color textLight = Color(0xFF7B7B9A);
  static const Color border = Color(0xFFEAEAF0);
  static const Color danger = Color(0xFFE05C5C);
}
