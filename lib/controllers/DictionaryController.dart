import 'package:flutter/material.dart';
import 'package:hand_sign/services/DictionaryService.dart';

class DictionaryController extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> results = [];

  Future<void> search() async {
    final keyword = searchController.text.trim();
    if (keyword.isNotEmpty) {
      results = await DictionaryService.searchWord(keyword);
      notifyListeners();
    }
  }

  void clearResults() {
    results.clear();
    notifyListeners();
  }
}
