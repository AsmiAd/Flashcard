import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../models/flashcard_model.dart';
import '../../providers/deck_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RandomMixScreen extends ConsumerStatefulWidget {
  const RandomMixScreen({super.key});

  @override
  ConsumerState<RandomMixScreen> createState() => _RandomMixScreenState();
}

class _RandomMixScreenState extends ConsumerState<RandomMixScreen> {
  List<Flashcard> _cards = [];
  int _currentIndex = 0;
  int _score = 0;
  final TextEditingController _controller = TextEditingController();

  // Store user answers
  final List<String> _userAnswers = [];

  @override
  void initState() {
    super.initState();
    _loadAllCards();
  }

  Future<void> _loadAllCards() async {
    final service = ref.read(deckServiceProvider);
    final decks = await service.getAllDecks();
    List<Flashcard> allCards = [];
    for (final d in decks) {
      final cards = await service.getFlashcards(d.id);
      allCards.addAll(cards);
    }
    allCards.shuffle(Random());
    setState(() => _cards = allCards);
  }

  void _submitAnswer() {
    final userAnswer = _controller.text.trim();
    final correctAnswer = _cards[_currentIndex].answer.trim();

    final isCorrect = userAnswer.toLowerCase() == correctAnswer.toLowerCase();
    if (isCorrect) _score++;

    // Save user answer for review later
    _userAnswers.add(userAnswer);

    _controller.clear();

    if (_currentIndex == _cards.length - 1) {
      _showResult();
    } else {
      setState(() {
        _currentIndex++;
      });
    }
  }

  void _showResult() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Random Mix Finished"),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Score: $_score / ${_cards.length}"),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _cards.length,
                  itemBuilder: (context, index) {
                    final card = _cards[index];
                    final userAns = index < _userAnswers.length ? _userAnswers[index] : "";
                    final isCorrect = userAns.toLowerCase() == card.answer.toLowerCase();

                    return ListTile(
                      title: Text(card.question, style: AppTextStyles.bodyMedium),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Your answer: $userAns",
                            style: TextStyle(color: isCorrect ? Colors.green : Colors.red),
                          ),
                          Text("Correct answer: ${card.answer}"),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
  onPressed: () {
    Navigator.pop(context); // Close dialog
    Navigator.pop(context); // Go back to previous screen (not login)
  },
  child: const Text("OK"),
),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_cards.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final card = _cards[_currentIndex];

    return Scaffold(
      appBar: AppBar(title: const Text("Random Mix Mode")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Card ${_currentIndex + 1} of ${_cards.length}",
                style: AppTextStyles.bodySmall),
            const SizedBox(height: 20),
            Text(card.question, style: AppTextStyles.headingSmall),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Your Answer",
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _submitAnswer(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text("Submit Answer"),
            ),
          ],
        ),
      ),
    );
  }
}
