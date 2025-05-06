import 'package:cloud_firestore/cloud_firestore.dart';

class StudySet {
  final String firebaseId; // document ID từ Firestore
  final String id;         // id trong document
  final String title;
  final String category;
  final DateTime createAt;
  final String createBy;
  final bool isPublic;
  final List<String> studyItems;
  List<double>? scores;
  String? statement;

  StudySet({
    required this.firebaseId,
    required this.id,
    required this.title,
    required this.category,
    required this.createAt,
    required this.createBy,
    required this.isPublic,
    required this.studyItems,
    this.scores,
    this.statement,
  });

  factory StudySet.fromMap(String firebaseId, Map<String, dynamic> data) {
    return StudySet(
      firebaseId: firebaseId,
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      category: data['category'] ?? '',
      createAt: (data['createAt'] as Timestamp).toDate(),
      createBy: data['createBy'] ?? '',
      isPublic: data['isPublic'] ?? false,
      studyItems: List<String>.from(data['studyItems'] ?? []),
      scores: (data['scores'] as List?)?.map((e) => (e as num).toDouble()).toList(),
      statement: data['statement'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'createAt': createAt,
      'createBy': createBy,
      'isPublic': isPublic,
      'studyItems': studyItems,
      'scores': scores,
      'statement': statement,
    };
  }
}
