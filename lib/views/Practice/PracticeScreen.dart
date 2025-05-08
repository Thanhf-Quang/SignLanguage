import 'package:flutter/material.dart';
import '../../controllers/PracticeController.dart';
import '../../models/PracticeTopic.dart';
import '../Home/HomeScreen.dart';
import '../flashcard/flashcard.dart';
import '../profile/edit_profile.dart';
import 'TopicDetailScreen.dart';

class PracticeScreen extends StatefulWidget {
  @override
  _PracticeScreenState createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  final PracticeController _controller = PracticeController();
  List<PracticeTopic> _topics = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  Future<void> _loadTopics() async {
    final topics = await _controller.fetchPracticeTopics();
    setState(() {
      _topics = topics;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF8EE),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: 1,
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
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
            Text('Practice', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text("Let's be smart together!", style: TextStyle(color: Colors.grey)),
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
                    child: Text('Take Quiz', style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FlashCardScreen()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.orange),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text('Flashcards', style: TextStyle(color: Colors.orange)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text('Select category to practice', style: TextStyle(fontSize: 16, color: Color(0xFF5D5D5D))),
            SizedBox(height: 10),
            _loading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: _topics.map((topic) => categoryTile(topic)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryTile(PracticeTopic topic) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TopicDetailScreen(
              topicId: topic.topicid,
              topic: topic,
            ),
          ),
        );
      },
      child: Container(
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
                child: Image.network(
                  topic.symbolTopic,
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              topic.topicTitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF5D5D5D)),
            ),
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
