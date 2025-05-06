import 'package:cloud_firestore/cloud_firestore.dart';

class DictionaryService {

  static Future<List<Map<String, dynamic>>> searchWord(String keyword) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('StudyItem')
        .where('keyword', isGreaterThanOrEqualTo: keyword)
        .where('keyword', isLessThanOrEqualTo: keyword + '\uf8ff')
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
