import 'package:hive/hive.dart';

part 'flashcard_model.g.dart';

@HiveType(typeId: 3)
class Flashcard {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String deckId; // REQUIRED for linking to a deck

  @HiveField(2)
  final String question;

  @HiveField(3)
  final String answer;

  @HiveField(4)
  final int interval; // For spaced repetition (default 1)

  @HiveField(5)
  final double easeFactor; // Default 2.5 for SM2 algorithm

  @HiveField(6)
  final DateTime? lastReviewed;

  @HiveField(7)
  final DateTime? nextReview;

  Flashcard({
    required this.id,
    required this.deckId,
    required this.question,
    required this.answer,
    this.interval = 1,
    this.easeFactor = 2.5,
    this.lastReviewed,
    this.nextReview,
  });

  Flashcard copyWith({
    String? id,
    String? deckId,
    String? question,
    String? answer,
    int? interval,
    double? easeFactor,
    DateTime? lastReviewed,
    DateTime? nextReview,
  }) {
    return Flashcard(
      id: id ?? this.id,
      deckId: deckId ?? this.deckId,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      interval: interval ?? this.interval,
      easeFactor: easeFactor ?? this.easeFactor,
      lastReviewed: lastReviewed ?? this.lastReviewed,
      nextReview: nextReview ?? this.nextReview,
    );
  }
}
