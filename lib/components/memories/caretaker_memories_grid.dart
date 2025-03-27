import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class MemoriesGrid extends StatelessWidget {
  const MemoriesGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Memory Album',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryTextColor,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.add_photo_alternate),
                label: Text('Add New'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 8, // Sample count
              itemBuilder: (context, index) {
                // Sample placeholders for memories
                return _buildMemoryItem(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemoryItem(int index) {
    final List<String> titles = [
      'Family Picnic',
      'Birthday Party',
      'Holiday Trip',
      'Graduation Day',
      'Wedding Anniversary',
      'Family Reunion',
      'Childhood Home',
      'First Car',
    ];

    final List<Color> colors = [
      Colors.blue.shade200,
      Colors.green.shade200,
      Colors.purple.shade200,
      Colors.orange.shade200,
      Colors.pink.shade200,
      Colors.teal.shade200,
      Colors.amber.shade200,
      Colors.indigo.shade200,
    ];

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Placeholder for image - in a real app, you would load actual images
          Container(
            color: colors[index % colors.length],
            child: Icon(
              Icons.photo,
              size: 40,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          // Memory title overlay at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black.withOpacity(0.5),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Text(
                titles[index % titles.length],
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
