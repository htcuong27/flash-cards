class FlashCard {
  final int? id;
  final String word;
  final String meaning;
  final String example;
  final int level;
  final DateTime? nextReviewAt;

  FlashCard({
    this.id,
    required this.word,
    required this.meaning,
    required this.example,
    this.level = 1,
    this.nextReviewAt,
  });

  factory FlashCard.fromJson(Map<String, dynamic> json) {
    return FlashCard(
      id: json['id'] as int?,
      word: json['word'] as String,
      meaning: json['meaning'] as String? ?? '',
      example: json['example'] as String? ?? '',
      level: json['level'] as int? ?? 1,
      nextReviewAt: json['next_review_at'] != null
          ? DateTime.parse(json['next_review_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'meaning': meaning,
      'example': example,
      'level': level,
      if (nextReviewAt != null) 'next_review_at': nextReviewAt!.toIso8601String(),
    };
  }
}
