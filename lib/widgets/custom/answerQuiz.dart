import 'package:flutter/material.dart';

class Answerquiz extends StatelessWidget {
  final String textAnswer;
  final Color color;
  final VoidCallback? onPressed;

  const Answerquiz({
    super.key,
    required this.textAnswer,
    required this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.grey, width: 1),
            ),
            foregroundColor: Colors.black, // giữ màu chữ
            disabledBackgroundColor: color, // giữ màu khi bị disable
            disabledForegroundColor: Colors.black,
          ),
            onPressed: onPressed,
            child: Text(
              textAnswer,
              style: TextStyle(color: Colors.black),
            )
        ),
      )
    );
  }
}