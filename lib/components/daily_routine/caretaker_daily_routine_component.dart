import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class DailyRoutineComponent extends StatelessWidget {
  const DailyRoutineComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily Routine',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryTextColor,
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                _buildRoutineItem(
                  '8:00 AM',
                  'Morning Medication',
                  Icons.medication,
                ),
                _buildRoutineItem('9:30 AM', 'Breakfast', Icons.free_breakfast),
                _buildRoutineItem(
                  '11:00 AM',
                  'Physical Therapy',
                  Icons.fitness_center,
                ),
                _buildRoutineItem('1:00 PM', 'Lunch', Icons.lunch_dining),
                _buildRoutineItem(
                  '3:00 PM',
                  'Memory Exercises',
                  Icons.psychology,
                ),
                _buildRoutineItem(
                  '5:00 PM',
                  'Evening Medication',
                  Icons.medical_services,
                ),
                _buildRoutineItem('6:30 PM', 'Dinner', Icons.dinner_dining),
                _buildRoutineItem(
                  '8:00 PM',
                  'Relaxation Time',
                  Icons.nightlife,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutineItem(String time, String activity, IconData icon) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppTheme.primaryColor),
        ),
        title: Text(activity, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(time),
        trailing: Icon(Icons.chevron_right),
      ),
    );
  }
}
