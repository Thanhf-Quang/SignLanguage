import 'package:flutter/material.dart';
import '../../controllers/QuizResultController.dart';
import '../../models/Users.dart';
import '../../models/answerQuiz.dart';
import '../../models/question.dart';
import '../../services/QuizService.dart';
import './VideoPlayerWidget.dart';
import '../../widgets/custom/customButton.dart';
import '../../widgets/custom/answerQuiz.dart';
import '../../widgets/custom/CustomAppBar.dart';
import '../../controllers/QuizTestController.dart';

class QuizTest extends StatefulWidget {
  final String quizId;
  final bool saveProgress;
  final bool isManageQuiz;
  final bool isViewQuizResult;
  final String? quizResultId;

  const QuizTest({
    super.key,
    required this.quizId,
    this.saveProgress = true,
    this.isManageQuiz = false,
    this.isViewQuizResult = false,
    this.quizResultId,
  });

  @override
  _QuizTestState createState() => _QuizTestState();
}

class _QuizTestState extends State<QuizTest> {
  final PageController _pageController = PageController();
  final QuizService _quizService = QuizService();
  final QuizTestController _quizController = QuizTestController();
  final QuizResultController _quizResultController = QuizResultController();

  late Future<List<Question>> _questionsFuture;
  int _currentPage = 0;
  Map<int, int> _selectedAnswer = {};
  List<AnswerQuiz> answer = [];

  bool _showResult = false;
  bool _isSubmit = false;

  @override
  void initState() {
    super.initState();
    _questionsFuture = _quizService.fetchQuestions(widget.quizId);
    if (widget.isViewQuizResult) _getAnswerOfQuiz();
  }

  Future<void> _getAnswerOfQuiz() async {
    final fetchedAnswers = await _quizResultController.getAnswersByResultId(widget.quizResultId!);
    setState(() => answer = fetchedAnswers);
  }

  void _nextPage(int totalPages) {
    if (_currentPage < totalPages - 1) {
      _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  Future<void> _checkAnswer(int selectedIndex, Question question, int questionIndex, int totalQuestions) async {
    _quizController.checkAnswer(selectedIndex, question.correctAnswerIndex);
    setState(() => _selectedAnswer[questionIndex] = selectedIndex);
    await Future.delayed(Duration(seconds: 3));

    if (_currentPage == totalQuestions - 1 && widget.saveProgress) {
      setState(() => _isSubmit = true);
      await _quizController.submitQuizResult(
        quizId: widget.quizId,
        userId: Users.currentUser?.id ?? 'unknown',
        questions: await _questionsFuture,
        selectedAnswers: _selectedAnswer,
      );
      setState(() {
        _isSubmit = false;
        _showResult = true;
      });
    } else {
      _nextPage(totalQuestions);
    }
  }

  Future<bool> _showExitConfirmationDialog() async {
    if (widget.isManageQuiz || widget.isViewQuizResult) return true;
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Thoát khỏi bài quiz?'),
        content: Text('Nếu bạn thoát, tiến độ làm bài sẽ không được lưu lại.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text('Ở lại')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text('Thoát')),
        ],
      ),
    ) ??
        false;
  }

  Widget _buildMedia(Question q) {
    if (q.mediaUrl == null) return SizedBox.shrink();
    if (q.mediaType == 'image') {
      return ClipRRect(
        child: Image.network(q.mediaUrl!, width: 230, height: 300, fit: BoxFit.cover),
      );
    } else if (q.mediaType == 'video') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: VideoPlayerWidget(videoUrl: q.mediaUrl!),
      );
    }
    return SizedBox.shrink();
  }

  Widget _buildAnswerOptions(Question q, int index, int totalQuestions) {
    return Column(
      children: List.generate(q.options.length, (i) {
        final isSelected = _selectedAnswer[index] == i;
        final isCorrect = q.correctAnswerIndex == i;
        Color btnColor = Colors.white;

        if (widget.isViewQuizResult) {
          final userAnswer = answer.firstWhere(
                (a) => a.questionId == q.questionId,
            orElse: () => AnswerQuiz.empty(q.questionId),
          ).userAnswer;
          if (i == q.correctAnswerIndex) {
            btnColor = Colors.green;
          } else if (i == userAnswer && userAnswer != q.correctAnswerIndex) {
            btnColor = Colors.red;
          }
        } else if (widget.isManageQuiz) {
          btnColor = isCorrect ? Colors.green : Colors.white;
        } else if (_selectedAnswer.containsKey(index)) {
          if (isSelected && isCorrect) btnColor = Colors.green;
          else if (isSelected && !isCorrect) btnColor = Colors.red;
          else if (isCorrect) btnColor = Colors.green;
        }

        return Answerquiz(
          textAnswer: q.options[i],
          color: btnColor,
          onPressed: widget.isManageQuiz || widget.isViewQuizResult
              ? null
              : _selectedAnswer.containsKey(index)
              ? () {}
              : () => _checkAnswer(i, q, index, totalQuestions),
        );
      }),
    );
  }

  Widget _buildResult(List<Question> questions) {
    final result = _quizController.calculateScore(
      questions: questions,
      selectedAnswers: _selectedAnswer,
    );
    final correctCount = result['answers']
        .where((a) => (a as Map<String, dynamic>)['isCorrect'] == true)
        .length;
    final score = result['score'];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
        SizedBox(height: 20),
        Text("Complete the quiz!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Text("${score.toStringAsFixed(1)} / 10", style: TextStyle(fontSize: 24, color: Colors.red, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Text("Number of correct answers: $correctCount / ${questions.length}", style: TextStyle(fontSize: 20)),
        CustomButton(
          text: 'Back to quiz list',
          textColor: Colors.white,
          gradientColors: [Color(0xFFE53935), Color(0xFFFF7043)],
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _showExitConfirmationDialog,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: FutureBuilder<String>(
            future: _quizController.getQuizTitle(widget.quizId),
            builder: (context, snapshot) {
              final title = snapshot.data ?? "Đang tải...";
              return CustomAppBar(
                title: title,
                showBackButton: widget.isManageQuiz || widget.isViewQuizResult,
              );
            },
          ),
        ),
        body: FutureBuilder<List<Question>>(
          future: _questionsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
            if (snapshot.hasError) return Center(child: Text("Lỗi: \${snapshot.error}"));

            final questions = snapshot.data ?? [];
            return Column(
              children: [
                if (_isSubmit)
                  Expanded(child: Center(child: CircularProgressIndicator()))
                else
                  Expanded(
                    child: _showResult
                        ? Center(child: _buildResult(questions))
                        : PageView.builder(
                      controller: _pageController,
                      itemCount: questions.length,
                      onPageChanged: (index) => setState(() => _currentPage = index),
                      itemBuilder: (context, index) {
                        final q = questions[index];
                        return Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _buildMedia(q),
                              SizedBox(height: 20),
                              Text(q.questionText, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              SizedBox(height: 20),
                              _buildAnswerOptions(q, index, questions.length),
                              if (widget.isManageQuiz || widget.isViewQuizResult)
                                Spacer(),
                              if (widget.isManageQuiz || widget.isViewQuizResult)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (_currentPage > 0)
                                      ElevatedButton(
                                        onPressed: _prevPage,
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                          backgroundColor: Color(0xFFFFD1BF),
                                          padding: EdgeInsets.all(12),
                                        ),
                                        child: Icon(Icons.arrow_back, color: Colors.black),
                                      ),
                                    if (_currentPage < questions.length - 1)
                                      ElevatedButton(
                                        onPressed: () => _nextPage(questions.length),
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                          backgroundColor: Color(0xFFFFD1BF),
                                          padding: EdgeInsets.all(12),
                                        ),
                                        child: Icon(Icons.arrow_forward, color: Colors.black),
                                      ),
                                  ],
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
