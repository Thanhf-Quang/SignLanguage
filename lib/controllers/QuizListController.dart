import 'package:flutter/cupertino.dart';
import 'package:hand_sign/models/Users.dart';

import '../../models/quiz.dart';
import '../../services/QuizResultService.dart';
import '../../services/QuizService.dart';

class QuizListController extends ChangeNotifier{
  final QuizService _quizService = QuizService();
  final QuizResultService _quizResultService = QuizResultService();

  List<Quiz> _allQuizzes = [];
  List<String> _quizTypes = [];
  Map<String, double> _resultScore = {};
  bool _isLoading = true;
  String? _selectedType;

  List<Quiz> get allQuizzes => _allQuizzes;
  List<String> get quizTypes => _quizTypes;
  Map<String, double> get resultScore => _resultScore;
  bool get isLoading => _isLoading;
  String? get selectedType => _selectedType;

  bool get isTeacher => Users.currentUser?.role == 'Teacher';

  List<Quiz> get filteredQuizzes {
    if (_selectedType == null || _selectedType == 'All') {
      return _allQuizzes;
    }
    return _allQuizzes
        .where((quiz) => quiz.typeOfQuiz == _selectedType)
        .toList();
  }

  void setSelectedType(String? type) {
    _selectedType = type;
    notifyListeners();
  }

  /// lấy dữ liệu cho màn hình quiz screen
  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    // lấy tất cả các quiz
    _allQuizzes = await _quizService.getAllQuiz();

    // lấy topic các quiz
    _quizTypes = _allQuizzes
        .map((quiz) => quiz.typeOfQuiz)
        .where((type) => type != null && type.trim().isNotEmpty)
        .toSet()
        .toList();

    final user = Users.currentUser;
    if (user != null) {
      // lấy điểm bài quiz user nếu có
      _resultScore = await _quizResultService.getScoreByQuiz(user.id);
    }

    _isLoading = false;
    notifyListeners();
  }

  /// lấy dữ liệu cho manage quiz
  Future<void> loadQuizByUserId(String userId) async {
    _isLoading = true;
    notifyListeners();

    _allQuizzes = await _quizService.getListQuizByUserId(userId);
    _quizTypes = _allQuizzes
        .map((quiz) => quiz.typeOfQuiz)
        .where((type) => type != null && type.trim().isNotEmpty)
        .toSet()
        .toList();

    _isLoading = false;
    notifyListeners();
  }


  Future<void> deleteQuiz(String quizId) async {
    _isLoading = true;
    notifyListeners();

    await _quizService.deleteQuizWithQuestions(quizId);
    // Xoá khỏi danh sách local
    _allQuizzes.removeWhere((q) => q.quizId == quizId);

    // Cập nhật lại danh sách loại quiz
    _quizTypes = _extractQuizTypes(allQuizzes);
    if (_selectedType != null && !_quizTypes.contains(_selectedType)) {
      _selectedType = 'All';
    }

    _isLoading = false;
    notifyListeners();
  }

  List<String> _extractQuizTypes(List<Quiz> quizzes) {
    return quizzes
        .map((quiz) => quiz.typeOfQuiz)
        .where((type) => type != null && type.trim().isNotEmpty)
        .toSet()
        .toList();
  }
}