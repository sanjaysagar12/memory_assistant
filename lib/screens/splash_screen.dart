import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'caretaker_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Add a small delay to show splash screen
    await Future.delayed(Duration(seconds: 2));
    
    final userData = await AuthService.verifyToken();
    
    if (userData != null) {
      final userRole = userData['role'];
      final userEmail = userData['email'];
      
      if (userRole == 'PATIENT') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              role: 'Patient',
              username: userEmail,
            ),
          ),
        );
      } else if (userRole == 'CARETAKER') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => CaretakerScreen(
              username: userEmail,
            ),
          ),
        );
      } else {
        // Unknown role, go to login
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    } else {
      // No valid token, go to login
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.psychology_alt,
              size: 100,
              color: AppTheme.primaryColor,
            ),
            SizedBox(height: 24),
            Text(
              'Memory Assistant',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            SizedBox(height: 48),
            CircularProgressIndicator(
              color: AppTheme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}