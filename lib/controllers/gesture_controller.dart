import 'package:flutter/material.dart';
import '../models/GestureMatchingGame.dart';

class GestureController with ChangeNotifier {
  final GestureModel _model = GestureModel();
  Map<String, bool> matched = {};
  int score = 0;

  GestureController() {
    _model.gestureToWord.keys.forEach((key) {
      matched[key] = false;
    });
  }

  Map<String, String> get gestureToWord => _model.gestureToWord;

  void acceptMatch(String key) {
    matched[key] = true;
    score++;
    notifyListeners();
  }

  bool isMatched(String key) => matched[key] ?? false;

  bool isGameComplete() => score == _model.gestureToWord.length;
}
