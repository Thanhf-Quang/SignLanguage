import '../models/StudyItem.dart';
import '../services/StudySetService.dart';
import '../services/StudyItemService.dart';
import '../models/StudySet.dart';

class StudySetController {
  final StudySetService _studySetService = StudySetService();
  final StudyItemService _studyItemService = StudyItemService();

  // Lấy StudySet theo id
  Future<StudySet?> getStudySetById(String id) {
    return _studySetService.getStudySetById(id);
  }

  // Lấy danh sách StudyItem theo studySet
  Future<List<StudyItem>> getItemsFromSet(StudySet set) {
    return _studyItemService.getItemsByIds(set.studyItems);
  }
}
