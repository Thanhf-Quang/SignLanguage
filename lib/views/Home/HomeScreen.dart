import 'package:flutter/material.dart';
import 'package:hand_sign/views/quiz/QuizScreen.dart';
import '../notes/notes.dart';
import '../flashcard/flashcard.dart';
import '../Practice/PracticeScreen.dart';
import '../StudySet/StudySetsScreen.dart'; // Import màn hình cần điều hướng
import '../profile/edit_profile.dart';
import '../detection/detection_screen.dart';
import 'package:camera/camera.dart';

class HomeScreen extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF8EE),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: 2, // Đặt mặc định ở "Home"
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PracticeScreen()),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset('assets/icons/logo.png', width: 40),
                    SizedBox(width: 8),
                    Text(
                      'HandSpeak',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  ],
                ),
                Icon(Icons.notifications, color: Colors.black54),
              ],
            ),

            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            SizedBox(height: 10),
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage('assets/icons/news_1.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            SizedBox(height: 10),
            Text('Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),

            Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        categoryItem('Camera', 'assets/icons/camera.png', Colors.blue, () async {
                          WidgetsFlutterBinding.ensureInitialized();
                          cameras = await availableCameras();

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DetectionScreen()),
                          );
                        }),
                        categoryItem('Games', 'assets/icons/games.png', Colors.purple, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FlashCardScreen()),
                          );
                        }),
                        categoryItem('Study', 'assets/icons/book.png', Colors.orange, () {
                          // TODO: Gọi StudyScreen
                        }),
                        categoryItem('Quiz Test', 'assets/icons/quiz.png', Colors.pink, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => QuizScreen()),
                          );
                        }),
                        categoryItem('Other', 'assets/icons/other.png', Colors.yellow, () {
                          // TODO: Gọi OtherScreen
                        }),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _scrollController.animateTo(
                      _scrollController.offset + 100,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  },
                  child: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
                ),
              ],
            ),


            SizedBox(height: 10),
            Text('Tasks', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),

            /// Task Items - Dùng Wrap thay vì GridView
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                taskItem('Create Study Set', 'assets/icons/book.png', 180, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StudySetsPage()),
                  );
                }),
                taskItem('Topic Test', 'assets/icons/check.png', 180, () {}),
                taskItem('Quiz Test', 'assets/icons/quiz.png', 180, () {}),
                taskItem('My Notes', 'assets/icons/note.png', 180, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotesScreen()),
                  );
                }),
                taskItem('Practice by Topic', 'assets/icons/trending.png', 370, () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryItem(String title, String iconPath, Color bgColor, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: bgColor.withOpacity(0.2),
              ),
              child: Image.asset(iconPath, width: 40),
            ),
            SizedBox(height: 5),
            Text(title, style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  /// **Sửa taskItem() để nhận thêm `onTap`**
  Widget taskItem(String title, String iconPath, double width, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap, // Xử lý sự kiện nhấn vào
      child: Container(
        width: width,
        height: 70, // Giảm kích thước Task Item
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 3,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconPath, width: 30),
            SizedBox(height: 5),
            Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem buildNavItem(String imagePath, String label) {
    return BottomNavigationBarItem(
      icon: Image.asset(imagePath, width: 24, height: 24),
      label: label,
    );
  }
}
