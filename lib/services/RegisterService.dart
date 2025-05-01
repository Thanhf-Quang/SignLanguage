import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/Encryption.dart';

class RegisterService{

  static Future<void> saveUserToFirestore({
    required String uid,
    required String email,
    required String name,
    required String phone,
    required String password,
  }) async {
    try {
      final encryptedEmail = encryptText(email);
      //kiểm tra email đã tồn tại chưa
      final existingUsers = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: encryptedEmail)
          .get();

      if (existingUsers.docs.isNotEmpty) {
        throw Exception('Email này đã được đăng ký trước đó.');
      }

      final encryptedPhone = encryptText(phone);

      /// lưu vào collection user
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'email': encryptedEmail,
        'phone': encryptedPhone,
        'name': name,
        'role': 'student',
        'birthday': '',
        'avtURL': '' //sửa avtUrl mặc định ở đây
      });
    } catch(e){
      throw Exception(e.toString());
    }
  }
}