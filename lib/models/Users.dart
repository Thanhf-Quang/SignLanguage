import 'package:cloud_firestore/cloud_firestore.dart';

class Users{
  static Users? currentUser;

  final String id;
  final String username;
  final String email;
  final String phone;
  final String? avtURL;
  final String? birthday;
  final String? role;

  Users({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    this.avtURL,
    this.birthday,
    this.role,
  });

  factory Users.fromMap(Map<String, dynamic> data) {
    return Users(
      id: data['uid'],
      username: data['name'],
      email: data['email'],
      phone: data['phone'],
      role: data['role'],
      birthday: data['birthday'],
      avtURL: data['avtURL'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'phone': phone,
      'avtURL': avtURL ?? '',
      'birthday': birthday ?? '',
      'role': role ?? 'user',
    };
  }
}
