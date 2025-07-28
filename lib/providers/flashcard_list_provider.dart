// providers/flashcard_list_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/flashcard_model.dart';
import 'deck_list_provider.dart'; // to update cardCount

class FlashcardListNotifier extends StateNotifier<Map<String, List<Flashcard>>> {
  final Ref ref;
  FlashcardListNotifier(this.ref) : super({});

  /// Add a single flashcard and update deck's card count
  void addFlashcard(String deckId, Flashcard card) {
    final deckCards = state[deckId] ?? [];
    state = {
      ...state,
      deckId: [...deckCards, card],
    };

    // Update deck cardCount
    ref.read(deckListProvider.notifier).updateCardCount(deckId, state[deckId]!.length);
  }

  /// Add multiple flashcards (bulk) and update count
  void addFlashcards(String deckId, List<Flashcard> cards) {
    final deckCards = state[deckId] ?? [];
    state = {
      ...state,
      deckId: [...deckCards, ...cards],
    };

    ref.read(deckListProvider.notifier).updateCardCount(deckId, state[deckId]!.length);
  }

  /// Delete flashcard and update deck count
  void deleteFlashcard(String deckId, String cardId) {
    final deckCards = state[deckId] ?? [];
    final updatedCards = deckCards.where((c) => c.id != cardId).toList();

    state = {
      ...state,
      deckId: updatedCards,
    };

    ref.read(deckListProvider.notifier).updateCardCount(deckId, updatedCards.length);
  }

  /// Replace all flashcards for a deck (bulk overwrite)
  void setFlashcards(String deckId, List<Flashcard> cards) {
    state = {
      ...state,
      deckId: cards,
    };

    ref.read(deckListProvider.notifier).updateCardCount(deckId, cards.length);
  }

  List<Flashcard> getFlashcards(String deckId) => state[deckId] ?? [];
}

final flashcardListProvider = StateNotifierProvider<FlashcardListNotifier, Map<String, List<Flashcard>>>(
  (ref) => FlashcardListNotifier(ref),
);
