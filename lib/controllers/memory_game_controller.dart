import 'dart:async';
import '../models/CardItem.dart';
import '../controllers/LevelManager.dart';

class MemoryGameController {
  final List<String> _letters = ['A', 'B', 'C', 'D', 'E', 'F', 'L', 'V'];

  late List<CardItem> shuffled;
  List<bool> revealed = [];
  List<int> selectedIndexes = [];
  bool allowInteraction = true;
  bool gameCompleted = false;

  final void Function() onUpdate;

  MemoryGameController({required this.onUpdate}) {
    startGame();
  }

  void startGame() {
    List<CardItem> cards = [];
    for (var letter in _letters) {
      cards.add(CardItem(content: letter, isImage: false));
      cards.add(CardItem(content: 'assets/images/$letter.png', isImage: true));
    }

    cards.shuffle();
    shuffled = cards;
    revealed = List.generate(shuffled.length, (_) => false);
    selectedIndexes.clear();
    allowInteraction = true;
    gameCompleted = false;
    onUpdate();
  }

  void onTileTap(int index) {
    if (!allowInteraction || revealed[index] || selectedIndexes.contains(index)) return;

    selectedIndexes.add(index);
    onUpdate();

    if (selectedIndexes.length == 2) {
      allowInteraction = false;
      Timer(Duration(milliseconds: 1000), () {
        final first = shuffled[selectedIndexes[0]];
        final second = shuffled[selectedIndexes[1]];
        final isMatch = (first.isImage != second.isImage) &&
            (first.key == second.key);

        if (isMatch) {
          revealed[selectedIndexes[0]] = true;
          revealed[selectedIndexes[1]] = true;
        }

        selectedIndexes.clear();
        allowInteraction = true;

        if (revealed.every((e) => e)) {
          gameCompleted = true;
          LevelManager.unlockLevel(3);
        }

        onUpdate();
      });
    }
  }
}
