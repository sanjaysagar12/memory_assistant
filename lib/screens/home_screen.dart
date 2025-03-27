import 'package:flutter/material.dart';

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

  Widget _buildAIAssistant() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.smart_toy, size: 80, color: Colors.teal),
          const SizedBox(height: 20),
          const Text(
            "AI Assistant",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Column(
              children: [
                Text(
                  "How can I help you today?",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Ask me anything...",
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.send),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.map, size: 80, color: Colors.teal),
          const SizedBox(height: 20),
          const Text(
            "Map Location",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Container(
            height: 300,
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Center(
              child: Text(
                "Map View will appear here",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.my_location),
            label: const Text("Find My Location"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFacialRecognition() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.face, size: 80, color: Colors.teal),
          const SizedBox(height: 20),
          const Text(
            "Face Recognition",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Container(
            height: 250,
            width: 250,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.camera_alt, size: 50, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.camera),
            label: const Text("Identify Person"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyRoutine() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          "Daily Routine",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        _buildRoutineItem("8:00 AM", "Take morning medication", true),
        _buildRoutineItem("9:00 AM", "Breakfast", true),
        _buildRoutineItem("10:00 AM", "Memory exercises", false),
        _buildRoutineItem("12:00 PM", "Lunch", false),
        _buildRoutineItem("2:00 PM", "Doctor's appointment", false),
        _buildRoutineItem("4:00 PM", "Take afternoon medication", false),
        _buildRoutineItem("6:00 PM", "Dinner", false),
        _buildRoutineItem("9:00 PM", "Take evening medication", false),
      ],
    );
  }

  Widget _buildRoutineItem(String time, String activity, bool completed) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.teal,
          child: Text(
            time.substring(0, 2),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(activity),
        subtitle: Text(time),
        trailing: Icon(
          completed ? Icons.check_circle : Icons.circle_outlined,
          color: completed ? Colors.green : Colors.grey,
        ),
        onTap: () {},
      ),
    );
  }

  Widget _buildMemories() {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(16),
      children: [
        _buildMemoryCard("Family", Icons.family_restroom),
        _buildMemoryCard("Friends", Icons.people),
        _buildMemoryCard("Places", Icons.place),
        _buildMemoryCard("Events", Icons.event),
        _buildMemoryCard("Medications", Icons.medication),
        _buildMemoryCard("Important Info", Icons.info),
      ],
    );
  }

  Widget _buildMemoryCard(String title, IconData icon) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.teal),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getSelectedView() {
    switch (_selectedIndex) {
      case 0:
        return _buildAIAssistant();
      case 1:
        return _buildMapView();
      case 2:
        return _buildFacialRecognition();
      case 3:
        return _buildDailyRoutine();
      case 4:
        return _buildMemories();
      default:
        return _buildAIAssistant();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Memory Assistant"),
        backgroundColor: Colors.teal,
        actions: [
          Chip(
            label: Text(
              "Role: ${widget.role}",
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.teal.shade700,
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: _getSelectedView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text("Emergency Call"),
                  content: const Text("Do you want to call your caretaker?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        // Here you would implement the actual call functionality
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Calling caretaker..."),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      child: const Text("Call"),
                    ),
                  ],
                ),
          );
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.call),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy),
            label: 'Assistant',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.face), label: 'Face ID'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Routine',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_album),
            label: 'Memories',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
