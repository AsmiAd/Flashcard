import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/deck_model.dart';
import '../models/flashcard_model.dart';
import '../providers/deck_provider.dart';
import '../providers/deck_list_provider.dart';

import 'flashcard_list_provider.dart';

final deckServiceProvider = Provider<DeckService>((ref) {
  return DeckService(ref);
});

class DeckService {
  final Ref ref;
  DeckService(this.ref);

  Future<List<Deck>> getAllDecks() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ref.read(deckListProvider); // Now works
  }

  Future<List<Flashcard>> getFlashcards(String deckId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return ref.read(flashcardListProvider)[deckId] ?? [];
  }

  Future<void> updateFlashcard(String deckId, Flashcard card) async {
    final notifier = ref.read(flashcardListProvider.notifier);
    final cards = List<Flashcard>.from(ref.read(flashcardListProvider)[deckId] ?? []);

    final index = cards.indexWhere((c) => c.id == card.id);
    if (index != -1) {
      cards[index] = card;
      notifier.setFlashcards(deckId, cards);
    }
    
  }

  Future<List<Deck>> getCachedDecksAfterSync() async => getAllDecks();
  Future<void> sync() async {}
}
