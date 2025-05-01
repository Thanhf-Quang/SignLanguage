import 'package:flutter/material.dart';
import '../../controllers/RegisterController.dart';
import '../login/login.dart';
import '../../widgets/custom/customButton.dart';

class RegisterScreen extends StatefulWidget {

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscurePassword = true;

  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();

  void checkValidInfor(
       String username,
       String phone,
       String email,
       String password,
       String rePass,
      ) async{

    final error = RegisterController.checkVailidInfor(username: username, phone: phone, email: email, password: password, rePass: rePass);

    if (error != null) {
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
       return;
    }

    try{
      await RegisterController.sendEmailVerify(context, username, phone, email, password);
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceFirst('Exception', ''))));
    }
    // RegisterController.sendOTPVerification(context, username, email);
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
            const SizedBox(height: 200),
            const Text(
              "TẠO TÀI KHOẢN",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildInputField(Icons.person, "Họ và tên", _usernameController),
                    const SizedBox(height: 20),
                    _buildInputField(Icons.phone, "Số điện thoại", _phoneController),
                    const SizedBox(height: 20),
                    _buildInputField(Icons.email, "Email", _emailController),
                    const SizedBox(height: 20),
                    _buildPasswordField("Mật khẩu", _passwordController),
                    const SizedBox(height: 20,),
                    _buildPasswordField("Xác nhận mật khẩu", _rePasswordController),
                    const SizedBox(height: 40,),
                    
                    //button
                    CustomButton(
                        text: "Đăng ký",
                        textColor: Colors.white, 
                        gradientColors: [Color(0xFFE53935), Color(0xFFFF7043)], 
                        onPressed: (){
                          checkValidInfor(
                              _usernameController.text,
                              _phoneController.text,
                              _emailController.text,
                              _passwordController.text,
                              _rePasswordController.text
                          );
                        }
                    ),
                    const SizedBox(height: 90,),
                    _buildSigninText(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(IconData icon, String hintText, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.redAccent),
        hintText: hintText,
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String hintText, TextEditingController controller) {
    return TextField(
      obscureText: _obscurePassword,
      controller: controller,
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
        hintText: hintText,
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }

  Widget _buildSigninText(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Have an account?"),
        TextButton(
          // handle event register
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen())
              );
            },
            child: const Text("Login",style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),))
      ],
    );
  }
}
