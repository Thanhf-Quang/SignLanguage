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
        throw Exception('This email address already exists.');
      }

      final encryptedPhone = encryptText(phone);

      /// lưu vào collection user
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'email': encryptedEmail,
        'phone': encryptedPhone,
        'name': name,
        'role': 'Student',
        'birthday': '',
        'avtURL': 'https://res.cloudinary.com/dmdcyhkkl/image/upload/v1746109808/oq4jbsjgqytaztschvhw.jpg' //sửa avtUrl mặc định ở đây
      });
    } catch(e){
      throw Exception(e.toString());
    }
  }
}