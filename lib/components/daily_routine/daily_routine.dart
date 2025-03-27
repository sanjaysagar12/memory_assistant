import 'package:flutter/material.dart';
import 'routine_item.dart';

class DailyRoutine extends StatelessWidget {
  const DailyRoutine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          "Daily Routine",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        RoutineItem(time: "8:00 AM", activity: "Take morning medication", completed: true),
        RoutineItem(time: "9:00 AM", activity: "Breakfast", completed: true),
        RoutineItem(time: "10:00 AM", activity: "Memory exercises", completed: false),
        RoutineItem(time: "12:00 PM", activity: "Lunch", completed: false),
        RoutineItem(time: "2:00 PM", activity: "Doctor's appointment", completed: false),
        RoutineItem(time: "4:00 PM", activity: "Take afternoon medication", completed: false),
        RoutineItem(time: "6:00 PM", activity: "Dinner", completed: false),
        RoutineItem(time: "9:00 PM", activity: "Take evening medication", completed: false),
      ],
    );
  }
}