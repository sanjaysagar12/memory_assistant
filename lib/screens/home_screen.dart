import 'package:flutter/material.dart';
import '../components/ai_assistant.dart';
import '../components/map_view.dart';
import '../components/facial_recognition.dart';
import '../components/daily_routine/daily_routine.dart';
import '../components/memories/memories_grid.dart';

class HomeScreen extends StatefulWidget {
  final String role;
  final String username;

  const HomeScreen({Key? key, required this.role, required this.username})
    : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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
      builder:
          (context) => AlertDialog(
            title: const Text("Emergency Call"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Do you need emergency assistance?"),
                const SizedBox(height: 16),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        "https://randomuser.me/api/portraits/women/43.jpg",
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Call Caretaker",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("${widget.username}'s primary contact"),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
                style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
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
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
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
        title: const Text("Memory Assistant"),
        backgroundColor: Colors.teal,
        elevation: 2,
        actions: [
          Chip(
            label: Text(
              "Role: ${widget.role}",
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.teal.shade700,
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: Colors.teal.shade300,
            child: Text(
              widget.username.isNotEmpty
                  ? widget.username[0].toUpperCase()
                  : "U",
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: _getSelectedView(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showEmergencyDialog,
        backgroundColor: Colors.red,
        child: const Icon(Icons.call),
        tooltip: 'Emergency Call',
      ),
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
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }
}
