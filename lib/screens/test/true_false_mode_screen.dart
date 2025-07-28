import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/app_text_styles.dart';
import '../../models/deck_model.dart';
import '../../models/flashcard_model.dart';
import '../../providers/flashcard_list_provider.dart';

class TrueFalseModeScreen extends ConsumerStatefulWidget {
  final Deck deck;
  const TrueFalseModeScreen({super.key, required this.deck});

  @override
  ConsumerState<TrueFalseModeScreen> createState() => _TrueFalseModeScreenState();
}

class _TrueFalseModeScreenState extends ConsumerState<TrueFalseModeScreen> {
  List<Flashcard> _cards = [];
  int _current = 0;
  int _score = 0;
  String? _displayedAnswer;
  final List<_AnswerRecord> _answerRecords = [];

  @override
  void initState() {
    super.initState();
    final flashcards = ref.read(flashcardListProvider)[widget.deck.id] ?? [];
    _cards = flashcards;
    if (_cards.isNotEmpty) _randomize();
  }

  void _randomize() {
    final random = Random();
    final currentCard = _cards[_current];
    _displayedAnswer = random.nextBool()
        ? currentCard.answer
        : _cards[random.nextInt(_cards.length)].answer;
  }

  void _answer(bool isTrue) {
    final correct = _displayedAnswer == _cards[_current].answer;
    if ((isTrue && correct) || (!isTrue && !correct)) _score++;

    _answerRecords.add(_AnswerRecord(
      question: _cards[_current].question,
      displayedAnswer: _displayedAnswer ?? '',
      userChoice: isTrue,
      correctAnswer: _cards[_current].answer,
      isCorrect: (isTrue && correct) || (!isTrue && !correct),
    ));

    if (_current < _cards.length - 1) {
      setState(() {
        _current++;
        _randomize();
      });
    } else {
      _showResult();
    }
  }

  void _showResult() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("True/False Finished"),
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
                  itemCount: _answerRecords.length,
                  itemBuilder: (context, index) {
                    final record = _answerRecords[index];
                    return ListTile(
                      title: Text(record.question, style: AppTextStyles.bodyMedium),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Displayed: ${record.displayedAnswer}", style: const TextStyle(color: Colors.blue)),
                          Text("Your choice: ${record.userChoice ? 'True' : 'False'}",
                              style: TextStyle(color: record.isCorrect ? Colors.green : Colors.red)),
                          Text("Correct answer: ${record.correctAnswer}"),
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
      return Scaffold(
        appBar: AppBar(title: Text("True/False: ${widget.deck.name}")),
        body: const Center(child: Text("No flashcards available.")),
      );
    }

    final card = _cards[_current];
    return Scaffold(
      appBar: AppBar(title: Text("True/False: ${widget.deck.name}")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Card ${_current + 1} of ${_cards.length}", style: AppTextStyles.bodySmall),
            const SizedBox(height: 20),
            Text(card.question, style: AppTextStyles.headingSmall),
            const SizedBox(height: 16),
            Text(_displayedAnswer ?? '', style: AppTextStyles.bodyMedium.copyWith(color: Colors.blue)),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _answer(true),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size(120, 48)),
                  child: const Text("True"),
                ),
                ElevatedButton(
                  onPressed: () => _answer(false),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, minimumSize: const Size(120, 48)),
                  child: const Text("False"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _AnswerRecord {
  final String question;
  final String displayedAnswer;
  final bool userChoice;
  final String correctAnswer;
  final bool isCorrect;

  _AnswerRecord({
    required this.question,
    required this.displayedAnswer,
    required this.userChoice,
    required this.correctAnswer,
    required this.isCorrect,
  });
}
