class Memory {
  final String id;
  final String title;
  final String description;
  final String imagePath;
  final DateTime timestamp;
  final String category;

  Memory({
    required this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.timestamp,
    required this.category,
  });

  // Sample data generator
  static List<Memory> getSampleMemories() {
    return [
      Memory(
        id: '1',
        title: 'Family Reunion',
        description: 'Annual family gathering at Lake House with cousins, aunts and uncles.',
        imagePath: 'https://images.unsplash.com/photo-1609220136736-443140cffec6?w=500&auto=format&fit=crop',
        timestamp: DateTime.now().subtract(const Duration(days: 30)),
        category: 'Family',
      ),
      Memory(
        id: '2',
        title: 'Meeting Sarah',
        description: 'Coffee with Sarah at Central Perk. She\'s your neighbor from apartment 302.',
        imagePath: 'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=500&auto=format&fit=crop',
        timestamp: DateTime.now().subtract(const Duration(days: 14)),
        category: 'Friends',
      ),
      Memory(
        id: '3',
        title: 'Vacation in Italy',
        description: 'Trip to Rome and Venice with Susan. Visited the Colosseum and took a gondola ride.',
        imagePath: 'https://images.unsplash.com/photo-1516483638261-f4dbaf036963?w=500&auto=format&fit=crop',
        timestamp: DateTime.now().subtract(const Duration(days: 180)),
        category: 'Places',
      ),
      Memory(
        id: '4',
        title: 'Birthday Party',
        description: 'Your 60th birthday celebration with friends and family at home.',
        imagePath: 'https://images.unsplash.com/photo-1464349153735-7db50ed83451?w=500&auto=format&fit=crop',
        timestamp: DateTime.now().subtract(const Duration(days: 60)),
        category: 'Events',
      ),
      Memory(
        id: '5',
        title: 'Blood Pressure Medication',
        description: 'Take one pill every morning with breakfast. Dr. Johnson prescribed this in January.',
        imagePath: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=500&auto=format&fit=crop',
        timestamp: DateTime.now().subtract(const Duration(days: 120)),
        category: 'Medications',
      ),
      Memory(
        id: '6',
        title: 'Emergency Contacts',
        description: 'Susan (daughter): 555-123-4567\nDr. Johnson: 555-987-6543',
        imagePath: 'https://images.unsplash.com/photo-1598257006626-48b0c252070d?w=500&auto=format&fit=crop',
        timestamp: DateTime.now().subtract(const Duration(days: 7)),
        category: 'Important Info',
      ),
      Memory(
        id: '7',
        title: 'Wedding Anniversary',
        description: 'You and Martha celebrated your 40th wedding anniversary at The Grand Restaurant.',
        imagePath: 'https://images.unsplash.com/photo-1537633552985-df8429e8048b?w=500&auto=format&fit=crop',
        timestamp: DateTime.now().subtract(const Duration(days: 90)),
        category: 'Events',
      ),
      Memory(
        id: '8',
        title: 'Grandchildren Visit',
        description: 'Emma and Jacob visited for the weekend. You took them to the zoo.',
        imagePath: 'https://images.unsplash.com/photo-1444565696380-0e9e850faafe?w=500&auto=format&fit=crop',
        timestamp: DateTime.now().subtract(const Duration(days: 21)),
        category: 'Family',
      ),
    ];
  }
}