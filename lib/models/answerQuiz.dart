class AnswerQuiz {
  final String id; // ID của document
  final String questionId;
  final int correctAnswer;
  final int userAnswer;
  final bool isCorrect;

  AnswerQuiz({
    required this.id,
    required this.questionId,
    required this.correctAnswer,
    required this.userAnswer,
    required this.isCorrect,
  });

  factory AnswerQuiz.empty(String questionId) {
    return AnswerQuiz(
      id: '',
      questionId: questionId,
      correctAnswer: -1,
      userAnswer: -1,
      isCorrect: false,
    );
  }

  factory AnswerQuiz.fromMap(String id, Map<String, dynamic> data) {
    return AnswerQuiz(
      id: id,
      questionId: data['questionId'] ?? '',
      correctAnswer: data['correctAnswer'] ?? 0,
      userAnswer: data['userAnswer'] ?? 0,
      isCorrect: data['isCorrect'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'questionId': questionId,
      'correctAnswer': correctAnswer,
      'userAnswer': userAnswer,
      'isCorrect': isCorrect,
    };
  }
}
