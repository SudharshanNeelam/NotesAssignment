import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notesassignment/Controllers.dart/InternetController.dart';
import 'package:notesassignment/Controllers.dart/NoteController.dart';
import 'package:notesassignment/Services/LocalDb.dart';
import 'package:notesassignment/Views/HomeView.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await LocalDB.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Notecontroller()..loadNotes(),
        
        ),
        ChangeNotifierProvider(create: (_)=>InternetController())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homeview(),
    );
  }
}