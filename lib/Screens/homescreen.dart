import 'package:flutter/material.dart';
import 'package:task_manager/Screens/loginpage.dart';
import 'package:google_fonts/google_fonts.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE3F2FD),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top heading
              Row(
                children: [
                  Image.asset("assets/logo.png", height: 50, width: 50),

                  const SizedBox(width: 5),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "TaskFlow",
                        style: GoogleFonts.luxuriousRoman(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                        ),
                      ),
                      // Text(
                      //   "Flow",
                      //   style: GoogleFonts.luxuriousRoman(
                      //     fontSize: 22,
                      //     fontWeight: FontWeight.bold,
                      //     height: 1.1,
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Center Image
              Center(child: Image.asset("assets/frontpage.png", height: 400)),

              //const Spacer(),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 30, right: 10),
                child: SizedBox(
                  width: 300,
                  child: Text(
                    "Organize your tasks, boost your productivity, and achieve your goals with TaskFlow.",
                    style: GoogleFonts.luxuriousRoman(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Bottom Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // edge radius
                    ), // button color
                  ),

                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Loginpage(),
                      ),
                    );
                  },
                  child: Text(
                    "Get Started",
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
