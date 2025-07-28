// lib/screens/add/add_flashcards_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../core/show_banner.dart';
import '../../models/deck_model.dart';
import '../../models/flashcard_model.dart';
import '../../providers/deck_list_provider.dart';

class AddFlashcardsScreen extends ConsumerStatefulWidget {
  final Deck deck;

  const AddFlashcardsScreen({super.key, required this.deck});

  @override
  ConsumerState<AddFlashcardsScreen> createState() =>
      _AddFlashcardsScreenState();
}

class _AddFlashcardsScreenState extends ConsumerState<AddFlashcardsScreen> {
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();
  final List<Flashcard> _cards = [];

  void _addFlashcard() {
    if (_questionController.text.trim().isEmpty ||
        _answerController.text.trim().isEmpty) {
      showAppBanner(context, 'Please enter both question and answer',
          color: AppColors.error);
      return;
    }

    final newCard = Flashcard(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      deckId: widget.deck.id,
      question: _questionController.text.trim(),
      answer: _answerController.text.trim(),
    );

    setState(() {
      _cards.add(newCard);
    });

    _questionController.clear();
    _answerController.clear();
    showAppBanner(context, 'Flashcard added!');
  }

  void _removeFlashcard(int index) {
    setState(() => _cards.removeAt(index));
    showAppBanner(
      context,
      "${widget.deck.name} now has ${_cards.length} cards",
      color: AppColors.primary,
    );
  }

  void _finish() {
    final updatedDeck = widget.deck.copyWith(cardCount: _cards.length);
    ref.read(deckListProvider.notifier).updateDeck(updatedDeck, _cards);

    Navigator.pop(context);
    showAppBanner(
      context,
      "${widget.deck.name} saved with ${_cards.length} cards",
      color: AppColors.primary,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Flashcards", style: AppTextStyles.headingSmall),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _questionController,
              style: AppTextStyles.bodyMedium,
              decoration: const InputDecoration(
                labelText: 'Question',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _answerController,
              style: AppTextStyles.bodyMedium,
              decoration: const InputDecoration(
                labelText: 'Answer',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _addFlashcard,
                icon: const Icon(Icons.add, color: AppColors.white),
                label: Text("Add Flashcard", style: AppTextStyles.buttonLarge),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _cards.isEmpty
                  ? Center(
                      child: Text("No flashcards added yet",
                          style: AppTextStyles.bodyMedium),
                    )
                  : ListView.builder(
                      itemCount: _cards.length,
                      itemBuilder: (_, index) {
                        final card = _cards[index];
                        return ListTile(
                          title: Text(card.question,
                              style: AppTextStyles.bodyLarge),
                          subtitle:
                              Text(card.answer, style: AppTextStyles.bodySmall),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: AppColors.error),
                            onPressed: () => _removeFlashcard(index),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _finish,
                icon: const Icon(Icons.done, color: AppColors.white),
                label: Text("Finish & Save Deck", style: AppTextStyles.buttonLarge),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
