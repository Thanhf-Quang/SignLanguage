import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/Notes.dart';

class NotesController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId;

  NotesController({required this.userId});

  Stream<List<NoteModel>> getNotes() {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => NoteModel.fromDocument(doc.data(), doc.id))
        .toList());
  }

  Future<void> addNote(NoteModel note) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .add(note.toMap());
  }

  Future<void> updateNote(String id, NoteModel note) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(id)
        .update(note.toMap());
  }

  Future<void> deleteNote(String id) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(id)
        .delete();
  }
}
