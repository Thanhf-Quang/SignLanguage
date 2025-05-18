import 'package:flutter/material.dart';

class DottedPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(size.width / 2, 20)
      ..cubicTo(size.width * -0.65, size.height / 1.5, size.width * 1.85, size.height / 3, size.width / 3, size.height);

    final dashWidth = 5.0;
    final dashSpace = 5.0;
    double distance = 0.0;

    final double maxLengthFactor = 0.9;

    final pathMetrics = path.computeMetrics();
    for (var metric in pathMetrics) {
      // Giới hạn distance dựa trên maxLengthFactor
      while (distance < metric.length * maxLengthFactor) {
        // ==================================
        // Tính toán điểm cuối của nét đứt hiện tại, đảm bảo không vượt quá giới hạn
        final double end = (distance + dashWidth < metric.length * maxLengthFactor)
            ? distance + dashWidth
            : metric.length * maxLengthFactor; // Nếu nét đứt cuối cùng bị cắt ngắn

        // Chỉ trích xuất và vẽ nếu điểm bắt đầu nhỏ hơn điểm cuối
        if (distance < end) {
          final extractPath = metric.extractPath(distance, end);
          canvas.drawPath(extractPath, paint);
        }
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}