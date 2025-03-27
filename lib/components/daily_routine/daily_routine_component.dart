import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class DailyRoutineComponent extends StatefulWidget {
  const DailyRoutineComponent({Key? key}) : super(key: key);

  @override
  _DailyRoutineComponentState createState() => _DailyRoutineComponentState();
}

class _DailyRoutineComponentState extends State<DailyRoutineComponent> {
  // Sample routine data
  final List<Map<String, dynamic>> _routines = [
    {
      'time': '08:00',
      'activity': 'Morning Medication',
      'completed': false,
      'important': true,
    },
    {
      'time': '09:00',
      'activity': 'Breakfast',
      'completed': false,
      'important': true,
    },
    {
      'time': '10:30',
      'activity': 'Memory Exercises',
      'completed': false,
      'important': false,
    },
    {
      'time': '12:30',
      'activity': 'Lunch',
      'completed': false,
      'important': true,
    },
    {
      'time': '14:00',
      'activity': 'Walk in the Garden',
      'completed': false,
      'important': false,
    },
    {
      'time': '16:00',
      'activity': 'Afternoon Medication',
      'completed': false,
      'important': true,
    },
    {
      'time': '18:00',
      'activity': 'Dinner',
      'completed': false,
      'important': true,
    },
    {
      'time': '18:30',
      'activity': 'Call Family',
      'completed': false,
      'important': false,
    },
    {
      'time': '21:30',
      'activity': 'Evening Medication',
      'completed': false,
      'important': true,
    },
  ];

  // Current time exactly as provided
  String _currentTime = "2025-03-27 18:59:34";
  late DateTime _currentDateTime;
  String _username = "sanjaysagar12";

  @override
  void initState() {
    super.initState();
    _updateCurrentTime();
  }

  // Update current time from the provided time string
  void _updateCurrentTime() {
    try {
      _currentDateTime = DateTime.parse(_currentTime);
    } catch (e) {
      _currentDateTime = DateTime.now(); // Fallback to system time
    }
  }

  // Toggle completion status of a routine
  void _toggleRoutineCompletion(int index) {
    setState(() {
      _routines[index]['completed'] = !_routines[index]['completed'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with current time
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Daily Schedule',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  Chip(
                    label: Text(
                      _currentDateTime.toLocal().toString().split(' ')[0],
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: AppTheme.primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, color: AppTheme.primaryColor),
                  SizedBox(width: 8),
                  Text(
                    'Current Time: ${_currentDateTime.hour.toString().padLeft(2, '0')}:${_currentDateTime.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Icon(Icons.person, color: AppTheme.primaryColor, size: 16),
                  SizedBox(width: 4),
                  Text(
                    _username,
                    style: TextStyle(
                      color: AppTheme.secondaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              LinearProgressIndicator(
                value: (_currentDateTime.hour * 60 + _currentDateTime.minute) / (24 * 60),
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Morning',
                    style: TextStyle(fontSize: 12, color: AppTheme.secondaryTextColor),
                  ),
                  Text(
                    'Afternoon',
                    style: TextStyle(fontSize: 12, color: AppTheme.secondaryTextColor),
                  ),
                  Text(
                    'Evening',
                    style: TextStyle(fontSize: 12, color: AppTheme.secondaryTextColor),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Stats summary (completed vs total)
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.primaryColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${_routines.where((r) => r['completed']).length}/${_routines.length}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryTextColor,
                        ),
                      ),
                      Text(
                        'Completed',
                        style: TextStyle(fontSize: 12, color: AppTheme.secondaryTextColor),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.amber.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${_routines.where((r) => !r['completed'] && _isRoutinePastDue(r)).length}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber[800],
                        ),
                      ),
                      Text(
                        'Overdue',
                        style: TextStyle(fontSize: 12, color: AppTheme.secondaryTextColor),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.errorColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.errorColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${_routines.where((r) => r['important'] && !r['completed']).length}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.errorColor,
                        ),
                      ),
                      Text(
                        'Important',
                        style: TextStyle(fontSize: 12, color: AppTheme.secondaryTextColor),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Routine List
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.only(left: 16, right: 16),
            itemCount: _routines.length,
            separatorBuilder: (context, index) => SizedBox(height: 8),
            itemBuilder: (context, index) {
              final routine = _routines[index];

              // Check if routine is past due or current
              bool isPastDue = _isRoutinePastDue(routine);
              bool isCurrent = _isRoutineCurrent(routine);

              return Card(
                elevation: isCurrent ? 4 : 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isCurrent
                        ? AppTheme.accentColor
                        : (isPastDue && !routine['completed'])
                            ? Colors.amber[700]!
                            : Colors.transparent,
                    width: isCurrent || (isPastDue && !routine['completed']) ? 2 : 0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: routine['important']
                            ? AppTheme.errorColor.withOpacity(0.1)
                            : AppTheme.primaryColor.withOpacity(0.1),
                      ),
                      child: Center(
                        child: Text(
                          routine['time'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: routine['important']
                                ? AppTheme.errorColor
                                : AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      routine['activity'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: routine['important'] ? FontWeight.bold : FontWeight.normal,
                        decoration: routine['completed'] ? TextDecoration.lineThrough : null,
                        color: routine['completed']
                            ? AppTheme.secondaryTextColor
                            : AppTheme.primaryTextColor,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        if (routine['important'])
                          Row(
                            children: [
                              Icon(
                                Icons.priority_high,
                                size: 14,
                                color: AppTheme.errorColor,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Important',
                                style: TextStyle(
                                  color: AppTheme.errorColor,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(width: 8),
                            ],
                          ),
                        if (isPastDue && !routine['completed'])
                          Row(
                            children: [
                              Icon(
                                Icons.watch_later,
                                size: 14,
                                color: Colors.amber[700],
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Overdue',
                                style: TextStyle(
                                  color: Colors.amber[700],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    trailing: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: routine['completed']
                            ? Colors.green.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                      ),
                      child: IconButton(
                        icon: Icon(
                          routine['completed']
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: routine['completed'] ? Colors.green : Colors.grey,
                        ),
                        onPressed: () => _toggleRoutineCompletion(index),
                      ),
                    ),
                    onTap: () => _toggleRoutineCompletion(index),
                  ),
                ),
              );
            },
          ),
        ),

        // Add new routine button
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Add routine feature coming soon'),
                        backgroundColor: AppTheme.primaryColor,
                      ),
                    );
                  },
                  icon: Icon(Icons.add),
                  label: Text('Add Routine'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper method to check if a routine is past due
  bool _isRoutinePastDue(Map<String, dynamic> routine) {
    // Parse routine time
    final timeParts = routine['time'].split(':');
    final routineHour = int.parse(timeParts[0]);
    final routineMinute = int.parse(timeParts[1]);

    return (routineHour < _currentDateTime.hour) ||
        (routineHour == _currentDateTime.hour &&
            routineMinute <= _currentDateTime.minute);
  }

  // Helper method to check if a routine is current (within 15 min window)
  bool _isRoutineCurrent(Map<String, dynamic> routine) {
    // Parse routine time
    final timeParts = routine['time'].split(':');
    final routineHour = int.parse(timeParts[0]);
    final routineMinute = int.parse(timeParts[1]);

    // Convert both times to minutes for easier comparison
    final currentTotalMinutes =
        _currentDateTime.hour * 60 + _currentDateTime.minute;
    final routineTotalMinutes = routineHour * 60 + routineMinute;

    // Current if within 15 minutes window (either way)
    return (currentTotalMinutes - routineTotalMinutes).abs() <= 15;
  }
}