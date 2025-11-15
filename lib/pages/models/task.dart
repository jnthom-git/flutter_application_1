// lib/models/task.dart

enum TaskType {
  walk,
  hair,
  feed,
  nails,
  playTime,
  brushTeeth,
  bath,
  medication,
  appointment,
  custom,
}

class Task {
  final String id;
  final String petId; // Which pet this task belongs to
  final String petName;
  final TaskType type;
  final String title;
  final DateTime scheduledTime;
  final bool isCompleted;
  final String? notes;
  final String? customIconPath; // For custom tasks

  Task({
    required this.id,
    required this.petId,
    required this.petName,
    required this.type,
    required this.title,
    required this.scheduledTime,
    this.isCompleted = false,
    this.notes,
    this.customIconPath,
  });

  // Get icon name based on task type
  String get iconName {
    switch (type) {
      case TaskType.walk:
        return 'walk';
      case TaskType.hair:
        return 'hair';
      case TaskType.feed:
        return 'feed';
      case TaskType.nails:
        return 'nails';
      case TaskType.playTime:
        return 'play_time';
      case TaskType.brushTeeth:
        return 'brush_teeth';
      case TaskType.bath:
        return 'bath';
      case TaskType.medication:
        return 'medication';
      case TaskType.appointment:
        return 'appointment';
      case TaskType.custom:
        return customIconPath ?? 'custom';
    }
  }

  // Get color indicator based on task type
  String get colorIndicator {
    switch (type) {
      case TaskType.playTime:
        return 'yellow';
      case TaskType.feed:
        return 'green';
      case TaskType.bath:
        return 'yellow';
      default:
        return 'blue';
    }
  }

  // Create a copy with modified fields
  Task copyWith({
    String? id,
    String? petId,
    String? petName,
    TaskType? type,
    String? title,
    DateTime? scheduledTime,
    bool? isCompleted,
    String? notes,
    String? customIconPath,
  }) {
    return Task(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      petName: petName ?? this.petName,
      type: type ?? this.type,
      title: title ?? this.title,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      isCompleted: isCompleted ?? this.isCompleted,
      notes: notes ?? this.notes,
      customIconPath: customIconPath ?? this.customIconPath,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'petId': petId,
      'petName': petName,
      'type': type.toString(),
      'title': title,
      'scheduledTime': scheduledTime.toIso8601String(),
      'isCompleted': isCompleted,
      'notes': notes,
      'customIconPath': customIconPath,
    };
  }

  // Create from JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      petId: json['petId'],
      petName: json['petName'],
      type: TaskType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => TaskType.custom,
      ),
      title: json['title'],
      scheduledTime: DateTime.parse(json['scheduledTime']),
      isCompleted: json['isCompleted'] ?? false,
      notes: json['notes'],
      customIconPath: json['customIconPath'],
    );
  }
}