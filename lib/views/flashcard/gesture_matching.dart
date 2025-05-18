import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'flashcard.dart';
import '../../controllers/gesture_controller.dart';
import '../../controllers/LevelManager.dart';

class GestureMatchingGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GestureController(),
      child: GestureGameView(),
    );
  }
}

class GestureGameView extends StatelessWidget {
  void _showCompletionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFFFFF8EE),
        title: Text('🎉 Congratulation!', style: TextStyle(fontWeight: FontWeight.bold),),
        content: Text('You have completed the game.',textAlign: TextAlign.center,),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => FlashCardScreen()),
              );
            },
            child: Text('Continue', style: TextStyle(color: Color(0xFF4E3715)),),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<GestureController>(context);
    final imageList = controller.gestureToWord.keys.toList()..shuffle();
    final entryList = controller.gestureToWord.entries.toList()..shuffle();

    return Scaffold(
      backgroundColor: Color(0xFFFFF8EE),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Gesture Matching Game', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFFFBEAB9),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text('Drag the hand sign to the correct meaning', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Expanded(
              child: Row(
                children: [
                  // Cột hình ảnh tay
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: imageList.map((imageName) {
                        return controller.isMatched(imageName)
                            ? Container(height: 80)
                            : Draggable<String>(
                          data: imageName,
                          feedback: Material(
                            color: Colors.transparent,
                            child: Image.asset('assets/images/$imageName', width: 80, height: 80),
                          ),
                          childWhenDragging: Opacity(
                            opacity: 0.3,
                            child: Image.asset('assets/images/$imageName', width: 80, height: 80),
                          ),
                          child: Image.asset('assets/images/$imageName', width: 80, height: 80),
                        );
                      }).toList(),
                    ),
                  ),

                  // Cột nghĩa từ
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: entryList.map((entry) {
                        return DragTarget<String>(
                          builder: (context, candidateData, rejectedData) {
                            return Container(
                              height: 80,
                              width: 120,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: controller.isMatched(entry.key) ? Colors.green : Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.black),
                              ),
                              child: Text(entry.value, style: TextStyle(fontSize: 25)),
                            );
                          },
                          onWillAccept: (data) => data == entry.key,
                            onAccept: (data) {
                              controller.acceptMatch(entry.key);

                              if (controller.isGameComplete()) {
                                // Đảm bảo dialog hiển thị sau khi mở khóa xong level tiếp theo
                                LevelManager.unlockLevel(2); // mở khóa level

                                // Chờ một chút rồi mới hiển thị dialog
                                Future.delayed(Duration(milliseconds: 300), () {
                                  _showCompletionDialog(context);
                                });
                              }
                            }

                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
