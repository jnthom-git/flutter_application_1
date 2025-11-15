// lib/pages/pet_detail_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'models/pet.dart';
import 'models/task.dart';

class PetDetailPage extends StatefulWidget {
  final Pet pet;
  final List<Task> tasks;

  const PetDetailPage({
    Key? key,
    required this.pet,
    required this.tasks,
  }) : super(key: key);

  @override
  State<PetDetailPage> createState() => _PetDetailPageState();
}

class _PetDetailPageState extends State<PetDetailPage> {
  // Sample photos - in real app, these would be loaded from storage
  final List<String> _photos = [];

  // Get tasks for this pet only
  List<Task> get petTasks {
    return widget.tasks
        .where((task) => task.petId == widget.pet.id && !task.isCompleted)
        .toList();
  }

  // Get task count by type (for the grid badges)
  int getTaskCount(TaskType type) {
    return petTasks.where((task) => task.type == type).length;
  }

  ImageProvider? _getImageProvider() {
    if (widget.pet.imagePath == null) return null;
    
    // Check if it's an asset path or file path
    if (widget.pet.imagePath!.startsWith('assets/')) {
      return AssetImage(widget.pet.imagePath!);
    } else {
      return FileImage(File(widget.pet.imagePath!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pet Avatar and Name
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
                        image: widget.pet.imagePath != null
                            ? DecorationImage(
                                image: FileImage(File(widget.pet.imagePath!)),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: widget.pet.imagePath == null
                          ? Icon(
                              Icons.pets,
                              size: 50,
                              color: Colors.grey[600],
                            )
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.pet.name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () {
                        // Navigate to pet info edit page
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Edit pet info coming soon'),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Pet Information',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: Colors.grey[600],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Tasks Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tasks',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to add task
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Add task coming soon'),
                        ),
                      );
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Task Grid
              _buildTaskGrid(),
              const SizedBox(height: 32),

              // Photos Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Photos',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Add photo coming soon'),
                        ),
                      );
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Photos Grid
              _buildPhotosGrid(),
            ],
          ),
        ),
      ),
      // Bottom Navigation Bar (same as home)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavIcon(Icons.home_rounded, false),
            _buildNavIcon(Icons.edit_rounded, false),
            _buildNavIcon(Icons.favorite_rounded, false),
            _buildNavIcon(Icons.person_rounded, true),
          ],
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, bool isActive) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFFF6B6B) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: isActive ? Colors.white : Colors.grey,
        size: 24,
      ),
    );
  }

  Widget _buildTaskGrid() {
    final taskTypes = [
      {'type': TaskType.bath, 'icon': Icons.bathtub, 'label': 'Bath'},
      {'type': TaskType.hair, 'icon': Icons.cut, 'label': 'Hair'},
      {'type': TaskType.feed, 'icon': Icons.restaurant, 'label': 'Feed'},
      {'type': TaskType.nails, 'icon': Icons.content_cut, 'label': 'Nails'},
      {'type': TaskType.playTime, 'icon': Icons.sports_baseball, 'label': 'Play Time'},
      {'type': TaskType.brushTeeth, 'icon': Icons.cleaning_services, 'label': 'Brush Teeth'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: taskTypes.length,
      itemBuilder: (context, index) {
        final task = taskTypes[index];
        final taskType = task['type'] as TaskType;
        final count = getTaskCount(taskType);

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      task['icon'] as IconData,
                      size: 32,
                      color: Colors.black87,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      task['label'] as String,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Badge for task count
              if (count > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: _getBadgeColor(taskType),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      count.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Color _getBadgeColor(TaskType type) {
    switch (type) {
      case TaskType.feed:
        return const Color(0xFF4CAF50);
      case TaskType.playTime:
        return const Color(0xFFFFC107);
      case TaskType.bath:
        return const Color(0xFFFFC107);
      default:
        return const Color(0xFF2196F3);
    }
  }

  Widget _buildPhotosGrid() {
    if (_photos.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.photo_library,
                size: 50,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 12),
              Text(
                'No photos yet',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tap + to add photos',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: _photos.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: FileImage(File(_photos[index])),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}