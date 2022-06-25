class AcceptedWords {
  final String word;
  final int score;
  int order = 0;
  static int totalScore = 0;
  static int totalWordCount = 0;
  AcceptedWords({required this.word, required this.score}) {
    totalScore += score;
    order = totalWordCount++;
  }
}
