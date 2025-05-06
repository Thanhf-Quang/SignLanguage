import 'package:cloud_firestore/cloud_firestore.dart';
import './answerQuiz.dart';

class QuizResultModel {
  final String id; // ID của document
  final String userId;
  final String quizId;
  final double score;
  final int correctAnswer;
  final int totalAnswer;
  final DateTime completedAt;
  final List<AnswerQuiz> answers;

  QuizResultModel({
    required this.id,
    required this.userId,
    required this.quizId,
    required this.score,
    required this.correctAnswer,
    required this.totalAnswer,
    required this.completedAt,
    required this.answers,
  });

  factory QuizResultModel.fromMap(String id, Map<String, dynamic> data, List<AnswerQuiz> answers) {
    return QuizResultModel(
      id: id,
      userId: data['userId'] ?? '',
      quizId: data['quizId'] ?? '',
      score: data['score'] ?? 0,
      correctAnswer: data['correctAnswer'] ?? 0,
      totalAnswer: data['totalAnswer'] ?? 0,
      completedAt: (data['completedAt'] as Timestamp).toDate(),
      answers: answers,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'quizId': quizId,
      'score': score,
      'correctAnswer': correctAnswer,
      'totalAnswer': totalAnswer,
      'completedAt': Timestamp.fromDate(completedAt),
    };
  }
}
