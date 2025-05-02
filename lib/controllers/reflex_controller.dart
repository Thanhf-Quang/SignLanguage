import 'dart:async';
import 'dart:ui';
import '../models/Reflex.dart';

class ReflexController {
  final ReflexModel model;
  late VoidCallback onTimeUp;
  late Function(bool) onAnswer;

  Timer? _timer;
  int timeLeft = 5;

  ReflexController(this.model);

  void startRound(VoidCallback updateView) {
    if (model.isFinished) return;

    timeLeft = 5;
    model.generateNewLetter();
    model.nextRound();

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      timeLeft--;
      updateView();
      if (timeLeft == 0) {
        timer.cancel();
        onTimeUp();
      }
    });
  }


  void stopTimer() {
    _timer?.cancel();
  }

  void checkAnswer(String selectedLetter) {
    bool correct = selectedLetter == model.currentLetter;
    if (correct) model.score++;
    stopTimer();
    onAnswer(correct);
  }
}
