import 'package:flutter/material.dart';
import '../../services/EmailService.dart';
import '../../services/LoginServices.dart';
import '../../views/login/login.dart';
import '../../views/quiz/QuizScreen.dart';

class LoginController {
  final EmailService _emailService = EmailService();

  Future<void> login(
      BuildContext context,
      String email,
      String password,
      ) async {
    try {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if(!emailRegex.hasMatch(email)){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Email không hợp lệ!")),
        );
        return;
      }

      await LoginService.loginUser(email: email, password: password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đăng nhập thành công!")),
      );
      //chuyển hướng màn hình chính
      Navigator.push(context, MaterialPageRoute(builder: (_)=> QuizScreen()));
    } catch (e) {
      final message = e.toString().replaceFirst("Exception: ", "");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Future<void> resetPassword(String email, BuildContext context) async{
    if (!(await _emailService.doesEmailExist(email.trim().toLowerCase()))) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Email chua được đăng ký!"))
      );
      return;
    }

    try {
      await _emailService.sendPasswordResetEmail(email.trim().toLowerCase());
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Đã gửi email khôi phục mật khẩu. Vui lòng kiểm tra hộp thư."))
      );
      Navigator.push(context, MaterialPageRoute(builder: (_)=> LoginScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll("Exception: ", "")))
      );
    }
  }


}
