import 'package:flutter/material.dart';
import '../Home/HomeScreen.dart';
import '../profile/edit_profile.dart';
import '../flashcard/flashcard.dart';

class PracticeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF8EE),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: 1, // Đặt mặc định ở "Practice"
        onTap: (index) {
          if (index == 2) { // Khi nhấn vào "Menu"
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()), // Chuyển sang màn hình Menu
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
          buildNavItem('assets/home.png', 'Home'),
          buildNavItem('assets/point.png', 'Practice'),
          buildNavItem('assets/open-menu.png', 'Menu'),
          buildNavItem('assets/book.png', 'Study'),
          buildNavItem('assets/user.png', 'Profile'),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Practice',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),
            ),
            Text("Let's be smart together!",
              style: TextStyle(color: Colors.grey,),),
            SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF721A),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text(
                        'Take Quiz', style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FlashCardScreen(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.orange),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text(
                        'Flashcards', style: TextStyle(color: Colors.orange)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text('Select category to practice',
                style: TextStyle(fontSize: 16, color: Color(0xFF5D5D5D))),
            SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  categoryTile('Alphabet', 'assets/alphabet.png', true),
                  categoryTile('Hair', 'assets/hairdryer.png', false),
                  categoryTile('Nature', 'assets/nature.png', false),
                  categoryTile('Hobbies', 'assets/hobbies.png', false),
                  categoryTile('Weather', 'assets/weather.png', false),
                  categoryTile('Other', 'assets/other.png', false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryTile(String title, String imagePath, bool isNew) {
    return Container(
      width: 100, // Điều chỉnh chiều rộng
      height: 120, // Điều chỉnh chiều cao
      padding: EdgeInsets.all(10), // Giảm padding
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
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Image.asset(
                    imagePath,
                    width: 80, // Kích thước ảnh
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center, // Căn giữa text
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF5D5D5D),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
          if (isNew)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'NEW',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
        ],
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
