import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sign_language_app/Model/StudyItem.dart';

class StudyItemService {
  final CollectionReference _itemRef = FirebaseFirestore.instance.collection('StudyItem');

  // Lấy list studyItem
  Future<List<StudyItem>> fetchAllItems() async {
    final snapshot = await _itemRef.get();
    return snapshot.docs.map((doc) {
      return StudyItem.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  // Lọc item theo từ khóa tìm kiếm
  Future<List<StudyItem>> searchItems(String keyword) async {
    final snapshot = await _itemRef
        .where('keyword', isGreaterThanOrEqualTo: keyword)
        .where('keyword', isLessThanOrEqualTo: keyword + '\uf8ff')
        .get();

    return snapshot.docs.map((doc) {
      return StudyItem.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }
}