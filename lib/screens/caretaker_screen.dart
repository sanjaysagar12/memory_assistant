import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class CaretakerScreen extends StatelessWidget {
  final String username;

  const CaretakerScreen({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Caretaker Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              // Log out - return to login screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.health_and_safety,
              size: 100,
              color: AppTheme.primaryColor.withOpacity(0.5),
            ),
            SizedBox(height: 24),
            Text(
              'Welcome, $username',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryTextColor,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Caretaker Dashboard',
              style: TextStyle(
                fontSize: 18,
                color: AppTheme.secondaryTextColor,
              ),
            ),
            SizedBox(height: 40),
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Text(
                    'This page is currently under development',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  Divider(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.construction, color: Colors.orange),
                      SizedBox(width: 8),
                      Text(
                        'Coming Soon',
                        style: TextStyle(color: Colors.orange),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
