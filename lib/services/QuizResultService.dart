import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../models/quizResult.dart';
import '../models/answerQuiz.dart';

class QuizResultService {
  final CollectionReference _quizResultRef = FirebaseFirestore.instance.collection('quizResult');

  /// Lấy danh sách tất cả quizResult của một user
  Future<List<DocumentSnapshot>> _getQuizResultsByUser(String userId) async {
    final snapshot = await _quizResultRef.where('userId', isEqualTo: userId).get();
    return snapshot.docs;
  }

  /// Lấy điểm cho mỗi quiz (Map<quizId, score>)
  Future<Map<String, double>> getScoreByQuiz(String userId) async {
    final quizResults = await _getQuizResultsByUser(userId);
    Map<String, double> scoreMap = {};

    for (var result in quizResults) {
      final quizId = result['quizId'] ?? result.id;
      final dynamic rawScore = result['score'];

      if (rawScore is Map) {
        // Nếu score là một Map (ví dụ {"quiz1": 9, "quiz2": 7})
        rawScore.forEach((key, value) {
          scoreMap[key] = (value as num).toDouble();
        });
      } else {
        // Nếu score là 1 số đơn lẻ
        scoreMap[quizId] = (rawScore ?? 0).toDouble();
      }
    }

    return scoreMap;
  }

  /// Lấy quizResultId của một user cho một quiz cụ thể
  Future<String?> getQuizResultId(String quizId, String userId) async {
    final snapshot = await _quizResultRef
        .where('quizId', isEqualTo: quizId)
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.id;
    }
    return null;
  }

  /// Lấy danh sách câu trả lời từ 1 quiz result
  Future<List<AnswerQuiz>> getAnswers(String quizResultId) async {
    final snapshot = await _quizResultRef
        .doc(quizResultId)
        .collection('answer')
        .get();

    return snapshot.docs.map((doc) => AnswerQuiz.fromMap(doc.id, doc.data())).toList();
  }

  /// xoá quiz result
  Future<void> deleteQuizResult(String quizResultId) async {
    try {
      // Lấy reference tới subcollection 'answer'
      var answerCollectionRef = _quizResultRef
          .doc(quizResultId)
          .collection('answer');

      // Lấy tất cả các document trong subcollection 'answer'
      var answers = await answerCollectionRef.get();

      // Xoá tất cả document trong subcollection 'answer'
      for (var answer in answers.docs) {
        await answer.reference.delete();
        debugPrint('Deleted answer with ID: ${answer.id}');
      }

      // Xoá document chính trong collection 'quizResults'
      await _quizResultRef.doc(quizResultId).delete();
      debugPrint('QuizResult with ID: $quizResultId has been deleted successfully.');
    } catch (e) {
      debugPrint('Error deleting quizResult or answers: $e');
      rethrow;  // Ném lại lỗi nếu cần xử lý ở nơi gọi hàm
    }
  }
}
