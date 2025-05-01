// screens/verify_email_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hand_sign/controllers/RegisterController.dart';
import '../login/login.dart';
import '../quiz/QuizScreen.dart';
import '../../widgets/custom/CustomAppBar.dart';
import '../../services/EmailService.dart';
import '../register/registerScreen.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;
  final String name;
  final String phone;
  final String password;

  const VerifyEmailScreen({super.key, required this.email,required this.name,required this.phone,required this.password});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final EmailService _emailService = EmailService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isEmailVerified = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    checkEmailVerified();
  }

  Future<void> checkEmailVerified() async {
    await _auth.currentUser?.reload();
    setState(() {
      isEmailVerified = _auth.currentUser?.emailVerified ?? false;
    });

    if (isEmailVerified) {
      final uid = _auth.currentUser!.uid;
      await RegisterController.saveUserAfterEmailVerified(
          uid: uid,
          email: widget.email,
          name: widget.name,
          phone: widget.phone,
          password: widget.password
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng ký thành công!')),
      );
      //chuyển hướng login
      Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
    }
  }

  Future<void> resendEmail() async {
    setState(() => isLoading = true);

    await _emailService.sendVerificationEmail();
    setState(() => isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã gửi lại email xác thực!')),
    );
  }

  Future<void> cancelAndRestart() async {
    await _auth.currentUser?.delete();
    await _auth.signOut();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) =>  RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Xác thực email"),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ' Chúng tôi đã gửi một email xác thực đến:',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(widget.email, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Image.asset("assets/images/email-sending.jfif", height: 361, width: 433,),
            _buildOption(
                textQuestion: "Không nhận được email?",
                textAction: "Gửi lại email xác thực",
                onPressed: isLoading ? null : resendEmail,
            ),
            _buildOption(
              textQuestion: "Bạn đã xác thực?",
              textAction: "Đã xác thực",
              onPressed: checkEmailVerified,
            ),
            _buildOption(
              textQuestion: "Email không đúng?",
              textAction: "Đăng ký lại",
              onPressed: cancelAndRestart,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required String textQuestion,
    required String textAction,
    required VoidCallback? onPressed,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(textQuestion),
        TextButton(
          onPressed: onPressed,
          child: Text(
            textAction,
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

}
