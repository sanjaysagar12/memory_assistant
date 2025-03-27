import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';
import '../components/daily_routine/caretaker_daily_routine_component.dart';
import '../components/memories/caretaker_memories_grid.dart';
import '../components/patient_location.dart';

class CaretakerScreen extends StatefulWidget {
  final String username;

  const CaretakerScreen({Key? key, required this.username}) : super(key: key);

  @override
  _CaretakerScreenState createState() => _CaretakerScreenState();
}

class _CaretakerScreenState extends State<CaretakerScreen> {
  int _selectedIndex = 0;
  
  // List of widgets to be shown when tabs are selected
  late List<Widget> _widgetOptions;
  
  @override
  void initState() {
    super.initState();
    _widgetOptions = [
      _buildDashboardContent(),
      const DailyRoutineComponent(),
      const MemoriesGrid(),
      const PatientLocationComponent(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  
  Widget _buildDashboardContent() {
    return Center(
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
            'Welcome, ${widget.username}',
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
    );
  }

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
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Daily Routine',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library),
            label: 'Memories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Find Patient',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppTheme.primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}