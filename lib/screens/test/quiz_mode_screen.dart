import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../models/deck_model.dart';
import '../../models/flashcard_model.dart';
import '../../providers/flashcard_list_provider.dart';

class QuizModeScreen extends ConsumerStatefulWidget {
  final Deck deck;
  const QuizModeScreen({super.key, required this.deck});

  @override
  ConsumerState<QuizModeScreen> createState() => _QuizModeScreenState();
}

class _QuizModeScreenState extends ConsumerState<QuizModeScreen> {
  late List<Flashcard> _cards;
  int _current = 0;
  int _score = 0;
  final TextEditingController _controller = TextEditingController();
  final List<String> _userAnswers = [];

  @override
  void initState() {
    super.initState();
    final flashcards = ref.read(flashcardListProvider)[widget.deck.id] ?? [];
    _cards = flashcards;
  }

  void _submit() {
    final userAnswer = _controller.text.trim();
    final correctAnswer = _cards[_current].answer.trim();

    _userAnswers.add(userAnswer);

    if (userAnswer.toLowerCase() == correctAnswer.toLowerCase()) {
      _score++;
    }
    _controller.clear();

    if (_current < _cards.length - 1) {
      setState(() => _current++);
    } else {
      _showResult();
    }
  }

  void _showResult() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Quiz Finished"),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Your Score: $_score / ${_cards.length}"),
                const SizedBox(height: 12),
                ListView.builder(
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
                          Text("Your answer: $userAns", style: TextStyle(color: isCorrect ? Colors.green : Colors.red)),
                          Text("Correct answer: ${card.answer}"),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
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
      return Scaffold(
        appBar: AppBar(title: Text("Quiz: ${widget.deck.name}")),
        body: const Center(child: Text("No flashcards available in this deck.")),
      );
    }

    final card = _cards[_current];
    return Scaffold(
      appBar: AppBar(title: Text("Quiz: ${widget.deck.name}")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Question ${_current + 1} of ${_cards.length}", style: AppTextStyles.bodySmall),
            const SizedBox(height: 20),
            Text(card.question, style: AppTextStyles.headingSmall),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: "Your Answer"),
              onSubmitted: (_) => _submit(),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, minimumSize: const Size.fromHeight(48)),
              onPressed: _submit,
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
