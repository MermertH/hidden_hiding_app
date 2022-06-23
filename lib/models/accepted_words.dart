class AcceptedWords {
  final String word;
  final int score;
  static int totalScore = 0;
  static int totalWordCount = 0;
  AcceptedWords({required this.word, required this.score}) {
    totalScore += score;
    totalWordCount++;
  }
}
