import 'package:flutter/material.dart';
import '../components/ai_assistant.dart';
import '../components/map_view.dart';
import '../components/facial_recognition.dart';
import '../components/daily_routine/daily_routine.dart';
import '../components/memories/memories_grid.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final String role;
  final String username;

  const HomeScreen({Key? key, required this.role, required this.username})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _showNotification = false;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
    
    // Show medication reminder notification after a delay
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        _showNotification = true;
      });
      // Auto hide after 10 seconds
      Future.delayed(Duration(seconds: 10), () {
        if (mounted) {
          setState(() {
            _showNotification = false;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _tabController.animateTo(index);
    });
  }

  Widget _getSelectedView() {
    switch (_selectedIndex) {
      case 0:
        return const AIAssistant();
      case 1:
        return const MapView();
      case 2:
        return const FacialRecognition();
      case 3:
        return const DailyRoutine();
      case 4:
        return const MemoriesGrid();
      default:
        return const AIAssistant();
    }
  }

  void _showEmergencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppTheme.errorColor),
            SizedBox(width: 8),
            Text("Emergency Assistance"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Do you need emergency assistance?"),
            const SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      "https://randomuser.me/api/portraits/women/43.jpg"
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Call Caretaker", 
                          style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                        Text("${widget.username}'s primary contact")
                      ],
                    ),
                  ),
                  Icon(Icons.call, color: AppTheme.primaryColor),
                ],
              ),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[600],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Calling caretaker..."),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.all(16),
                ),
              );
            },
            icon: const Icon(Icons.call),
            label: const Text("Call Now"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showProfileOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppTheme.primaryColor,
                  child: Text(
                    widget.username.isNotEmpty ? widget.username[0].toUpperCase() : "U",
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.username,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Role: ${widget.role}",
                      style: TextStyle(color: AppTheme.secondaryTextColor),
                    ),
                  ],
                ),
              ],
            ),
            Divider(height: 32),
            ListTile(
              leading: Icon(Icons.settings, color: AppTheme.primaryColor),
              title: Text("Settings"),
              onTap: () {
                Navigator.pop(context);
                // Navigate to settings
              },
            ),
            ListTile(
              leading: Icon(Icons.help_outline, color: AppTheme.primaryColor),
              title: Text("Help & Support"),
              onTap: () {
                Navigator.pop(context);
                // Navigate to help
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: AppTheme.errorColor),
              title: Text("Logout", style: TextStyle(color: AppTheme.errorColor)),
              onTap: () {
                Navigator.pop(context); // Close the bottom sheet
                // Return to login screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final String todayDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    
    return Theme(
      data: AppTheme.getTheme(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Memory Assistant"),
              Text(
                todayDate,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
          elevation: 2,
          actions: [
            Container(
              margin: EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                children: [
                  Icon(Icons.person, size: 18, color: Colors.white),
                  SizedBox(width: 4),
                  Text(
                    widget.role,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _showProfileOptions,
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    widget.username.isNotEmpty 
                      ? widget.username[0].toUpperCase() 
                      : "U",
                    style: TextStyle(color: AppTheme.primaryColor),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            // Main content
            _getSelectedView(),
            
            // Notification banner
            if (_showNotification)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Material(
                  elevation: 4,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    color: Colors.amber.shade100,
                    child: Row(
                      children: [
                        Icon(Icons.medication, color: Colors.amber.shade800),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Medication Reminder",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber.shade800,
                                ),
                              ),
                              Text("It's time to take your afternoon medication"),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.amber.shade800),
                          onPressed: () {
                            setState(() {
                              _showNotification = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: _showEmergencyDialog,
        //   backgroundColor: AppTheme.errorColor,
        //   child: const Icon(Icons.call),
        //   tooltip: 'Emergency Call',
        // ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.smart_toy),
              label: 'Assistant',
              activeIcon: Icon(Icons.smart_toy, size: 28),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Map',
              activeIcon: Icon(Icons.map, size: 28),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.face), 
              label: 'Face ID',
              activeIcon: Icon(Icons.face, size: 28),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Routine',
              activeIcon: Icon(Icons.calendar_today, size: 28),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.photo_album),
              label: 'Memories',
              activeIcon: Icon(Icons.photo_album, size: 28),
            ),
          ],
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}