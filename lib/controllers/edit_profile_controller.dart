import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import '../models/Users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/Encryption.dart';

class EditProfileController {
  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('users');
  //final String userId = 'userId'; // giả lập
  String get userId => FirebaseAuth.instance.currentUser?.uid ?? '';

  final ImagePicker _picker = ImagePicker();

  Future<Users?> loadUserProfile() async {
    final doc = await usersCollection.doc(userId).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;

      // Giải mã email và phone nếu bị mã hóa
      final decryptedEmail = decryptText(data['email']);
      final decryptedPhone = decryptText(data['phone']);

      return Users.fromMap({
        'uid': userId,
        'name': data['name'],
        'email': decryptedEmail,
        'phone': decryptedPhone,
        'role': data['role'],
        'birthday': data['birthday'],
        'avtURL': data['avtURL'],
      });
    }
    return null;
  }


  Future<Users?> updateUserProfile(String name, String phone, String birthday, String role) async {
    final encryptedPhone = encryptText(phone);
    await usersCollection.doc(userId).update({
      'name': name,
      'phone': encryptedPhone,
      'birthday': birthday,
      'role': role,
    });

    // Lấy lại bản ghi mới sau khi update
    final doc = await usersCollection.doc(userId).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      final decryptedEmail = decryptText(data['email']);
      final decryptedPhone = decryptText(data['phone']);

      return Users.fromMap({
        'uid': userId,
        'name': data['name'],
        'email': decryptedEmail,
        'phone': decryptedPhone,
        'role': data['role'],
        'birthday': data['birthday'],
        'avtURL': data['avtURL'],
      });
    }
    return null;
  }

  Future<String?> uploadImageToCloudinary(File imageFile) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dmdcyhkkl/image/upload');
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'handsign'
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final jsonData = json.decode(responseData);
      return jsonData['secure_url'];
    } else {
      return null;
    }
  }

  Future<File?> pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<void> updateAvatarUrl(String imageUrl) async {
    await usersCollection.doc(userId).update({
      'avtURL': imageUrl,
    });
  }
}
