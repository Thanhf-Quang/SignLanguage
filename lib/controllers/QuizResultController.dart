import 'package:flutter/cupertino.dart';

import '../services/QuizResultService.dart';
import '../models/answerQuiz.dart';

class QuizResultController {
  final QuizResultService _resultService = QuizResultService();

  Future<String?> getQuizResultId(String quizId, String userId) async {
    return await _resultService.getQuizResultId(quizId, userId);
  }

  /// Lấy danh sách đáp án từ 1 quizResult cụ thể
  Future<List<AnswerQuiz>> getAnswersByResultId(String quizResultId) async {
    debugPrint("đã gọi đến controller");
    return await _resultService.getAnswers(quizResultId);
  }

  /// (Optional) Xoá kết quả quiz theo ID, dùng để reset
  Future<void> deleteQuizResult(String quizResultId) async {
    await _resultService.deleteQuizResult(quizResultId);
  }
}
