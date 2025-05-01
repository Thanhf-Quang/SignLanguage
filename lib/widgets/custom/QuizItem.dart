import 'package:flutter/material.dart';

class QuizItem extends StatelessWidget {
  final String title;
  final int score;
  final Color color;
  final VoidCallback onPressed;

  const QuizItem({
    super.key,
    required this.title,
    required this.score,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // Sự kiện khi nhấn vào QuizItem
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(2, 2),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                (score == 100)
                  ? Icon(Icons.check_circle, color: Colors.green, size: 24)
                  : Text(
                  "$score%",
                  style: TextStyle(fontSize: 16),
                ),
                Icon(Icons.navigate_next)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
