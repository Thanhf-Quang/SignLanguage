import 'package:cloud_firestore/cloud_firestore.dart';

class StudySetService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveStudySet({
    required String title,
    required String category,
    required List<String> studyItemIds,
    required bool isPublic,
    String? userId, // tùy chọn
  }) async {
    final studySetData = {
      'title': title,
      'category': category,
      'studyItems': studyItemIds,
      'isPublic': isPublic,
      'createAt': FieldValue.serverTimestamp(),
      'createBy': userId ?? '',
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
    };

    await _firestore.collection('StudySet').add(studySetData);
  }
  // Hàm lấy danh sách StudySet
  Future<List<Map<String, dynamic>>> getListStudySet() async {
    final snapshot = await _firestore
        .collection('StudySet')
        .orderBy('createAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
