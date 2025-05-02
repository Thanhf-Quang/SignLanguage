import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_auth/email_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../constants/Encryption.dart';

class EmailService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// gửi email khi đăng ký
   Future<void> sendVerificationEmail() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      try {
        await user.sendEmailVerification();
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case 'invalid-email':
            throw Exception('Invalid email address.');
          case 'user-not-found':
            throw Exception('No account found with this email.');
          case 'too-many-requests':
            throw Exception(
                'Too many requests. Please try again later.');
          default:
            throw Exception('Unknown error: ${e.message}');
        }
      }
    }
  }

  /// Gửi email khôi phục mật khẩu
   Future<void> sendPasswordResetEmail(String email) async {
     try {
       await _auth.sendPasswordResetEmail(email: email);
     } on FirebaseAuthException catch (e) {
       switch (e.code) {
         case 'invalid-email':
           throw Exception('Invalid email address.');
         case 'user-not-found':
           throw Exception('No account found with this email.');
         case 'too-many-requests':
           throw Exception('Too many requests. Please try again later.');
         default:
           throw Exception('Unknown error: ${e.message}');
       }
     }
  }

  // kiểm tra email có tồn tại firebase auth
  Future<bool> doesEmailExist(String email) async {
    final encryptedEmail = encryptText(email);
    //kiểm tra email đã tồn tại chưa
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: encryptedEmail)
        .get();

    return snapshot.docs.isNotEmpty;
  }
}
