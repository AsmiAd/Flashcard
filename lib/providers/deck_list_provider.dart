// lib/providers/deck_list_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/deck_model.dart';
import '../models/flashcard_model.dart';
import 'flashcard_list_provider.dart';

class DeckListNotifier extends StateNotifier<List<Deck>> {
  final Ref ref;

  DeckListNotifier(this.ref) : super([]) {
    _initializeSampleData();
  }

  void _initializeSampleData() {
    final decks = [
      Deck(
        id: '1',
        name: 'Biology Basics',
        description: 'Learn core biology concepts',
        cardCount: 2,
        lastAccessed: DateTime.now(),
      ),
      Deck(
        id: '2',
        name: 'Physics Formulas',
        description: 'Quick physics formula reference',
        cardCount: 2,
        lastAccessed: DateTime.now(),
      ),
    ];
    state = decks;

    // Delay flashcard initialization until after widget build is complete
    Future(() {
  ref.read(flashcardListProvider.notifier).setFlashcards('1', [
    Flashcard(
      id: 'bio1',
      deckId: '1',
      question: 'What is the powerhouse of the cell?',
      answer: 'Mitochondria',
      interval: 1,
      easeFactor: 2.5,
      lastReviewed: null,
      nextReview: null,
    ),
    Flashcard(
      id: 'bio2',
      deckId: '1',
      question: 'What is the basic unit of life?',
      answer: 'Cell',
      interval: 1,
      easeFactor: 2.5,
      lastReviewed: null,
      nextReview: null,
    ),
    Flashcard(
      id: 'bio3',
      deckId: '1',
      question: 'Which molecule carries genetic information?',
      answer: 'DNA',
      interval: 1,
      easeFactor: 2.5,
      lastReviewed: null,
      nextReview: null,
    ),
    Flashcard(
      id: 'bio4',
      deckId: '1',
      question: 'Which pigment gives plants their green color?',
      answer: 'Chlorophyll',
      interval: 1,
      easeFactor: 2.5,
      lastReviewed: null,
      nextReview: null,
    ),
    Flashcard(
      id: 'bio5',
      deckId: '1',
      question: 'What is the process of cell division in body cells?',
      answer: 'Mitosis',
      interval: 1,
      easeFactor: 2.5,
      lastReviewed: null,
      nextReview: null,
    ),
    Flashcard(
      id: 'bio6',
      deckId: '1',
      question: 'Which organ purifies blood in humans?',
      answer: 'Kidneys',
      interval: 1,
      easeFactor: 2.5,
      lastReviewed: null,
      nextReview: null,
    ),
    Flashcard(
      id: 'bio7',
      deckId: '1',
      question: 'Which blood cells help fight infections?',
      answer: 'White blood cells (WBCs)',
      interval: 1,
      easeFactor: 2.5,
      lastReviewed: null,
      nextReview: null,
    ),
  ]);

  ref.read(flashcardListProvider.notifier).setFlashcards('2', [
    Flashcard(
      id: 'phy1',
      deckId: '2',
      question: 'Formula for Newton’s Second Law?',
      answer: 'F = m × a',
      interval: 1,
      easeFactor: 2.5,
      lastReviewed: null,
      nextReview: null,
    ),
    Flashcard(
      id: 'phy2',
      deckId: '2',
      question: 'What is Earth’s gravity acceleration?',
      answer: '9.8 m/s²',
      interval: 1,
      easeFactor: 2.5,
      lastReviewed: null,
      nextReview: null,
    ),
    Flashcard(
      id: 'phy3',
      deckId: '2',
      question: 'What is the speed of light in vacuum?',
      answer: '3 × 10⁸ m/s',
      interval: 1,
      easeFactor: 2.5,
      lastReviewed: null,
      nextReview: null,
    ),
    Flashcard(
      id: 'phy4',
      deckId: '2',
      question: 'What is the SI unit of force?',
      answer: 'Newton (N)',
      interval: 1,
      easeFactor: 2.5,
      lastReviewed: null,
      nextReview: null,
    ),
    Flashcard(
      id: 'phy5',
      deckId: '2',
      question: 'What is Ohm’s Law formula?',
      answer: 'V = I × R',
      interval: 1,
      easeFactor: 2.5,
      lastReviewed: null,
      nextReview: null,
    ),
    Flashcard(
      id: 'phy6',
      deckId: '2',
      question: 'Who discovered the law of gravitation?',
      answer: 'Isaac Newton',
      interval: 1,
      easeFactor: 2.5,
      lastReviewed: null,
      nextReview: null,
    ),
    Flashcard(
      id: 'phy7',
      deckId: '2',
      question: 'What is the SI unit of energy?',
      answer: 'Joule (J)',
      interval: 1,
      easeFactor: 2.5,
      lastReviewed: null,
      nextReview: null,
    ),
  ]);
});

  }

  /// Add a new deck
  void addDeck(Deck deck) {
    state = [...state, deck];
  }
  void updateCardCount(String deckId, int newCount) {
    state = [
      for (final deck in state)
        if (deck.id == deckId) deck.copyWith(cardCount: newCount) else deck
    ];
  }

  /// Delete a deck and its flashcards
  void deleteDeck(String deckId) {
    state = state.where((d) => d.id != deckId).toList();
    ref.read(flashcardListProvider.notifier).setFlashcards(deckId, []);
  }

  /// Import a deck if it doesn’t already exist
  void importDeck(Deck deck) {
    if (!state.any((d) => d.id == deck.id)) {
      state = [...state, deck];
    }
  }

  /// Update a deck and its flashcards
  void updateDeck(Deck updatedDeck, List<Flashcard> cards) {
    state = [
      for (final deck in state)
        if (deck.id == updatedDeck.id) updatedDeck else deck
    ];
    ref.read(flashcardListProvider.notifier).setFlashcards(updatedDeck.id, cards);
  }
}

final deckListProvider =
    StateNotifierProvider<DeckListNotifier, List<Deck>>((ref) {
  return DeckListNotifier(ref);
});
