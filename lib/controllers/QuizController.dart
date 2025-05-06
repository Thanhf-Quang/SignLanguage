import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../../models/question.dart';
import '../models/quiz.dart';
import '../services/ImgUploadService.dart';
import '../services/QuizService.dart';

class QuizController extends ChangeNotifier{
  final ImgUploadService _imgUploadService;
  final QuizService _quizService;

  String quizTitle='';
  String quizTopic = '';
  List<Question> questions = [];

  QuizController(this._imgUploadService, this._quizService);

  void setQuizInfo({required String title, required String topic}) {
    quizTitle = title;
    quizTopic = topic;
    notifyListeners();
  }

  ///khởi tạo câu hỏi trống
  void initEmptyQuestions() {
    questions = [
      Question(
        questionId: DateTime.now().millisecondsSinceEpoch.toString(),
        questionText: '',
        correctAnswerIndex: 0,
        options: List.filled(4, ''),
      )
    ];
    notifyListeners();
  }

  ///kiểm tra câu hỏi hiện tại trc khi nhấn next
  String isCurrentQuestionValid(int index) {
    if (index < 0 || index >= questions.length) return 'Câu hỏi không hợp lệ';

    final q = questions[index];
    if (q.questionText.trim().isEmpty) return 'Vui lòng nhập nội dung câu hỏi';
    if (q.options.any((o) => o.trim().isEmpty)) return 'Vui lòng nhập đầy đủ các đáp án';
    if (q.selectedMediaFile == null) return 'Vui lòng chọn ảnh/video minh hoạ';
    if (q.correctAnswerIndex < 0 || q.correctAnswerIndex >= 4) return 'Vui lòng chọn đáp án đúng';

    return '';
  }


  void updateQuestion(int index, Question updated) {
    questions[index] = updated;
    notifyListeners();
  }

  ///----tạo quiz
  Future<String?> saveQuiz() async {
    List<Question> finalQuestions = [];
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return 'Bạn cần phải đăng nhập!';

    for(var q in questions){
      String mediaUrl = '';
      String? mediaType = q.mediaType;

      if (q.selectedMediaFile != null && q.selectedMediaName != null) {
        final uploadedUrl = await _imgUploadService.uploadImg(
          q.selectedMediaFile!,
          q.selectedMediaName!,
        );
        if (uploadedUrl == null) return "Lỗi khi upload media.";
        mediaUrl = uploadedUrl;
      }

      finalQuestions.add(Question(
        questionId: q.questionId,
        questionText: q.questionText,
        options: q.options,
        correctAnswerIndex: q.correctAnswerIndex,
        mediaUrl: mediaUrl,
        mediaType: mediaType,
      ));
    }
    final quiz = Quiz(
      quizId: DateTime.now().millisecondsSinceEpoch.toString(),
      title: quizTitle,
      typeOfQuiz: quizTopic,
      createBy: user.uid,
    );

    await _quizService.createQuiz(quiz, finalQuestions);
    return null;
  }
}
