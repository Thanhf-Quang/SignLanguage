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
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // đóng dialog
              if (onCancel != null) onCancel();
            },
            child: Text("Không"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // đóng dialog
              onConfirm();
            },
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }
}
