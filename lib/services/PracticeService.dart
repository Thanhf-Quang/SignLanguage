import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/PracticeTopic.dart';
import '../models/StudyItem.dart';

class PracticeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<PracticeTopic>> fetchAllTopics() async {
    try {
      final snapshot = await _firestore.collection('PracticeTopics').get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return PracticeTopic.fromMap(data, doc.id);
      }).toList();
    } catch (e) {
      print('Lỗi khi lấy PracticeTopics: $e');
      return [];
    }
  }

  Future<PracticeTopic?> fetchTopicById(String id) async {
    try {
      final doc = await _firestore.collection('PracticeTopics').doc(id).get();
      if (doc.exists) {
        return PracticeTopic.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('Lỗi khi lấy PracticeTopic theo ID: $e');
      return null;
    }
  }

  Future<List<StudyItem>> getStudyItemsFromTopic(PracticeTopic topic) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('StudyItem')
          .where('itemID', whereIn: topic.keywordIds)
          .get();

      return querySnapshot.docs
          .map((doc) => StudyItem.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('Lỗi khi load StudyItems từ topic: $e');
      return [];
    }
  }

  // lấy thông tin của item ở màn hình TopicDetailScreen
  Future<StudyItem?> getItemForTopicDetail(String itemId) async {
    try {
      final query = await _firestore
          .collection('StudyItem')
          .where('itemID', isEqualTo: itemId)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        final data = query.docs.first.data();
        return StudyItem.fromMap(data);
      } else {
        print('Không tìm thấy item với ID: $itemId');
        return null;
      }
    } catch (e) {
      print('Lỗi khi lấy StudyItem theo ID: $e');
      return null;
    }
  }

}
