import 'package:flutter/material.dart';
import 'package:hand_sign/models/Users.dart';
import 'package:provider/provider.dart';
import '../../controllers/QuizListController.dart';
import '../../models/quiz.dart';
import '../../widgets/custom/DialogHelper.dart';
import '../../widgets/custom/QuizItemManage.dart';
import '../../widgets/custom/CustomAppBar.dart';
import './QuizTest.dart'; // Đảm bảo đường dẫn đúng

class ManageQuizScreen extends StatelessWidget {
  final String idUser;

  const ManageQuizScreen({required this.idUser});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => QuizListController()..loadQuizByUserId(idUser),
      child: Scaffold(
       backgroundColor: Colors.white,
       appBar: CustomAppBar(title: "Manage Quiz Created"),
       body: Consumer<QuizListController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          final filteredQuizzes = controller.filteredQuizzes;

          final colorsOption = [
            Color(0xFFDDF9FF),
            Color(0xFFFF7996),
            Color(0xFFFFE8E3),
            Color(0xFFE4FFE8),
            Color(0xFFF5E4FF),
          ];

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
            child: controller.allQuizzes.isEmpty
            ? Center(child: Text("You doesn't create any quiz!"),)
            : filteredQuizzes.isEmpty
                ? Center(child: Text("Dont have any quiz match with!"))
                : ListView.builder(
                 itemCount: filteredQuizzes.length,
                 itemBuilder: (context, index) {
                  final quiz = filteredQuizzes[index];
                  return QuizItemViewOnly(
                    title: quiz.title,
                    color: colorsOption[index % colorsOption.length],
                     onTap: () {
                     // Chuyển sang trang xem chi tiết quiz (chỉ xem)
                     Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuizTest(quizId: quiz.quizId, isManageQuiz: true,),
                      ),
                    );
                  },
                  onDelete: () async {
                    DialogHelper.showConfirmDialog(
                      context: context,
                      title: "Delete quiz?",
                      message: "Are you sure to delete a quiz?",
                      confirmText: "Delete",
                      onConfirm: () {
                         controller.deleteQuiz(quiz.quizId);
                       },
                    );
                  },
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