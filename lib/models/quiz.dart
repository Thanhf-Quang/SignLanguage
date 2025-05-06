import 'package:hand_sign/models/question.dart';

class Quiz{
  String quizId;
  String title;
  String typeOfQuiz;
  String createBy;

  Quiz({
    required this.quizId,
    required this.title,
    required this.typeOfQuiz,
    required this.createBy,
  });

  //chuyển từ firestore sang quiz
  factory Quiz.fromMap(Map<String, dynamic> map,String docId){
    return Quiz(
        quizId: docId,
        title: map['title'] ?? '',
        typeOfQuiz: map['typeOfQuiz'] ?? '',
        createBy: map['createBy'],
    );
  }

  //chuyển từ quiz thành firestore
  Map<String, dynamic> toMap(){
    return{
      'title': title,
      'typeOfQuiz': typeOfQuiz,
      'createBy': createBy
    };
  }
}