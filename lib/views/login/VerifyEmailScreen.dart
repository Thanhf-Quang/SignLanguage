// screens/verify_email_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hand_sign/controllers/RegisterController.dart';
import '../login/login.dart';
//import '../quiz/QuizScreen.dart';
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
  }

  Future<void> checkEmailVerified() async {
    final user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not found.')),
      );
      return;
    }
    await user.reload(); // reload trạng thái từ server
    final refreshedUser = _auth.currentUser; // lấy lại user sau reload

    setState(() {
      isEmailVerified = refreshedUser?.emailVerified ?? false;
    });

    debugPrint("Email: ${refreshedUser?.email}, Verified: $isEmailVerified"); // debug nếu cần

    if (isEmailVerified) {
      final uid = refreshedUser!.uid;
      await RegisterController.saveUserAfterEmailVerified(
        uid: uid,
        email: widget.email,
        name: widget.name,
        phone: widget.phone,
        password: widget.password,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful!')),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
            (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your email address is not verified!')),
      );
    }
  }

  Future<void> resendEmail() async {
    setState(() => isLoading = true);

   try {
      await _emailService.sendVerificationEmail();
      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification email resent!')),
      );
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll("Exception: ", "")))
      );
    }
  }

  Future<void> cancelAndRestart() async {
    try {
      await _auth.currentUser?.delete();
    } catch (e) {
      debugPrint('Error deleting user: $e');
    }
    await _auth.signOut();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) =>  RegisterScreen()),
    );
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Email Verification", showBackButton: false,),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'We have sent a verification email to:',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(widget.email, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Image.asset("assets/images/email-sending.jfif", height: 361, width: 433,),
            _buildOption(
                textQuestion: "Didn't receive the email?",
                textAction: "Resend verification email",
                onPressed: isLoading ? null : resendEmail,
            ),
            _buildOption(
              textQuestion: "Already verified?",
              textAction: "Verified",
              onPressed: checkEmailVerified,
            ),
            _buildOption(
              textQuestion: "Incorrect email?",
              textAction: "Register again",
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
