import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'taskscreen.dart';
import 'loginpage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatelessWidget {
  final String? name;
  final String? email;
  final String? mobile;
  final List<Task>? tasks;

  const ProfileScreen({
    super.key,
    required this.name,
    required this.email,
    required this.mobile,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    int completedTasks = tasks?.where((task) => task.isDone).length ?? 0;

    int incompleteTasks = tasks?.where((task) => !task.isDone).length ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                children: [
                  Image.asset("assets/logo.png", height: 40, width: 40),

                  const SizedBox(width: 8),

                  Text(
                    "TaskFlow",
                    style: GoogleFonts.luxuriousRoman(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              /// Profile Icon
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue,
                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// User Details
              Text(
                "Name: $name",
                style: GoogleFonts.luxuriousRoman(fontSize: 18),
              ),

              const SizedBox(height: 10),

              Text(
                "Email: $email",
                style: GoogleFonts.luxuriousRoman(fontSize: 18),
              ),

              const SizedBox(height: 10),

              Text(
                "Mobile: $mobile",
                style: GoogleFonts.luxuriousRoman(fontSize: 18),
              ),

              const SizedBox(height: 30),

              /// Task Statistics
              Text(
                "Task Statistics",
                style: GoogleFonts.luxuriousRoman(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              Text(
                "Completed Tasks: $completedTasks",
                style: GoogleFonts.luxuriousRoman(fontSize: 18),
              ),

              const SizedBox(height: 10),

              Text(
                "Incomplete Tasks: $incompleteTasks",
                style: GoogleFonts.luxuriousRoman(fontSize: 18),
              ),

              const SizedBox(height: 40),

              /// Logout Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    await Supabase.instance.client.auth.signOut();
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Loginpage(),
                        ),
                        (route) => false,
                      );
                    }
                  },
                  child: Text(
                    "Logout",
                    style: GoogleFonts.luxuriousRoman(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
