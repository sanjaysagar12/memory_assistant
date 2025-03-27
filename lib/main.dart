import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Assistant',
      theme: AppTheme.getTheme(),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}