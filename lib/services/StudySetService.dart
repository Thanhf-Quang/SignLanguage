import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/StudySet.dart';

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

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['docId'] = doc.id; // thêm docId
      return data;
    }).toList();  }

  //  Lấy chi tiết StudySet theo Firestore docId
  Future<StudySet?> getStudySetById(String docId) async {
    final doc = await _firestore.collection('StudySet').doc(docId).get();

    if (doc.exists) {
      return StudySet.fromMap(doc.id, doc.data()!);
    }
    return null;
  }


  Future<void> saveScoresAndStatement(
      String studySetId, List<double> scores, String statement) async {
    try {
      final docRef = _firestore.collection('StudySet').doc(studySetId);

      // Kiểm tra document có tồn tại không
      final docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        throw Exception("StudySet với ID '$studySetId' không tồn tại.");
      }

      await docRef.update({
        'scores': scores.map((s) => s as num).toList(), // ép kiểu về num
        'statement': statement,
      });
      print("Lưu scorés thành công");
    } catch (e) {
      print("Lỗi khi lưu scores và statement: $e");
      rethrow;
    }
  }


  Future<List<double>> getScoresOfStudySet(String docId) async {
    try {
      final doc = await _firestore.collection('StudySet').doc(docId).get();
      if (!doc.exists) throw Exception("StudySet không tồn tại");

      final data = doc.data();
      if (data == null || data['scores'] == null) return [];

      List<dynamic> rawScores = data['scores'];
      return rawScores.map((e) => (e as num).toDouble()).toList();
    } catch (e) {
      print("Lỗi khi lấy scores: $e");
      return [];
    }
  }
}
