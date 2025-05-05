import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/FlashCard.dart';
import './gesture_matching.dart';
import './reflex.dart';
import '../../controllers/LevelManager.dart';
import '../../models/Users.dart';
import '../../services/UserServices.dart';


class FlashCardScreen extends StatefulWidget {
  @override
  _FlashCardScreenState createState() => _FlashCardScreenState();
}

class _FlashCardScreenState extends State<FlashCardScreen> {
  final Color primaryColor = Color(0xFFFF6F00); // Màu cam chính
  List<bool> levelUnlocked = [true, false, false, false]; // default tạm
  final currentUser = FirebaseAuth.instance.currentUser;

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
                      Text("2  "),
                      Icon(Icons.bookmark, color: Colors.pink),
                      Text("0"),
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
                          Navigator.push(context, MaterialPageRoute(builder: (_) => GestureMatchingGame()));
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
                          Navigator.push(context, MaterialPageRoute(builder: (_) => ReflexScreen()));
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
                          debugPrint("đến trang 3");
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
                          debugPrint("đến trang 4");
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
        currentIndex: 0,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.pan_tool), label: "Practice"),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: "Menu"),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Study"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
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
              title: Text("Warning"),
              content: Text("You need to pass the previous levels to continue.", style: TextStyle(fontSize: 18,)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("OK",style: TextStyle(fontSize: 16,)),
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


