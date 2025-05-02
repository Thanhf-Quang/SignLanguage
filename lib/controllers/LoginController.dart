import 'package:flutter/material.dart';
import '../../services/EmailService.dart';
import '../../services/LoginServices.dart';
import '../../views/login/login.dart';
import '../home.dart';



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
          SnackBar(content: Text("Invalid email address!")),
        );
        return;
      }

      await LoginService.loginUser(email: email, password: password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login successful!")),
      );
      //chuyển hướng màn hình chính
      Navigator.push(context, MaterialPageRoute(builder: (_)=> HomeScreen()));
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
          SnackBar(content: Text("Email not registered!"))
      );
      return;
    }

    try {
      await _emailService.sendPasswordResetEmail(email.trim().toLowerCase());
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Password reset email sent. Please check your inbox."))
      );
      Navigator.push(context, MaterialPageRoute(builder: (_)=> LoginScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll("Exception: ", "")))
      );
    }
  }


}
