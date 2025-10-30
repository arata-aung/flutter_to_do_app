import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/data/auth_service.dart';
import 'package:to_do_app/pages/home_page.dart';
import 'package:to_do_app/pages/login_page.dart';

void main() async {
  // Initialize Hive
  await Hive.initFlutter();

  // Open the box for storing todos and auth data
  await Hive.openBox('mybox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final isLoggedIn = authService.isLoggedIn();

    return MaterialApp(
      home: isLoggedIn ? const HomePage() : const LoginPage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
    );
  }
}
