import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  final String id;
  final String title;
  final String content;
  final DateTime? timestamp;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    this.timestamp,
  });

  factory NoteModel.fromDocument(Map<String, dynamic> doc, String id) {
    return NoteModel(
      id: id,
      title: doc['title'],
      content: doc['content'],
      timestamp: (doc['timestamp'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'timestamp': timestamp ?? DateTime.now(),
    };
  }
}
