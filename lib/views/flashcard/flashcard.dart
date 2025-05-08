import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hand_sign/views/StudySet/StudySetsScreen.dart';
import 'package:hand_sign/views/flashcard/memory.dart';
import '../../models/Users.dart';
import '../Home/HomeScreen.dart';
import '../../models/FlashCard.dart';
import '../Practice/PracticeScreen.dart';
import '../menu/menu.dart';
import './gesture_matching.dart';
import './reflex.dart';
import '../../controllers/LevelManager.dart';
import '../profile/edit_profile.dart';


class FlashCardScreen extends StatefulWidget {
  @override
  _FlashCardScreenState createState() => _FlashCardScreenState();
}

class _FlashCardScreenState extends State<FlashCardScreen> {
  final Color primaryColor = Color(0xFFFF6F00); // Màu cam chính
  List<bool> levelUnlocked = [true, false, false, false]; // default tạm
  final currentUser = Users.currentUser;

  @override
  void initState() {
    super.initState();
    _loadLevelStatus();
  }

  void _loadLevelStatus() async {
    if (currentUser == null) {
      print("User chưa đăng nhập - không thể load level");
      return;
    }

    final levels = await LevelManager.getUnlockedLevels(4);
    setState(() {
      levelUnlocked = levels;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFCF3),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Hello there!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber),
                    ],
                  )
                ],
              ),
            ),

            // Continue Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black12)],
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: primaryColor,
                    child: Icon(Icons.pan_tool, color: Colors.white),
                  ),
                  title: Text("Learning through games"),
                  subtitle: Text("Master Sign Language with us"),
                  trailing: CircleAvatar(
                    backgroundColor: primaryColor,
                    child: Icon(Icons.play_arrow, color: Colors.white),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Steps with hand icons and dotted line
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Dotted Path (giả lập)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: DottedPathPainter(),
                      ),
                    ),
                    // Hand Icons
                    // Hand Icons
                    // Level 1
                    Positioned(
                      top: 0,
                      child: handCircle(
                        context: context,
                        isUnlocked: levelUnlocked[0],
                        level: 1,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => ReflexScreen()));
                        },
                      ),
                    ),
// Level 2
                    Positioned(
                      top: 200,
                      left: 50,
                      child: handCircle(
                        context: context,
                        isUnlocked: levelUnlocked[1],
                        level: 2,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => GestureMatchingGame()));
                        },
                      ),
                    ),
// Level 3
                    Positioned(
                      top: 330,
                      right: 50,
                      child: handCircle(
                        context: context,
                        isUnlocked: levelUnlocked[2],
                        level: 3,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => MemoryGame()));
                        },
                      ),
                    ),
// Level 4
                    Positioned(
                      bottom: 20,
                      child: handCircle(
                        context: context,
                        isUnlocked: levelUnlocked[3],
                        level: 4,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => ReflexScreen()));
                        },
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: 1, // Index tương ứng với màn FlashCard (Practice)
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );// hoặc dùng MaterialPageRoute nếu chưa định tuyến
          }
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PracticeScreen()),
            );
          }
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MenuScreen()),
            );
          }
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StudySetsPage()),
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
          buildNavItem('assets/icons/book.png', 'Studyset'),
          buildNavItem('assets/icons/user.png', 'Profile'),
        ],
      ),

    );
  }

  BottomNavigationBarItem buildNavItem(String imagePath, String label) {
    return BottomNavigationBarItem(
      icon: Image.asset(imagePath, width: 24, height: 24),
      label: label,
    );
  }

  Widget handCircle({
    required BuildContext context,
    required bool isUnlocked,
    required int level,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: () {
        if (isUnlocked) {
          onTap?.call();
        } else {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              backgroundColor: Color(0xFFFFF8EE),
              title: Text("Warning",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              content: Text("You need to pass the previous levels to continue."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("OK",style: TextStyle(fontSize: 16, color: Color(0xFF4E3715))),
                )
              ],
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isUnlocked ? primaryColor : Colors.grey,
        ),
        child: Column(
          children: [
            Icon(Icons.pan_tool, color: Colors.white, size: 40),
            SizedBox(height: 4),
          ],
        ),
      ),
    );
  }



}


