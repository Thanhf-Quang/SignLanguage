import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/StudyItem.dart';

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

  // ⚡ Lấy danh sách item theo danh sách ID
  Future<List<StudyItem>> getItemsByIds(List<String> ids) async {
    if (ids.isEmpty) return [];

    final List<StudyItem> result = [];

    for (int i = 0; i < ids.length; i += 10) {
      final chunk = ids.sublist(i, i + 10 > ids.length ? ids.length : i + 10);
      final snapshot = await _itemRef.where('itemID', whereIn: chunk).get();

      result.addAll(snapshot.docs.map((doc) =>
          StudyItem.fromMap(doc.data() as Map<String, dynamic>)));
    }

    return result;
  }
}