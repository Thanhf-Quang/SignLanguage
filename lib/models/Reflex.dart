class ReflexModel {
  final List<String> letters = ['R', 'U', 'V', 'W'];
  late String currentLetter;
  int score = 0;
  int totalRounds = 5;
  int currentRound = 0;

  bool get isFinished => currentRound >= totalRounds;

  void nextRound() {
    currentRound++;
    generateNewLetter();
  }

  ReflexModel() {
    generateNewLetter();
  }

  void generateNewLetter() {
    letters.shuffle();
    currentLetter = letters.first;
  }
}
