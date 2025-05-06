import 'dart:io';

import '../models/StudyItem.dart';
import '../services/StudyItemService.dart';

class PracticeController {
  final StudyItemService _itemService = StudyItemService();

  /// Lấy danh sách StudyItem từ danh sách ID (dùng cho PracticeScreen)
  Future<List<StudyItem>> loadItems(List<String> itemIds) async {
    try {
      return await _itemService.getItemsByIds(itemIds);
    } catch (e) {
      print('Lỗi khi load StudyItems: $e');
      return [];
    }
  }

  Future<double> compareWithReferenceGif({
    required File userVideo,
    required String referenceGifUrl,
  }) async {
    // Gửi video người dùng và GIF mẫu lên backend xử lý (OpenCV/Mediapipe)
    // Trả về điểm số khớp: ví dụ 0.75 nghĩa là 75%
    // Demo giả lập:
    await Future.delayed(Duration(seconds: 2));
    return 0.75; // sẽ thay bằng kết quả thực từ AI backend
  }

}
