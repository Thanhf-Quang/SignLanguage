import '../models/PracticeTopic.dart';
import '../models/StudyItem.dart';
import '../services/PracticeService.dart';

class PracticeController {
  final PracticeService _service = PracticeService();

  Future<List<PracticeTopic>> fetchPracticeTopics() async {
    try {
      return await _service.fetchAllTopics();
    } catch (e) {
      print("Lỗi khi lấy danh sách PracticeTopics: $e");
      return [];
    }
  }
  Future<PracticeTopic?> loadTopicDetail(String topicId) async {
    return await _service.fetchTopicById(topicId);
  }

  Future<List<StudyItem>> loadStudyItemsFromTopic(PracticeTopic topic) async {
    return await _service.getStudyItemsFromTopic(topic);
  }

  Future<StudyItem?> loadStudyItemDetail(String itemId) async {
    try {
      return await _service.getItemForTopicDetail(itemId);
    } catch (e) {
      print("Lỗi khi lấy chi tiết StudyItem: $e");
      return null;
    }
  }


}
