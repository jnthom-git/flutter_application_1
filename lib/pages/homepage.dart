// lib/pages/HomePage.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/pet.dart';
import 'models/task.dart';
import 'widgets/pet_card.dart';
import 'widgets/task_card.dart';
import '../utils/slide_page_route.dart';
import 'add_pet_page.dart';
import 'add_task_page.dart';
import 'pet_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Sample data - will be replaced with real data later
  List<Pet> pets = [];
  List<Task> tasks = [];
  String userName = "Catherine";

  @override
  void initState() {
    super.initState();
    _loadSampleData();
  }

  // Load sample data for testing
  void _loadSampleData() {
    // Add sample pets with default images
    pets = [
      Pet(
        id: '1',
        name: 'Anita',
        species: 'Dog',
        imagePath: 'assets/images/pets/anita.jpg',
      ),
      Pet(
        id: '2',
        name: 'Max',
        species: 'Cat',
        imagePath: 'assets/images/pets/max.jpeg', // Note: .jpeg extension
      ),
      Pet(
        id: '3',
        name: 'Wyn',
        species: 'Dog',
        imagePath: 'assets/images/pets/wyn.jpg',
      ),
    ];

    // Add sample tasks for today
    DateTime now = DateTime.now();
    tasks = [
      Task(
        id: '1',
        petId: '1',
        petName: 'Anita',
        type: TaskType.playTime,
        title: 'Play Time',
        scheduledTime: DateTime(now.year, now.month, now.day, 12, 0),
      ),
      Task(
        id: '2',
        petId: '1',
        petName: 'Anita',
        type: TaskType.feed,
        title: 'Feed',
        scheduledTime: DateTime(now.year, now.month, now.day, 8, 0),
      ),
      Task(
        id: '3',
        petId: '2',
        petName: 'Max',
        type: TaskType.bath,
        title: 'Bath',
        scheduledTime: DateTime(now.year, now.month, now.day, 9, 0),
      ),
    ];

    // Sort tasks by time
    tasks.sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
  }

  // Get tasks for today only
  List<Task> get todayTasks {
    DateTime now = DateTime.now();
    return tasks.where((task) {
      return task.scheduledTime.year == now.year &&
          task.scheduledTime.month == now.month &&
          task.scheduledTime.day == now.day &&
          !task.isCompleted;
    }).toList();
  }

  // Get tasks grouped by pet
  Map<String, List<Task>> get tasksByPet {
    Map<String, List<Task>> grouped = {};
    for (var task in todayTasks) {
      if (!grouped.containsKey(task.petId)) {
        grouped[task.petId] = [];
      }
      grouped[task.petId]!.add(task);
    }
    return grouped;
  }

  void _addPet() async {
    // Navigate to Add Pet page with slide transition
    final result = await Navigator.push(
      context,
      SlidePageRoute(page: const AddPetPage()),
    );

    // If a pet was added, add it to the list
    if (result != null && result is Pet) {
      setState(() {
        pets.add(result);
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${result.name} added successfully! 🎉'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _addTask() async {
    // Navigate to Add Task page with slide transition
    final result = await Navigator.push(
      context,
      SlidePageRoute(page: AddTaskPage(pets: pets)),
    );

    // If a task was added, add it to the list
    if (result != null && result is Task) {
      setState(() {
        tasks.add(result);
        // Sort tasks by time
        tasks.sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task added for ${result.petName}! 🎉'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _onPetTapped(Pet pet) {
    // Navigate to pet detail page with slide transition
    Navigator.push(
      context,
      SlidePageRoute(
        page: PetDetailPage(
          pet: pet,
          tasks: tasks,
        ),
      ),
    );
  }

  void _completeTask(Task task) {
    setState(() {
      tasks.removeWhere((t) => t.id == task.id);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${task.title} completed! 🎉'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with user greeting and profile
                _buildHeader(),
                const SizedBox(height: 32),

                // My Pets section
                _buildMyPetsSection(),
                const SizedBox(height: 32),

                // Tasks Today section
                _buildTasksTodaySection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Good Morning',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '$userName!',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Color(0xFFFF6B6B),
              ),
            ),
          ],
        ),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[300],
          ),
          child: const Icon(
            Icons.person,
            size: 30,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildMyPetsSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'My Pets',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: _addPet,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.add,
                      size: 18,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Add a Pet',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        
        // Pets list
        pets.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.pets,
                        size: 60,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No pets yet',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap "Add a Pet" to get started',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: pets.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 20),
                  itemBuilder: (context, index) {
                    return PetCard(
                      pet: pets[index],
                      onTap: () => _onPetTapped(pets[index]),
                    );
                  },
                ),
              ),
      ],
    );
  }

  Widget _buildTasksTodaySection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Tasks Today',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: _addTask,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.add,
                      size: 18,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Add a Task',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Tasks grouped by pet
        todayTasks.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.task_alt,
                        size: 60,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No tasks for today',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap "Add a Task" to schedule activities',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tasksByPet.length,
                itemBuilder: (context, index) {
                  String petId = tasksByPet.keys.elementAt(index);
                  List<Task> petTasks = tasksByPet[petId]!;
                  Pet pet = pets.firstWhere((p) => p.id == petId);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Pet name header
                      Padding(
                        padding: EdgeInsets.only(
                          left: 4,
                          bottom: 12,
                          top: index > 0 ? 20 : 0,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[300],
                              ),
                              child: const Icon(
                                Icons.pets,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              pet.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: _addTask,
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
                      ),
                      
                      // Tasks for this pet
                      ...petTasks.map((task) => TaskCard(
                            task: task,
                            pet: pet,
                            onComplete: () => _completeTask(task),
                          )),
                    ],
                  );
                },
              ),
      ],
    );
  }
}