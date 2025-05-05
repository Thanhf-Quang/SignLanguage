import 'package:flutter/material.dart';
import '../Practice/PracticeScreen.dart';
import '../StudySet/StudySetsScreen.dart'; // Import màn hình cần điều hướng
import '../profile/edit_profile.dart';

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
          buildNavItem('assets/home.png', 'Home'),
          buildNavItem('assets/point.png', 'Practice'),
          buildNavItem('assets/open-menu.png', 'Menu'),
          buildNavItem('assets/book.png', 'Study'),
          buildNavItem('assets/user.png', 'Profile'),
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
                    Image.asset('assets/logo.png', width: 40),
                    SizedBox(width: 8),
                    Text(
                      'App name',
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
                  image: AssetImage('assets/news_1.jpg'),
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
                        categoryItem('Camera', 'assets/camera.png', Colors.blue),
                        categoryItem('Study', 'assets/book.png', Colors.orange),
                        categoryItem('Quiz Test', 'assets/quiz.png', Colors.pink),
                        categoryItem('Other', 'assets/other.png', Colors.purple),
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
                taskItem('Tạo bộ bài học', 'assets/book.png', 180, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StudySetsPage()),
                  );
                }),
                taskItem('Kiểm tra theo chủ đề', 'assets/check.png', 180, () {}),
                taskItem('Quiz Test', 'assets/quiz.png', 180, () {}),
                taskItem('Ghi chú', 'assets/note.png', 180, () {}),
                taskItem('Luyện tập theo chủ đề', 'assets/trending.png', 370, () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryItem(String title, String iconPath, Color bgColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
