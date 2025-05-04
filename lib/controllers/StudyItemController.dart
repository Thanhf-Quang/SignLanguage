import '../Model/StudyItem.dart';
import '../Services/StudyItemService.dart';

class StudyItemController {
  final StudyItemService _service = StudyItemService();

  Future<List<StudyItem>> getAllItems() => _service.fetchAllItems();
  Future<List<StudyItem>> searchItems(String keyword) => _service.searchItems(keyword);
}
