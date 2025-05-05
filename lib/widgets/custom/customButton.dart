import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final List<Color> gradientColors;
  final VoidCallback? onPressed;
  final bool isOutlined;
  final double width;

  const CustomButton({
    super.key,
    required this.text,
    required this.textColor,
    required this.gradientColors,
    required this.onPressed,
    this.isOutlined = false,
    this.width = 230,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 50,
      decoration: BoxDecoration(
        gradient: isOutlined ? null : LinearGradient(
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(25),
        border: isOutlined ? Border.all(color: textColor, width: 2) : null,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
