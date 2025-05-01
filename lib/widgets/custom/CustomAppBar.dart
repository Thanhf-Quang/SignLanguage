import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFFFFD1BF),
      elevation: 0,
      leading: GestureDetector(
        onTap: onBack ?? () => Navigator.pop(context),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Image.asset(
            "assets/icons/back.png",
            width: 30,
            height: 30,
          ),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
