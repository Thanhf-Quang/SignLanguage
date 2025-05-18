import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../controllers/edit_profile_controller.dart';
import '../../models/Users.dart';
import 'package:intl/intl.dart';
import '../login/login.dart';
import '../register/registerScreen.dart';
import '../../controllers/LoginController.dart';
import '../Home/HomeScreen.dart';


class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final EditProfileController controller = EditProfileController();

  bool isEditing = true;
  File? _imageFile;
  Users? _user;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final birthdayController = TextEditingController();
  final LoginController _loginController = LoginController();
  String? selectedRole;
  String? email;


  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void resetPassword(String email){
    _loginController.resetPassword(email, context);
  }

  Future<void> _loadUser() async {
    final user = await controller.loadUserProfile();
    if (user != null) {
      setState(() {
        _user = user;
        nameController.text = user.username;
        phoneController.text = user.phone;
        birthdayController.text = user.birthday ?? '';
        selectedRole = user.role ?? 'Student';
        email = user.email;
        print("Thông tin ban đầu:");
        print("Name: ${user.username}");
        print("Email: ${user.email}");
        print("Phone: ${user.phone}");
        print("Birthday: ${user.birthday}");
        print("Role: ${user.role}");
      });
    }
  }

  Future<void> _pickImageAndUpload() async {
    final image = await controller.pickImageFromGallery();
    if (image != null) {
      final imageUrl = await controller.uploadImageToCloudinary(image);
      if (imageUrl != null) {
        await controller.updateAvatarUrl(imageUrl);
        setState(() {
          _imageFile = image;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image uploaded successfully!')),
        );
        await _loadUser();
      }
    }
  }

  Widget buildGradientButton({required String text, required VoidCallback onPressed}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFFE53935), Color(0xFFFF7043)]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14.0),
            child: Center(
              child: Text(text,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Users.currentUser;

    if (currentUser == null) {
      // Giao diện khi chưa đăng nhập
      return Scaffold(
        backgroundColor: Color(0xFFFFF8EE),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xFFFFF8EE),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline, // Hoặc Icons.person_off
                  size: 80.0,
                ),
                const SizedBox(height: 24.0),
                Text(
                  "You are not logged in",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Ready to explore? Log in or Sign upr.",
                  style: TextStyle(color: Colors.grey[700],),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                buildGradientButton(
                  text: "Login",
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                ),
                SizedBox(height: 10),
                Text("Or", style: TextStyle(color: Colors.grey[700],),),
                SizedBox(height: 10),
                buildGradientButton(
                  text: "Sign up",
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }

    final avatar = _imageFile != null
        ? FileImage(_imageFile!)
        : (_user?.avtURL != null
        ? NetworkImage(_user!.avtURL!)
        : AssetImage('assets/images/default_avatar.jpg')) as ImageProvider;

    return Scaffold(
      backgroundColor: Color(0xFFFFF8EE),
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Color(0xFFFFF8EE),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Color(0xFF4E3715)),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Color(0xFFFFF8EE),
                    title: const Text('Log Out',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),
                    content: const Text('Are you sure you want to log out?',textAlign: TextAlign.center),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            TextButton(
                              child: Text("No, stay logged in", style: TextStyle(color: Color(0xFF4E3715))),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF4E3715),
                              ),
                              child: Text("Yes, log out", style: TextStyle(color: Colors.white)),
                              onPressed: () async {
                                Users.currentUser = null;
                                Navigator.of(context).pop();
                                await FirebaseAuth.instance.signOut();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => HomeScreen()),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],

      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  CircleAvatar(radius: 60, backgroundImage: avatar),
                  SizedBox(height: 10),
                  Text(nameController.text.isNotEmpty ? nameController.text : '',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(_user?.role ?? '', style: TextStyle(fontSize: 15)),

                  //Phần chỉnh sửa và yêu thích
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     IconButton(
                  //       icon: Icon(Icons.edit,
                  //           color: isEditing ? Color(0xFFFF721A) : Colors.grey),
                  //       onPressed: () => setState(() => isEditing = true),
                  //     ),
                  //     IconButton(
                  //       icon: Icon(Icons.bookmark,
                  //           color: !isEditing ? Color(0xFFFF721A) : Colors.grey),
                  //       onPressed: () => setState(() => isEditing = false),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(height: 20),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 100),
                    child: isEditing ? buildEditForm() : buildFavoritePage(),
                  ),
                ],
              ),
            ),
          ),
          if (isEditing)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child:
              buildGradientButton(
                text: 'Save Changes',
                onPressed: () async {
                  final updatedUser = await controller.updateUserProfile(
                    nameController.text,
                    phoneController.text,
                    birthdayController.text,
                    selectedRole ?? 'Student',
                  );
                  if (updatedUser != null) {
                    Users.currentUser = updatedUser;
                  }
                  debugPrint("User id: ${Users.currentUser!.id}");
                  debugPrint("User role: ${Users.currentUser!.role}");
                  debugPrint("User id: ${Users.currentUser!.phone}");
                  debugPrint("User id: ${Users.currentUser!.birthday}");
                  await _loadUser();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Successfully updated profile!')),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget buildEditForm() {
    return Padding(
      key: ValueKey('editForm'),
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Name:", style: TextStyle(fontSize: 16)),
          TextField(controller: nameController, decoration: InputDecoration(hintText: 'Nhập tên')),
          SizedBox(height: 16),

          Text("Phone:", style: TextStyle(fontSize: 16)),
          TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(hintText: 'Nhập số điện thoại')),
          SizedBox(height: 16),

          Text("Birthday:", style: TextStyle(fontSize: 16)),
          TextField(
            controller: birthdayController,
            readOnly: true,
            decoration: InputDecoration(
              hintText: 'dd/mm/yyyy',
              suffixIcon: Icon(Icons.calendar_today),
            ),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime(2000),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );

              if (pickedDate != null) {
                String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                setState(() {
                  birthdayController.text = formattedDate;
                });
              }
            },
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Role',
                border: OutlineInputBorder(),
              ),
              value: selectedRole,
              items: ['Student', 'Teacher'].map((role) {
                return DropdownMenuItem(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedRole = value;
                });
              },
            ),
          ),

          Text("Avatar:", style: TextStyle(fontSize: 16)),
          Center(
            child: ElevatedButton.icon(
              onPressed: _pickImageAndUpload,
              icon: Icon(Icons.photo_library, color: Colors.white),
              label: Text('Select photo from library'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF721A),
                foregroundColor: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 11),

          Center(
            child: TextButton(
              onPressed: () {
                if (_user?.email != null) {
                  resetPassword(_user!.email!);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("User email not found!")),
                  );
                }
              },
              child: Text(
                "Reset Password",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget buildFavoritePage() {
    return Center(
      key: ValueKey('favoritePage'),
      child: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Text("Favorite Page", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
