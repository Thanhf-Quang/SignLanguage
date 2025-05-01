import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import './UserServices.dart';
import '../models/Users.dart';
import '../constants/Encryption.dart';
class LoginService {

  static Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      //set user model
      final user = await UserService().setCurrentUser();
      if (user != null) {
        Users.currentUser = user;
        // final isPasswordValid = await checkPassword(password, user.passwordHash);
        // if (isPasswordValid) {
          debugPrint("User UID: ${Users.currentUser?.id}");
          debugPrint("User Email: ${Users.currentUser?.email}");
          debugPrint("User name: ${Users.currentUser?.username}");
          debugPrint("User phone: ${Users.currentUser?.phone}");
          debugPrint("User Role: ${Users.currentUser?.role}");

        // } else {
        //   throw Exception("Mật khẩu không chính xác");
        // }
      }

    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseAuthError(e));
    }
  }

  static String _mapFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Không tìm thấy tài khoản với email này.';
      case 'wrong-password':
        return 'Mật khẩu không chính xác.';
      case 'invalid-email':
        return 'Email không hợp lệ.';
      case 'user-disabled':
        return 'Tài khoản này đã bị vô hiệu hóa.';
      case 'invalid-credential':
        return 'Thông tin đăng nhập không chính xác!';
      default:
        return 'Lỗi đăng nhập: ${e.message}';
    }
  }

}
