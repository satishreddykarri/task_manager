import 'package:flutter/material.dart';
import 'package:task_manager/Screens/homescreen.dart';
import 'package:task_manager/Screens/taskscreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://uixigojljnjpskwsfpgm.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVpeGlnb2psam5qcHNrd3NmcGdtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMxMDYyMzQsImV4cCI6MjA4ODY4MjIzNH0.vqTTwV33LT0SJj8lK4v2uX73lbiuUUakSNsLUqZaa5I',
  );
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Supabase.instance.client.auth.currentSession != null 
          ? const TaskScreen() 
          : const Homescreen(),
    );
  }
}
