import 'package:flutter/material.dart';
import 'memory_card.dart';
import 'memory_detail_screen.dart';
import '../../theme/app_theme.dart';

class MemoriesGrid extends StatefulWidget {
  const MemoriesGrid({Key? key}) : super(key: key);

  @override
  _MemoriesGridState createState() => _MemoriesGridState();
}

class _MemoriesGridState extends State<MemoriesGrid> {
  // Memory categories
  final List<String> _categories = [
    'All',
    'Family',
    'Friends',
    'Places',
    'Events',
    'Hobbies',
  ];
  
  String _selectedCategory = 'All';
  
  // Sample memory data
  final List<Map<String, dynamic>> _memories = [
    {
      'id': '1',
      'title': 'Family Reunion',
      'category': 'Family',
      'imageUrl': 'https://images.unsplash.com/photo-1609220136736-443140cffec6?w=500',
      'description': 'Family reunion at the park with grandchildren and great-grandchildren.',
      'timestamp': '2025-02-15 14:30:00',
      'people': ['Sarah', 'Michael', 'Emma', 'David'],
      'location': 'Central Park',
    },
    {
      'id': '2',
      'title': 'Birthday Celebration',
      'category': 'Events',
      'imageUrl': 'https://images.unsplash.com/photo-1558636508-e0db3814bd1d?w=500',
      'description': 'My 75th birthday celebration with chocolate cake and all my dear friends.',
      'timestamp': '2025-01-20 18:45:00',
      'people': ['James', 'Patricia', 'Robert', 'Linda'],
      'location': 'Home',
    },
    {
      'id': '3',
      'title': 'Beach Vacation',
      'category': 'Places',
      'imageUrl': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=500',
      'description': 'Vacation at the beach, swimming in the ocean and collecting shells.',
      'timestamp': '2024-12-05 10:15:00',
      'people': ['Linda', 'Robert'],
      'location': 'Myrtle Beach',
    },
    {
      'id': '4',
      'title': 'Weekly Card Game',
      'category': 'Friends',
      'imageUrl': 'https://images.unsplash.com/photo-1622798023168-46abc286c25d?w=500',
      'description': 'Playing cards with my friends at the community center every Wednesday.',
      'timestamp': '2025-03-22 16:00:00',
      'people': ['William', 'Barbara', 'Charles', 'Margaret'],
      'location': 'Community Center',
    },
    {
      'id': '5',
      'title': 'Gardening Day',
      'category': 'Hobbies',
      'imageUrl': 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=500',
      'description': 'Planting new flowers and vegetables in my backyard garden.',
      'timestamp': '2025-03-15 09:20:00',
      'people': [],
      'location': 'Home Garden',
    },
    {
      'id': '6',
      'title': 'Doctor Visit',
      'category': 'Health',
      'imageUrl': 'https://images.unsplash.com/photo-1579684385127-1ef15d508118?w=500',
      'description': 'Regular checkup with Dr. Johnson, blood pressure was normal.',
      'timestamp': '2025-03-10 11:30:00',
      'people': ['Dr. Johnson'],
      'location': 'Medical Center',
    },
    {
      'id': '7',
      'title': 'Grandchildren Visit',
      'category': 'Family',
      'imageUrl': 'https://images.unsplash.com/photo-1542037104857-ffbb0b9155fb?w=500',
      'description': 'Emma and David came over to help with technology and stayed for dinner.',
      'timestamp': '2025-03-05 17:00:00',
      'people': ['Emma', 'David'],
      'location': 'Home',
    },
    {
      'id': '8',
      'title': 'Cooking Class',
      'category': 'Hobbies',
      'imageUrl': 'https://images.unsplash.com/photo-1507048331197-7d4c42928cc2?w=500',
      'description': 'Learning to make pasta from scratch with friends at the community kitchen.',
      'timestamp': '2025-02-28 13:15:00',
      'people': ['Patricia', 'Linda', 'Margaret'],
      'location': 'Community Kitchen',
    },
  ];

  // Filtered memories based on selected category
  List<Map<String, dynamic>> get _filteredMemories {
    if (_selectedCategory == 'All') {
      return _memories;
    } else {
      return _memories.where((memory) => memory['category'] == _selectedCategory).toList();
    }
  }

  void _viewMemoryDetails(Map<String, dynamic> memory) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MemoryDetailScreen(memory: memory),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Category filter
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Memories',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = category == _selectedCategory;
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 12),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? AppTheme.primaryColor 
                              : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected 
                                ? AppTheme.primaryColor 
                                : Colors.grey.withOpacity(0.3),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          category,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        
        // Memories grid
        Expanded(
          child: _filteredMemories.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo_album_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No memories in this category',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _filteredMemories.length,
                  itemBuilder: (context, index) {
                    final memory = _filteredMemories[index];
                    return MemoryCard(
                      title: memory['title'],
                      imageUrl: memory['imageUrl'],
                      description: memory['description'],
                      timestamp: memory['timestamp'],
                      onTap: () => _viewMemoryDetails(memory),
                    );
                  },
                ),
        ),
      ],
    );
  }
}