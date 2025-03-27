import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class MemoryDetailScreen extends StatelessWidget {
  final Map<String, dynamic> memory;

  const MemoryDetailScreen({Key? key, required this.memory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memory Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Edit functionality would go here
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Edit feature coming soon')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Memory image
            Stack(
              children: [
                Image.network(
                  memory['imageUrl'],
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 250,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.grey[500],
                      ),
                    );
                  },
                ),
                // Category badge
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      memory['category'],
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Memory title and date
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    memory['title'],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        memory['timestamp'],
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),

                  Divider(height: 32),

                  // Description
                  Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(memory['description'], style: TextStyle(fontSize: 16)),

                  SizedBox(height: 24),

                  // Location
                  Row(
                    children: [
                      Icon(Icons.location_on, color: AppTheme.primaryColor),
                      SizedBox(width: 8),
                      Text(memory['location'], style: TextStyle(fontSize: 16)),
                    ],
                  ),

                  SizedBox(height: 24),

                  // People involved
                  if ((memory['people'] as List).isNotEmpty) ...[
                    Text(
                      'People',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          (memory['people'] as List).map((person) {
                            return Chip(
                              avatar: CircleAvatar(
                                backgroundColor: AppTheme.primaryColor,
                                child: Text(
                                  person[0],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              label: Text(person),
                              backgroundColor: Colors.grey[100],
                            );
                          }).toList(),
                    ),
                  ],

                  SizedBox(height: 32),

                  // Related memories (placeholder)
                  Text(
                    'Related Memories',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  Container(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 160,
                          margin: EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[200],
                            image: DecorationImage(
                              image: NetworkImage(
                                'https://images.unsplash.com/photo-${1500000000 + index * 10000}?w=200',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.7),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            child: Text(
                              'Related Memory ${index + 1}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Share functionality
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Share feature coming soon')));
        },
        backgroundColor: AppTheme.primaryColor,
        child: Icon(Icons.share),
      ),
    );
  }
}
