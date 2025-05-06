import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/QuizListController.dart';
import '../../models/Users.dart';
import '../../widgets/custom/DialogHelper.dart';
import '../../widgets/custom/QuizItem.dart';
import '../../widgets/custom/CustomAppBar.dart';
import '../login/login.dart';
import './CreateQuizPage.dart';
import './ManageQuiz.dart';
import './QuizTest.dart';
import '../../controllers/QuizResultController.dart';

class QuizScreen extends StatelessWidget {
  final List<Color> colorsOption = const [
    Color(0xFFDDF9FF),
    Color(0xFFFF7996),
    Color(0xFFFFE8E3),
    Color(0xFFE4FFE8),
    Color(0xFFF5E4FF),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuizListController()..loadData(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(title: "List quiz"),
        body: Consumer<QuizListController>(
          builder: (context, controller, _) {
            if (controller.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: DropdownButton<String>(
                    value: controller.selectedType,
                    hint: Text("All"),
                    isExpanded: true,
                    items: ['All', ...controller.quizTypes].map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: controller.setSelectedType,
                  ),
                ),
                Expanded(
                  child: controller.filteredQuizzes.isEmpty
                      ? Center(child: Text("Don't have any match!"))
                      : ListView.builder(
                       itemCount: controller.filteredQuizzes.length,
                       itemBuilder: (context, index) {
                       final quiz = controller.filteredQuizzes[index];
                       final score = controller.resultScore[quiz.quizId] ?? 0;

                       return QuizItem(
                        title: quiz.title,
                        score: score,
                        color: colorsOption[index % colorsOption.length],
                        onPressed: () => _checkUserLogin(context, quiz.quizId),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
        floatingActionButton: Consumer<QuizListController>(
          builder: (context, controller, _) {
            if (!controller.isTeacher) return SizedBox.shrink();
            return Column(
                 mainAxisSize: MainAxisSize.min,
                 children: [
                   FloatingActionButton(
                   heroTag: 'fab_manage',
                   backgroundColor: Color(0xFFFFD1BF),
                   child: Icon(Icons.note, color: Colors.black),
                   onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ManageQuizScreen(idUser: Users.currentUser!.id),
                      ),
                    );
                    if (result == true) {
                      controller.loadData();
                    }
                  },
                ),
                SizedBox(height: 12),
                FloatingActionButton(
                  heroTag: 'fab_add',
                  backgroundColor: Color(0xFFFFD1BF),
                  child: Icon(Icons.add, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CreateQuizPage()),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _checkUserLogin(BuildContext context, String quizId) {
    final controller = Provider.of<QuizListController>(context, listen: false);
    final user = Users.currentUser;

    if (user == null) {
      DialogHelper.showConfirmDialog(
        context: context,
        title: 'You are not logged in.',
        message: 'Do you want to log in to save your progress?',
        confirmText: 'Login',
        onConfirm: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen())),
        onCancel: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => QuizTest(
              quizId: quizId,
              saveProgress: false,
            ),
          ),
        ),
      );
    } else {
      final score = controller.resultScore[quizId] ?? 0;
      if (score > 0) {
        DialogHelper.showConfirmDialog(
          context: context,
          title: "Retest Quiz?",
          message: "You have already taken this quiz. Want to take it again?",
          confirmText: "Take again",
          onConfirm: () async {
            final quizResultId = await QuizResultController().getQuizResultId(quizId, user.id);
            if (quizResultId != null) {
              await QuizResultController().deleteQuizResult(quizResultId);
              _takeQuiz(context, quizId, controller);
            }
          },
          onCancel: () async {
            final quizResultId = await QuizResultController().getQuizResultId(quizId, user.id);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => QuizTest(
                  quizId: quizId,
                  quizResultId: quizResultId,
                  isViewQuizResult: true,
                ),
              ),
            );
          },
        );
      } else {
        _takeQuiz(context, quizId, controller);
      }
    }
  }

  void _takeQuiz(BuildContext context, String quizId, QuizListController controller) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizTest(
          quizId: quizId,
          saveProgress: true,
        ),
      ),
    );
    if (result == true) {
      controller.loadData();
    }
  }
}
