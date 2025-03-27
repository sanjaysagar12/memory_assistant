import 'package:flutter/material.dart';
import 'memory_card.dart';

class MemoriesGrid extends StatelessWidget {
  const MemoriesGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(16),
      children: [
        MemoryCard(title: "Family", icon: Icons.family_restroom),
        MemoryCard(title: "Friends", icon: Icons.people),
        MemoryCard(title: "Places", icon: Icons.place),
        MemoryCard(title: "Events", icon: Icons.event),
        MemoryCard(title: "Medications", icon: Icons.medication),
        MemoryCard(title: "Important Info", icon: Icons.info),
      ],
    );
  }
}
