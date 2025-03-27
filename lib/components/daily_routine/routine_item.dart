import 'package:flutter/material.dart';

class RoutineItem extends StatelessWidget {
  final String time;
  final String activity;
  final bool completed;
  final VoidCallback? onTap;

  const RoutineItem({
    Key? key,
    required this.time,
    required this.activity,
    required this.completed,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        onTap: onTap,
      ),
    );
  }
}