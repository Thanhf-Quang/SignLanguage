import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:hand_sign/views/login/login.dart';
import './home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'views/login/login.dart';
import 'views/flashcard/flashcard.dart';


late List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hand Gesture Recognition',
      debugShowCheckedModeBanner: false,
      home: FlashCardScreen(),
    );
  }
}
