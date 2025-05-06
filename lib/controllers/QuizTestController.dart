import 'package:hand_sign/models/question.dart';
import '../services/QuizService.dart';

class QuizTestController {
  final QuizService _quizService = QuizService();
  int correctCount = 0;

  Future<String> getQuizTitle(String quizId) async {
    return await _quizService.getQuizTitle(quizId);
  }

  /// kiểm tra đáp án đã chọn
  bool checkAnswer(int selected, int correct) {
    final isCorrect = selected == correct;
    if (isCorrect) correctCount++;
    return isCorrect;
  }

  /// lấy số lượng câu đúng của ng dùng
  int getCorrectCount() => correctCount;

  /// tinh diem
  Map<String, dynamic> calculateScore({
    required List<Question> questions,
    required Map<int, int> selectedAnswers,
  }) {
    int totalQuestions = questions.length;
    double score = 0;
    double scoreFor1Question = 10 / totalQuestions;

    final answers = <Map<String, dynamic>>[];

    for (int i = 0; i < totalQuestions; i++) {
      final q = questions[i];
      final selected = selectedAnswers[i] ?? -1;
      final isCorrect = selected == q.correctAnswerIndex;

      if (isCorrect) {
        score += scoreFor1Question;
      }

      answers.add({
        'questionId': q.questionId,
        'userAnswer': selected,
        'correctAnswer': q.correctAnswerIndex,
        'isCorrect': isCorrect,
      });
    }

    return {
      'score': score,
      'totalAnswer': selectedAnswers.length,
      'answers': answers,
    };
  }


  /// lưu kết quả quiz vào collection quiz result
  Future<void> submitQuizResult({
    required String quizId,
    required String userId,
    required List<Question> questions,
    required Map<int, int> selectedAnswers,
  }) async{
    final result = calculateScore(
      questions: questions,
      selectedAnswers: selectedAnswers,
    );

    await _quizService.saveQuizResult(
      quizId: quizId,
      userId: userId,
      score: result['score'],
      totalAnswer: selectedAnswers.length,
      answers: result['answers'],
    );
  }
}