import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../controllers/edit_profile_controller.dart';
import '../models/User.dart';

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

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await controller.loadUserProfile();
    if (user != null) {
      setState(() {
        _user = user;
        nameController.text = user.username;
        phoneController.text = user.phone;
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
          _user = _user?.copyWith(avtURL: imageUrl);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cập nhật ảnh đại diện thành công!')),
        );
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
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      // Giao diện khi chưa đăng nhập
      return Scaffold(
        backgroundColor: Color(0xFFFFFCF3),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xFFFFFCF3),
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
                  "Bạn chưa đăng nhập",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Vui lòng đăng nhập hoặc đăng ký nếu bạn chưa có tài khoản.",
                  style: TextStyle(color: Colors.grey[700],),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                buildGradientButton(
                  text: "Đăng Nhập",
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                ),
                SizedBox(height: 10),
                Text("Hoặc", style: TextStyle(color: Colors.grey[700],),),
                SizedBox(height: 10),
                buildGradientButton(
                  text: "Đăng Ký",
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
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
      backgroundColor: Color(0xFFFFFCF3),
      appBar: AppBar(
        title: Text('Hồ Sơ', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Color(0xFFFFFCF3),
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
                  Text(nameController.text.isNotEmpty ? nameController.text : 'Tên người dùng',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(_user?.email ?? 'example@gmail.com', style: TextStyle(fontSize: 15)),
                  Text(phoneController.text.isNotEmpty ? phoneController.text : 'Số điện thoại',
                      style: TextStyle(fontSize: 15)),

                  //Phần chỉnh sửa và yêu thích
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit,
                            color: isEditing ? Color(0xFFFF721A) : Colors.grey),
                        onPressed: () => setState(() => isEditing = true),
                      ),
                      IconButton(
                        icon: Icon(Icons.favorite,
                            color: !isEditing ? Color(0xFFFF721A) : Colors.grey),
                        onPressed: () => setState(() => isEditing = false),
                      ),
                    ],
                  ),
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
              child: buildGradientButton(
                text: 'Lưu',
                onPressed: () async {
                  await controller.updateUserProfile(
                      nameController.text, phoneController.text);
                  await _loadUser();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Đã lưu thông tin thành công!')),
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
          Text("Tên:", style: TextStyle(fontSize: 16)),
          TextField(controller: nameController, decoration: InputDecoration(hintText: 'Nhập tên')),
          SizedBox(height: 16),
          Text("Số điện thoại:", style: TextStyle(fontSize: 16)),
          TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(hintText: 'Nhập số điện thoại')),
          SizedBox(height: 16),
          Text("Ảnh đại diện:", style: TextStyle(fontSize: 16)),
          SizedBox(height: 8),
          Center(
            child: ElevatedButton.icon(
              onPressed: _pickImageAndUpload,
              icon: Icon(Icons.photo_library, color: Colors.white),
              label: Text('Chọn ảnh từ thư viện'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF721A),
                foregroundColor: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget buildFavoritePage() {
    return Center(
      key: ValueKey('favoritePage'),
      child: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Text("Đây là trang yêu thích", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
