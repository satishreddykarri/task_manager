import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/Screens/profilescreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Task {
  String id;
  String title;
  bool isDone;

  Task({required this.id, required this.title, required this.isDone});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      isDone: json['is_done'],
    );
  }
}

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<Task> tasks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    try {
      final response = await Supabase.instance.client
          .from('tasks')
          .select()
          .order('created_at');
      
      setState(() {
        tasks = (response as List).map((task) => Task.fromJson(task)).toList();
        isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching tasks: $e')),
        );
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  double get progress {
    if (tasks.isEmpty) return 0;
    int completed = tasks.where((task) => task.isDone).length;
    return completed / tasks.length;
  }

  Future<void> addTask(String title) async {
    try {
      final response = await Supabase.instance.client
          .from('tasks')
          .insert({'title': title, 'is_done': false})
          .select()
          .single();
          
      setState(() {
        tasks.add(Task.fromJson(response));
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding task: $e')),
        );
      }
    }
  }

  Future<void> deleteTask(int index) async {
    final task = tasks[index];
    try {
      await Supabase.instance.client.from('tasks').delete().eq('id', task.id);
      setState(() {
        tasks.removeAt(index);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting task: $e')),
        );
      }
    }
  }

  Future<void> updateTask(int index, String title) async {
    final task = tasks[index];
    try {
      await Supabase.instance.client
          .from('tasks')
          .update({'title': title})
          .eq('id', task.id);
          
      setState(() {
        tasks[index].title = title;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating task: $e')),
        );
      }
    }
  }

  Future<void> toggleTask(int index) async {
    final task = tasks[index];
    final bool updatedStatus = !task.isDone;
    
    try {
      await Supabase.instance.client
          .from('tasks')
          .update({'is_done': updatedStatus})
          .eq('id', task.id);
          
      setState(() {
        tasks[index].isDone = updatedStatus;
      });

      /// Remove completed task after 1 minute
      if (updatedStatus) {
        Timer(const Duration(minutes: 1), () {
          if (index < tasks.length && tasks[index].isDone) {
            deleteTask(index);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating task status: $e')),
        );
      }
    }
  }

  void showAddTaskDialog() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Task"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Enter task name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  addTask(controller.text);
                }

                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void showEditTaskDialog(int index) {
    TextEditingController controller = TextEditingController(
      text: tasks[index].title,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Update Task"),
          content: TextField(controller: controller),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () {
                updateTask(index, controller.text);
                Navigator.pop(context);
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header (Logo + App Name)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Logo + App Name
                  Flexible(
                    child: Row(
                      children: [
                        Image.asset("assets/logo.png", height: 40, width: 40)
                            .animate()
                            .fade(duration: 400.ms)
                            .scale(delay: 100.ms),
        
                        const SizedBox(width: 8),
        
                        Flexible(
                          child: Text(
                            "TaskFlow",
                            style: GoogleFonts.luxuriousRoman(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ).animate().fade(duration: 500.ms, delay: 200.ms).slideX(begin: -0.2, end: 0),
                        ),
                      ],
                    ),
                  ),
        
                  /// Profile Icon
                  IconButton(
                    icon: const Icon(
                      Icons.account_circle,
                      size: 35,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) {
                            final user = Supabase.instance.client.auth.currentUser;
                            final metadata = user?.userMetadata ?? {};
                            
                            return ProfileScreen(
                                  name: metadata['name'] ?? "Unknown",
                                  email: user?.email ?? "Unknown",
                                  mobile: metadata['phone'] ?? "N/A",
                                  tasks: tasks,
                                );
                          },
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return FadeTransition(opacity: animation, child: child);
                          },
                        ),
                      );
                    },
                  ).animate().fade(duration: 400.ms).scale(delay: 300.ms),
                ],
              ),
              const SizedBox(height: 30),

              /// Progress Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Your Tasks",
                    style: GoogleFonts.luxuriousRoman(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 6,
                          backgroundColor: Colors.grey[300],
                        ),
                      ),

                      Text("${(progress * 100).toInt()}%"),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// Task List
              Expanded(
                child: isLoading 
                  ? const Center(child: CircularProgressIndicator())
                  : tasks.isEmpty 
                    ? Center(child: Text("No tasks found.", style: GoogleFonts.luxuriousRoman(fontSize: 18))) 
                    : ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),

                            child: ListTile(
                              /// Checkbox
                              leading: Checkbox(
                                value: tasks[index].isDone,
                                onChanged: (value) {
                                  toggleTask(index);
                                },
                              ),

                              /// Task Title
                              title: Text(
                                tasks[index].title,
                                style: TextStyle(
                                  decoration:
                                      tasks[index].isDone
                                          ? TextDecoration.lineThrough
                                          : null,
                                  color: tasks[index].isDone 
                                          ? Colors.grey 
                                          : Colors.black,
                                ),
                              ),

                              /// Edit + Delete Buttons
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blueGrey),
                                    onPressed: () {
                                      showEditTaskDialog(index);
                                    },
                                  ),

                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                                    onPressed: () {
                                      deleteTask(index);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ).animate()
                           .fade(duration: 400.ms, delay: (index * 100).ms)
                           .slideY(begin: 0.2, end: 0, curve: Curves.easeOut);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),

      /// Add Task Button
      floatingActionButton: FloatingActionButton(
        onPressed: showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
