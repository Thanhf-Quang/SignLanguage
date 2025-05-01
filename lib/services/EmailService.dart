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
      await user.sendEmailVerification();
    }
  }

  /// Gửi email khôi phục mật khẩu
   Future<void> sendPasswordResetEmail(String email) async {
     try {
       await _auth.sendPasswordResetEmail(email: email);
     } on FirebaseAuthException catch (e) {
       switch (e.code) {
         case 'invalid-email':
           throw Exception('Email không hợp lệ.');
         case 'user-not-found':
           throw Exception('Không tìm thấy tài khoản với email này.');
         case 'too-many-requests':
           throw Exception('Bạn đã gửi quá nhiều yêu cầu. Vui lòng thử lại sau.');
         default:
           throw Exception('Lỗi không xác định: ${e.message}');
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