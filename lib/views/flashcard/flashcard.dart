import 'package:flutter/material.dart';
import '../../models/FlashCard.dart';
import './gesture_matching.dart';
import './reflex.dart';

class FlashCardScreen extends StatelessWidget {
  final Color primaryColor = Color(0xFFFF6F00); // Màu cam chính

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
                  title: Text("Continue where you left off"),
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
                    Positioned(
                      top: 0,
                      child: handCircle(context, () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => GestureMatchingGame())
                        );
                      }),
                    ),
                    Positioned(
                      top: 200,
                      left: 50,
                      child: handCircle(context, () {
                        //Navigator.pushNamed(context, '/game');
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ReflexScreen())
                        );
                      }),
                    ),
                    Positioned(
                      top: 330,
                      right: 50,
                      child: handCircle(context, () {
                        //Navigator.pushNamed(context, '/sing');
                        debugPrint("đến trang 3");
                      }),
                    ),
                    Positioned(
                      bottom: 20,
                      child: handCircle(context, () {
                       // Navigator.pushNamed(context, '/story');
                        debugPrint("đến trang 4");
                      }),
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

  Widget handCircle(BuildContext context, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: primaryColor,
        ),
        child: Icon(Icons.pan_tool, color: Colors.white, size: 50),
      ),
    );
  }


}


