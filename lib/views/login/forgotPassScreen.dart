import 'package:flutter/material.dart';
import '../../controllers/LoginController.dart';
import '../../widgets/custom/customButton.dart';

class ForgotPassScreen extends StatefulWidget {
  final String emailAccount;

  const ForgotPassScreen({super.key, required this.emailAccount});

  @override
  _ForgotPassScreenState createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  final _emailController = TextEditingController();
  final LoginController _loginController = LoginController();

  void _handleResetPassword() {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your email address.')),
      );
      return;
    }

    bool isSame = widget.emailAccount.trim().toLowerCase() == email.trim().toLowerCase();
    if(isSame){
      _loginController.resetPassword(email, context);
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please use your email address.')),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back, color: Colors.black,)
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
          padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "FORGOT PASSWORD?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.pinkAccent
              ),
            ),
            Text(
              "Please enter your email address to receive a password reset link.",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30,),
            _buildInputField(Icons.person, "Enter your email"),
            const SizedBox(height: 30,),
            CustomButton(
                text: "Submit",
                textColor: Colors.white,
                gradientColors: [Color(0xFFFF1A63), Color(0xFFFF8595)],
                onPressed: _handleResetPassword,
            ),
            const Spacer(),
            Image.asset("assets/images/background_2.png", height: 361, width: 433,)
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(IconData icon, String hintText){
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.redAccent,),
          hintText: hintText,
          border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey)
          )
      ),
    );
  }
}