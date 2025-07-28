import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/flashcard_model.dart';
import '../../providers/flashcard_list_provider.dart';

class RandomMixStudyScreen extends ConsumerStatefulWidget {
  const RandomMixStudyScreen({super.key});

  @override
  ConsumerState<RandomMixStudyScreen> createState() => _RandomMixStudyScreenState();
}

class _RandomMixStudyScreenState extends ConsumerState<RandomMixStudyScreen> {
  List<Flashcard> cards = [];
  int currentIndex = 0;
  bool loading = true;
  bool showAnswer = false;
  int totalToStudy = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _askQuestionCount());
  }

  void _askQuestionCount() {
    // Get all flashcards from state
    final flashcardMap = ref.read(flashcardListProvider);
    final allCards = flashcardMap.values.expand((list) => list).toList();

    final total = allCards.length;
    final customController = TextEditingController();
    bool isValid = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("How many questions to study?"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Total available: $total cards"),
                  const SizedBox(height: 10),
                  TextField(
                    controller: customController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Custom number",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) {
                      final input = int.tryParse(customController.text);
                      setDialogState(() {
                        isValid = input != null && input > 0 && input <= total;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: [
                      for (int count in [5, 10, total])
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _loadCards(allCards, count);
                          },
                          child: Text(count == total ? "All ($total)" : "$count"),
                        ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isValid
                      ? () {
                          final input = int.tryParse(customController.text)!;
                          Navigator.pop(context);
                          _loadCards(allCards, input);
                        }
                      : null,
                  child: const Text("Start"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _loadCards(List<Flashcard> allCards, int count) {
    allCards.shuffle(Random());
    setState(() {
      cards = allCards.take(count).toList();
      totalToStudy = count;
      currentIndex = 0;
      loading = false;
      showAnswer = false;
    });
  }

  void _nextCard() {
    if (currentIndex == cards.length - 1) {
      _finish();
    } else {
      setState(() {
        currentIndex++;
        showAnswer = false;
      });
    }
  }

  void _finish() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Study Complete"),
        content: Text("You studied $totalToStudy cards!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _askQuestionCount(); // Restart session
            },
            child: const Text("Restart"),
          ),
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
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (cards.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Random Mix Mode")),
        body: const Center(child: Text("No flashcards available.")),
      );
    }

    final card = cards[currentIndex];
    return Scaffold(
      appBar: AppBar(title: const Text("Random Mix Study")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text("Card ${currentIndex + 1} of $totalToStudy", style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text("Q:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text(card.question, style: const TextStyle(fontSize: 22), textAlign: TextAlign.center),
                    if (showAnswer) ...[
                      const Divider(height: 30, thickness: 1.2),
                      const Text("A:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      Text(card.answer, style: const TextStyle(fontSize: 20, color: Colors.green), textAlign: TextAlign.center),
                    ]
                  ],
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () => showAnswer ? _nextCard() : setState(() => showAnswer = true),
              icon: Icon(showAnswer ? Icons.arrow_forward : Icons.visibility),
              label: Text(showAnswer ? (currentIndex == cards.length - 1 ? "Finish" : "Next") : "Show Answer"),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
            )
          ],
        ),
      ),
    );
  }
}
