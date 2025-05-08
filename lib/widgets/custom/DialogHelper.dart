import 'package:flutter/material.dart';

class DialogHelper {
  static void showConfirmDialog({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmText,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false, // k cho phép bấm ra ngoài để đóng
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFFFFF3EB),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // đóng dialog
              if (onCancel != null) onCancel();
            },
            child: Text(
              "No",
              style: TextStyle(color: Colors.black),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // đóng dialog
              onConfirm();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFFE0CA)),
            child: Text(confirmText,style: TextStyle(color: Colors.black),),
          ),
        ],
      ),
    );
  }
}