import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/Users.dart';
import '../models/FlashCard.dart';

class LevelManager {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  /// Lấy danh sách level đã unlock của người dùng
  static Future<List<bool>> getUnlockedLevels(int totalLevels) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception("User chưa đăng nhập");

      final doc = await _firestore.collection('users').doc(userId).get();
      final data = doc.data();

      if (data == null || !data.containsKey('progress')) {
        // Nếu chưa có dữ liệu, trả về mặc định (chỉ mở khóa level 1)
        return [true, ...List<bool>.filled(totalLevels - 1, false)];
      }

      final List<dynamic> levels = data['progress']['flashcards'];
      return levels.cast<bool>();
    } catch (e) {
      print('Lỗi lấy level: $e');
      return [true, ...List<bool>.filled(totalLevels - 1, false)];
    }
  }

  /// Cập nhật tiến độ học (mở khóa level mới)
  static Future<void> unlockLevel(int levelIndex) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) throw Exception("User chưa đăng nhập");
    if (userId != null){
      print("User ID: $userId");
    }

    final userRef = _firestore.collection('users').doc(userId);
    final doc = await userRef.get();

    List<bool> currentProgress = [];

    if (doc.exists && doc.data()?['progress']?['flashcards'] != null) {
      currentProgress = List<bool>.from(doc['progress']['flashcards']);
    } else {
      currentProgress = [true, false, false, false];
    }

    // Mở khóa level mới nếu chưa mở
    if (levelIndex >= currentProgress.length) {
      // Mở rộng danh sách cho đủ length trước khi gán giá trị true
      currentProgress += List.filled(levelIndex - currentProgress.length + 1, false);
    }
    currentProgress[levelIndex] = true;
    print("Progress cập nhật: $currentProgress");


    await userRef.set({
      'progress': {
        'flashcards': currentProgress,
      }
    }, SetOptions(merge: true));
  }
}
