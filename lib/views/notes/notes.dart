import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../login/login.dart';
import '../register/registerScreen.dart';
import '../../controllers/notes_controller.dart';
import '../../models/Notes.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? userId;
  late NotesController controller;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
      controller = NotesController(userId: userId!);
    }
  }


  void _showNoteDialog({NoteModel? note}) {
    if (note != null) {
      _titleController.text = note.title;
      _contentController.text = note.content;
    } else {
      _titleController.clear();
      _contentController.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Color(0xFFFFF8EE),
        title: Text(note != null ? 'Edit Notes' : 'Add Notes',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12),
                ),
              ),
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Content',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12),
                ),
              ),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style:TextStyle(color: Color(0xFF4E3715)),),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF4E3715),
            ),
            onPressed: () async {
              final title = _titleController.text.trim();
              final content = _contentController.text.trim();

              if (title.isEmpty || content.isEmpty) return;

              if (note != null) {
                controller.updateNote(
                  note.id,
                  NoteModel(id: note.id, title: title, content: content, timestamp: DateTime.now()),
                );
              } else {
                controller.addNote(
                    NoteModel(id: '', title: title, content: content, timestamp: DateTime.now()),
                );
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(note != null ? 'Note updated successfully' : 'Note added successfully', style: TextStyle(fontWeight: FontWeight.bold)),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );

              Navigator.pop(context);
            },
            child: const Text('Save', style:TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }


  Widget buildGradientButton({required String text, required VoidCallback onPressed}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFFE53935), Color(0xFFFF7043)]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14.0),
            child: Center(
              child: Text(text,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      // Giao diện khi chưa đăng nhập
      return Scaffold(
        backgroundColor: Color(0xFFFFF8EE),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xFFFFF8EE),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline, // Hoặc Icons.person_off
                  size: 80.0,
                ),
                const SizedBox(height: 24.0),
                Text(
                  "You are not logged in",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Ready to explore? Log in or Sign upr.",
                  style: TextStyle(color: Colors.grey[700],),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                buildGradientButton(
                  text: "Login",
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                ),
                SizedBox(height: 10),
                Text("Or", style: TextStyle(color: Colors.grey[700],),),
                SizedBox(height: 10),
                buildGradientButton(
                  text: "Sign up",
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }

    userId ??= currentUser.uid;

    Stream<List<NoteModel>> notesStream = controller.getNotes();

    return Scaffold(
      backgroundColor: Color(0xFFFFF8EE),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFF8EE),
        centerTitle: true,
        title: const Text('My Notes',
        style:TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: StreamBuilder<List<NoteModel>>(
        stream: controller.getNotes(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching notes.'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final notes = snapshot.data!;

          if (notes.isEmpty) {
            return const Center(child: Text('No notes yet.', style: TextStyle(fontSize: 20),));
          }

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return ListTile(
                title: Text(note.title, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                subtitle: Text(note.content, style: TextStyle(fontSize: 16, color: Color(0xFF4E3715))),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Color(0xFF2E1E03)),
                      onPressed: () => _showNoteDialog(note: note),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red,),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            backgroundColor: Color(0xFFFFF8EE),
                            title: const Text('Delete Note',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),
                            content: const Text('Do you want to delete this note?',textAlign: TextAlign.center),
                            actions: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text('No, cancel', style: TextStyle(color: Color(0xFF4E3715)),),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF4E3715),
                                      ),
                                      onPressed: () {
                                        controller.deleteNote(note.id);
                                        Navigator.of(context).pop();

                                        // Show snackbar
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Note deleted successfully', style: TextStyle(fontWeight: FontWeight.bold),),
                                            backgroundColor: Colors.red,
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      },
                                      child: const Text('Yes, delete',style: TextStyle(color: Colors.white),),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },

                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF4E3715),
        onPressed: () => _showNoteDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
