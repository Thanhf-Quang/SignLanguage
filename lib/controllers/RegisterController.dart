import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/EmailService.dart';
import '../../services/RegisterService.dart';
import '../../views/login/VerifyEmailScreen.dart';
import 'package:intl/intl.dart';

class RegisterController{
  static const String companyName = 'QHN HandSignApp';

  //check signin field
  static String? checkVailidInfor({required String username,required String phone,required String email,required String password,required String rePass}){
    final usernameRegex = RegExp(r'^[a-zA-Z0-9]+$');
    final phoneRegex = RegExp(r'^0[0-9]+$');
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[\W_]).{6,}$');

    if(username.isEmpty || phone.isEmpty || email.isEmpty || password.isEmpty || rePass.isEmpty) {
      return "Vui lòng điền đầy đủ thông tin!";
    }

    if(!usernameRegex.hasMatch(username)){
      return "Username không được chứa ký tự đặc biệt";
    }

    if(!phoneRegex.hasMatch(phone)){
      return "Số điện thoại chỉ được chứa các chữ số!";
    }

    if(phone.length != 10){
      return "Độ dài số điện thoại chỉ được bằng 10!";
    }

    if (!emailRegex.hasMatch(email)) {
      return "Email không đúng định dạng.";
    }

    if (password != rePass) {
      return "Mật khẩu và xác nhận mật khẩu không khớp.";
    }

    if (!passwordRegex.hasMatch(password)) {
      return "Mật khẩu phải chứa ít nhất 1 chữ hoa, 1 chữ thường và 1 ký tự đặc biệt.";
    }

    if(password.length < 8 ){
      return "Mật khẩu phải chứa ít nhất 8 ký tự!";
    }
    return null;
  }


  static Future<void> sendEmailVerify(
      BuildContext context,
      String name,
      String phone,
      String email,
      String password,
      ) async {
    final EmailService emailService = EmailService();

    try{
      final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await emailService.sendVerificationEmail();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => VerifyEmailScreen(
            email: email,
            name: name,
            phone: phone,
            password: password,
          ),
        ),
      );
    }catch(e){
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  static Future<void> saveUserAfterEmailVerified({
    required String uid,
    required String email,
    required String name,
    required String phone,
    required String password,
  }) async {
    await RegisterService.saveUserToFirestore(uid: uid, email: email, name: name, phone: phone, password: password);
  }

  static void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

}