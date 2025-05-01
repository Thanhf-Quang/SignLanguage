import 'package:flutter/material.dart';
import '../../controllers/LoginController.dart';
import '../../services/EmailService.dart';
import '../../widgets/custom/customButton.dart';
import '../register/registerScreen.dart';
import '../login/forgotPassScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true; //ẩn mkhau

  final  LoginController _loginController = LoginController();

  void handleLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập đầy đủ email và mật khẩu.')),
      );
      return;
    }

    _loginController.login(context, email, password);
  }

  void resetPassword(String email){
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if(!emailRegex.hasMatch(email)){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email không hợp lệ!")),
      );
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_)=>ForgotPassScreen(emailAccount: email,)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFE53935),
                Color(0xFFFF7043),
              ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 180,),
            const Text(
              "HI, PLEASE LOGIN!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 60,),

            Expanded(
                child: Container(
                  padding: const EdgeInsets.all(40),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40),),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildInputField(Icons.phone, "Enter your email"),
                      const SizedBox(height: 20,),
                      _buildPasswordField(),
                      Align(
                        alignment: Alignment.centerRight,
                        //forgot button
                        child: TextButton(
                            onPressed: () => resetPassword(_emailController.text.trim()),
                            child: const Text("Quên mật khẩu?",style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),)
                        ),
                        ),
                      const SizedBox(height: 20,),

                      //button login
                      CustomButton(
                          text: "Login",
                          textColor: Colors.white,
                          gradientColors: [Color(0xFFE53935), Color(0xFFFF7043)],
                          onPressed: handleLogin
                      ),

                      const Spacer(),
                      //signup
                      _buildSignupText(),
                    ],
                  ),
                )
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(IconData icon, String hintText) {
    return TextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.redAccent),
        hintText: hintText,
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFFF3300)),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock, color: Colors.redAccent),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        hintText: "Enter your password",
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFFF3300)),
        ),
      ),
    );
  }

  Widget _buildSignupText(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Chưa có tài khoản?"),
        TextButton(
           // handle event register
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterScreen())
              );
            }, 
            child: const Text("Đăng ký",style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),))
      ],
    );
  }
}