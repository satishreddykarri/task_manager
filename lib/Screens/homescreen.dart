import 'package:flutter/material.dart';
import 'package:task_manager/Screens/loginpage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Determine sizing thresholds
            double screenHeight = constraints.maxHeight;
            double screenWidth = constraints.maxWidth;
            
            // Limit max width for tablets/desktop
            double contentWidth = screenWidth > 600 ? 500 : screenWidth;
            double imgHeight = screenHeight * 0.45; // Relies on safe area height
            
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: contentWidth),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top heading
                      Row(
                        children: [
                          Image.asset("assets/logo.png", height: 50, width: 50)
                              .animate()
                              .fade(duration: 500.ms)
                              .scale(delay: 200.ms),
        
                          const SizedBox(width: 8),
        
                          Text(
                            "TaskFlow",
                            style: GoogleFonts.luxuriousRoman(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                            ),
                          ).animate()
                           .fade(duration: 600.ms, delay: 100.ms)
                           .slideX(begin: -0.2, end: 0),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Center Image (Responsive height)
                      Center(
                        child: Image.asset(
                          "assets/frontpage.png", 
                          height: imgHeight,
                          fit: BoxFit.contain,
                        ),
                      ).animate()
                       .fade(duration: 800.ms, delay: 300.ms)
                       .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),
        
                      const SizedBox(height: 20),
                      
                      // Description Text
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          "Organize your tasks, boost your productivity, and achieve your goals with TaskFlow.",
                          style: GoogleFonts.luxuriousRoman(
                            fontSize: screenWidth > 400 ? 20 : 18,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ).animate()
                         .fade(duration: 600.ms, delay: 500.ms),
                      ),
        
                      const Spacer(),
        
                      // Bottom Button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15), 
                            ), 
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) => const Loginpage(),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  return FadeTransition(opacity: animation, child: child);
                                },
                              ),
                            );
                          },
                          child: Text(
                            "Get Started",
                            style: GoogleFonts.luxuriousRoman(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ).animate()
                         .fade(duration: 600.ms, delay: 700.ms)
                         .scale(begin: const Offset(0.9, 0.9)),
                      ),
                      
                      const SizedBox(height: 20), // Bottom padding
                    ],
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}
