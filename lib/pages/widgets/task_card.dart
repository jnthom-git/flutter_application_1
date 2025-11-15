// lib/widgets/task_card.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../models/pet.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final Pet pet;
  final VoidCallback onComplete;

  const TaskCard({
    Key? key,
    required this.task,
    required this.pet,
    required this.onComplete,
  }) : super(key: key);

  Color _getIndicatorColor() {
    switch (task.colorIndicator) {
      case 'yellow':
        return const Color(0xFFFFC107);
      case 'green':
        return const Color(0xFF4CAF50);
      case 'blue':
        return const Color(0xFF2196F3);
      default:
        return Colors.grey;
    }
  }

  IconData _getTaskIcon() {
    switch (task.type) {
      case TaskType.walk:
        return Icons.directions_walk;
      case TaskType.playTime:
        return Icons.sports_baseball;
      case TaskType.feed:
        return Icons.restaurant;
      case TaskType.bath:
        return Icons.bathtub;
      case TaskType.nails:
        return Icons.content_cut;
      case TaskType.brushTeeth:
        return Icons.cleaning_services;
      case TaskType.hair:
        return Icons.cut;
      case TaskType.medication:
        return Icons.medication;
      case TaskType.appointment:
        return Icons.calendar_today;
      default:
        return Icons.task;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        onComplete();
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.check,
          color: Colors.white,
          size: 30,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Task Icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getTaskIcon(),
                size: 24,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 12),
            // Task Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat('h:mm a').format(task.scheduledTime),
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            // Color Indicator
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: _getIndicatorColor(),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}