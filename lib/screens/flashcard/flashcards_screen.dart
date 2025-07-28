import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/deck_model.dart';
import '../../models/flashcard_model.dart';
import '../../providers/flashcard_list_provider.dart';
import 'add_edit_flashcard_screen.dart';

class FlashcardsScreen extends ConsumerStatefulWidget {
  final Deck deck;

  const FlashcardsScreen({super.key, required this.deck});

  @override
  ConsumerState<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends ConsumerState<FlashcardsScreen> {
  late List<Flashcard> _flashcards;

  @override
  void initState() {
    super.initState();
    _loadFlashcards();
  }

  void _loadFlashcards() {
    _flashcards = ref.read(flashcardListProvider)[widget.deck.id] ?? [];
  }

  void _addFlashcard() async {
    final newCard = await Navigator.push<Flashcard>(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditFlashcardScreen(deckId: widget.deck.id),
      ),
    );
    if (newCard != null) {
      ref.read(flashcardListProvider.notifier).addFlashcard(widget.deck.id, newCard);
      setState(() => _loadFlashcards());
    }
  }

  void _editFlashcard(int index, Flashcard card) async {
    final updatedCard = await Navigator.push<Flashcard>(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditFlashcardScreen(deckId: widget.deck.id, flashcard: card),
      ),
    );
    if (updatedCard != null) {
      final cards = List<Flashcard>.from(_flashcards);
      cards[index] = updatedCard;
      ref.read(flashcardListProvider.notifier).setFlashcards(widget.deck.id, cards);
      setState(() => _loadFlashcards());
    }
  }

  void _deleteFlashcard(int index) {
    final removed = _flashcards[index];
    ref.read(flashcardListProvider.notifier).deleteFlashcard(widget.deck.id, removed.id);
    setState(() => _loadFlashcards());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted: ${removed.question}'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            ref.read(flashcardListProvider.notifier).addFlashcard(widget.deck.id, removed);
            setState(() => _loadFlashcards());
          },
        ),
      ),
    );
  }

  void _deleteDeck() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Deck"),
        content: const Text("Are you sure you want to delete this deck and all its flashcards?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // For now, just pop back. Later, integrate with deckListProvider for actual deck deletion.
      Navigator.pop(context, 'deleted');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Deck deleted')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _flashcards = ref.watch(flashcardListProvider)[widget.deck.id] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Flashcards: ${widget.deck.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteDeck,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addFlashcard,
          ),
        ],
      ),
      body: _flashcards.isEmpty
          ? const Center(child: Text('No flashcards yet. Tap + to add one!'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _flashcards.length,
              itemBuilder: (context, index) {
                final card = _flashcards[index];
                return Dismissible(
                  key: Key(card.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white, size: 28),
                  ),
                  onDismissed: (_) => _deleteFlashcard(index),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      title: Text(card.question, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(card.answer, maxLines: 3, overflow: TextOverflow.ellipsis),
                      onTap: () => _editFlashcard(index, card),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
