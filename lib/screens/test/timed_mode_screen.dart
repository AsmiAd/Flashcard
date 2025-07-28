import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../models/deck_model.dart';
import '../../models/flashcard_model.dart';
import '../../providers/flashcard_list_provider.dart';

class TimedModeScreen extends ConsumerStatefulWidget {
  final Deck deck;
  const TimedModeScreen({super.key, required this.deck});

  @override
  ConsumerState<TimedModeScreen> createState() => _TimedModeScreenState();
}

class _TimedModeScreenState extends ConsumerState<TimedModeScreen> {
  List<Flashcard> _cards = [];
  int _current = 0;
  int _score = 0;
  late int _timeLimit;
  int _timeLeft = 0;
  Timer? _timer;
  bool _quizStarted = false;
  final TextEditingController _controller = TextEditingController();

  final List<String> _userAnswers = [];
  final List<int> _timeOptions = [15, 30, 45, 60, 90, 120];

  @override
  void initState() {
    super.initState();
    final flashcards = ref.read(flashcardListProvider)[widget.deck.id] ?? [];
    _cards = flashcards;
    _timeLimit = 30; // default
  }

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = _timeLimit;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft == 0) {
        _submitAnswer(autoNext: true);
      } else {
        setState(() => _timeLeft--);
      }
    });
  }

  void _submitAnswer({bool autoNext = false}) {
    final userAnswer = _controller.text.trim();
    final correctAnswer = _cards[_current].answer.trim();

    _userAnswers.add(userAnswer);
    if (userAnswer.toLowerCase() == correctAnswer.toLowerCase()) _score++;
    _controller.clear();

    if (_current < _cards.length - 1) {
      setState(() => _current++);
      _startTimer();
    } else {
      _timer?.cancel();
      _showResult();
    }

    if (!autoNext) setState(() {});
  }

  void _showResult() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Timed Mode Finished"),
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
                          Text("Your answer: $userAns",
                              style: TextStyle(color: isCorrect ? Colors.green : Colors.red)),
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
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Widget _buildTimeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select time per question:", style: AppTextStyles.headingSmall),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          children: _timeOptions.map((seconds) {
            final isSelected = seconds == _timeLimit;
            return ChoiceChip(
              label: Text("$seconds sec"),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _timeLimit = seconds);
                }
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() => _quizStarted = true);
              _startTimer();
            },
            child: const Text("Start Quiz"),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_cards.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("Timed Mode: ${widget.deck.name}")),
        body: const Center(child: Text("No flashcards in this deck.")),
      );
    }

    if (!_quizStarted) {
      return Scaffold(
        appBar: AppBar(title: Text("Timed Mode: ${widget.deck.name}")),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: _buildTimeSelector(),
        ),
      );
    }

    final card = _cards[_current];
    return Scaffold(
      appBar: AppBar(title: Text("Timed: ${widget.deck.name}")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Time Left: $_timeLeft sec", style: AppTextStyles.bodySmall.copyWith(color: Colors.red)),
            const SizedBox(height: 16),
            Text("Card ${_current + 1} of ${_cards.length}", style: AppTextStyles.bodySmall),
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
