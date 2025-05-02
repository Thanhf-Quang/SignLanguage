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
        return 'No account found with this email address.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'invalid-credential':
        return 'Incorrect login information!';
      default:
        return 'Login error: ${e.message}';
    }
  }

}
