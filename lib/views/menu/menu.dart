import 'package:flutter/material.dart';
import 'package:hand_sign/views/detection/detection_screen.dart';
import 'package:hand_sign/views/dictionary/SearchScreen.dart';
import 'package:hand_sign/views/flashcard/flashcard.dart';
import 'package:hand_sign/views/login/login.dart';
import 'package:hand_sign/views/notes/notes.dart';
import 'package:hand_sign/views/quiz/QuizScreen.dart';
import '../../models/Users.dart';
import '../Home/HomeScreen.dart';
import '../profile/edit_profile.dart';
import '../Practice/PracticeScreen.dart';
import 'package:camera/camera.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF8EE),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: 2, // Đặt mặc định ở "Practice"
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()), // Chuyển sang màn hình Menu
            );
          }
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PracticeScreen()), // Chuyển sang màn hình Menu
            );
          }
          if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditProfilePage()),
            );
          }
        },
        items: [
          buildNavItem('assets/icons/home.png', 'Home'),
          buildNavItem('assets/icons/point.png', 'Practice'),
          buildNavItem('assets/icons/open-menu.png', 'Menu'),
          buildNavItem('assets/icons/book.png', 'Study'),
          buildNavItem('assets/icons/user.png', 'Profile'),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Menu',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),
            ),
            SizedBox(height: 20),
            Text('Uncover new topics and choose where to begin!',
                style: TextStyle(fontSize: 16, color: Color(0xFF5D5D5D))),
            SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                   categoryTile(context, 'Camera', 'assets/icons/camera.png'),
                   categoryTile(context, 'Dictionary', 'assets/icons/dictionary.png'),
                   categoryTile(context, 'Games', 'assets/icons/games.png'),
                   categoryTile(context, 'Quiz Test', 'assets/icons/quiz.png'),
                   categoryTile(context, 'My Notes', 'assets/icons/note.png'),
                   categoryTile(context, 'Login', 'assets/icons/login.png'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryTile(BuildContext context, String title, String imagePath) {
    final currentUser = Users.currentUser;
    return GestureDetector(
      onTap: () async {
        if (title == 'Camera') {
          WidgetsFlutterBinding.ensureInitialized();
          cameras = await availableCameras();

          Navigator.push(context, MaterialPageRoute(builder: (context) => DetectionScreen()));
        } else if (title == 'Dictionary') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => DictionaryScreen()));
        } else if (title == 'Games') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => FlashCardScreen()));
        } else if (title == 'Quiz Test') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => QuizScreen()));
        } else if (title == 'My Notes') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => NotesScreen()));
        } else if (title == 'Login') {
          if(currentUser != null){
            Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage()));
          }else{
            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
          }
        }
      },
      child: Container(
        width: 100,
        height: 120,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              spreadRadius: 1,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Image.asset(
                  imagePath,
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF5D5D5D),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem buildNavItem(String imagePath, String label){
    return BottomNavigationBarItem(
      icon: Image.asset(imagePath, width: 24, height: 24),
      label: label,
    );
  }
}
