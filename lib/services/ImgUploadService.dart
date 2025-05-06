import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ImgUploadService{
   Future<String?> uploadImg(Uint8List fileBytes, String filename) async {
    try {
      // Phân biệt ảnh hay video dựa vào phần mở rộng file
      final isVideo = _isVideoFile(filename);

      // URL và cấu hình Cloudinary API
      final cloudinaryUrl = Uri.parse('https://api.cloudinary.com/v1_1/dtjywepu3/${isVideo ? 'video' : 'image'}/upload',);
      final uploadPreset = 'hand_sign_app';  // Đặt preset tải lên Cloudinary

      // Gửi yêu cầu tải lên Cloudinary
      final request = http.MultipartRequest('POST', cloudinaryUrl)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(http.MultipartFile.fromBytes('file', fileBytes, filename: filename));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        final Map<String, dynamic> data = Map<String, dynamic>.from(jsonDecode(responseData.body));

        String url = data['secure_url']; // Lấy URL ảnh đã tải lên Cloudinary

        debugPrint("Tải ${isVideo ? 'video' : 'ảnh'} thành công: $url");
        return url;
      } else {
        debugPrint("Lỗi khi tải lên Cloudinary: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      debugPrint("Lỗi tải ảnh: $e");
      return null;
    }
  }

   /// Kiểm tra xem file có phải video không
   bool _isVideoFile(String filename) {
     final lower = filename.toLowerCase();
     return lower.endsWith('.mp4') ||
         lower.endsWith('.mov') ||
         lower.endsWith('.avi') ||
         lower.endsWith('.mkv') ||
         lower.endsWith('.webm');
   }
}