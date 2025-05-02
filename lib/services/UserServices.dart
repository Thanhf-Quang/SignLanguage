import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/Users.dart';
import '../constants/Encryption.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// set thông tin user cho model
  Future<Users?> setCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;

    // Giải mã
    final encryptedEmail = doc['email'];
    final encryptedPhone = doc['phone'];

    final decryptedEmail = decryptText(encryptedEmail);
    final decryptedPhone = decryptText(encryptedPhone);

    return Users.fromMap({
      'uid': user.uid,
      'name': doc['name'],
      'email': decryptedEmail,
      'phone': decryptedPhone,
      'role': doc['role'],
      'birthday': doc['birthday'],
      'avtURL': doc['avtURL'],
    });
  }

}
