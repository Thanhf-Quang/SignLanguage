import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../models/quiz.dart';
import '../models/question.dart';

class QuizService{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// lấy quiz title
  Future<String> getQuizTitle(String quizId) async{
    final snapshot = await _firestore.collection('quizzes').doc(quizId).get();
    return snapshot.data()?['title'];
  }

  /// lấy tất cả quiz
  Future<List<Quiz>> getAllQuiz() async{
    final snapshot = await _firestore.collection('quizzes').get();
    return snapshot.docs.map((doc) {
      return Quiz.fromMap(doc.data()as Map<String,dynamic>, doc.id);
    }).toList();
  }

  /// lấy câu hỏi của 1 quiz
  Future<List<Question>> fetchQuestions(String quizId) async {
    final quizRef = _firestore.collection('quizzes').doc(quizId);
    final querySnapshot = await quizRef.collection('questions').get();

    return querySnapshot.docs.map((doc) {
      return Question.fromMap(doc.data(), doc.id);
    }).toList();
  }


  /// tạo 1 quiz
  Future<void> createQuiz(Quiz quiz, List<Question> questions) async{
    final quizRef = _firestore.collection('quizzes').doc(quiz.quizId);
    
    await quizRef.set(quiz.toMap());
    
    // luu tung cau hoi vao sub collection
    final questionCollection = quizRef.collection('questions');
    for(final question in questions){
      await questionCollection.doc(question.questionId).set(question.toMap());
    }
  }

  /// xoá 1 quiz
  Future<void> deleteQuizWithQuestions(String quizId) async {
    final quizRef = _firestore.collection('quizzes').doc(quizId);

    try {
      // Xoá tất cả documents trong subcollection 'questions'
      final questionsSnapshot = await quizRef.collection('questions').get();
      for (final questionDoc in questionsSnapshot.docs) {
        await questionDoc.reference.delete();
      }

      final quizResults = await _firestore
          .collection('quizResult')
          .where('quizId', isEqualTo: quizId)
          .get();

      for (final result in quizResults.docs) {
        // Xoá subcollection answer trong từng quizResult
        final answers = await result.reference.collection('answer').get();
        for (final ans in answers.docs) {
          await ans.reference.delete();
        }
        await result.reference.delete();
      }

      // Xoá document chính trong collection 'quizzes'
      await quizRef.delete();
    } catch (e) {
      rethrow;
    }
  }

  /// luu bai quiz da lam vao firebase
  Future<void> saveQuizResult(
      {
        required String userId,
        required String quizId,
        required double score,
        required int totalAnswer,
        required List<Map<String, dynamic>> answers,
      }) async{

    ///  add quiz vao quizResult
    final resultQuiz = await _firestore.collection('quizResult').add({
      'userId': userId,
      'quizId': quizId,
      'score': score,
      'totalAnswer': totalAnswer,
      'correctAnswer': score,
      'completedAt': FieldValue.serverTimestamp(),
    });

    /// add question vao answer collection
    final answerCollection = resultQuiz.collection('answer');
    for (final ans in answers) {
      await answerCollection.add({
        'questionId': ans['questionId'],
        'userAnswer': ans['userAnswer'],
        'correctAnswer': ans['correctAnswer'],
        'isCorrect': ans['isCorrect'],
      });
    }
  }

  /// lấy quiz list theo user id
  Future<List<Quiz>> getListQuizByUserId(String userId) async{
    try {
      final snapshot = await _firestore.collection('quizzes')
          .where('createBy', isEqualTo: userId)
          .get();

      return snapshot.docs.map((doc) {
        return Quiz.fromMap(doc.data()as Map<String,dynamic>, doc.id);
      }).toList();
    } catch (e) {
      debugPrint('Error getting quizzes for user $userId: $e');
      return [];
    }
  }
}

