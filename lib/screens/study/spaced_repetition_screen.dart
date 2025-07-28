import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/deck_provider.dart';
import '../../providers/flashcard_list_provider.dart';
import '../../models/flashcard_model.dart';

class SpacedRepetitionScreen extends ConsumerStatefulWidget {
  final String deckId;

  const SpacedRepetitionScreen({super.key, required this.deckId});

  @override
  ConsumerState<SpacedRepetitionScreen> createState() => _SpacedRepetitionScreenState();
}

class _SpacedRepetitionScreenState extends ConsumerState<SpacedRepetitionScreen> {
  List<Flashcard> dueCards = [];
  List<Flashcard> hardCards = [];
  int currentIndex = 0;
  bool showAnswer = false;
  bool loading = true;

  int easyCount = 0;
  int mediumCount = 0;
  int hardCount = 0;

  @override
  void initState() {
    super.initState();
    loadDueCards();
  }

  Future<void> loadDueCards() async {
    // Use provider so it syncs with the rest of the app
    final allCards = ref.read(flashcardListProvider)[widget.deckId] ?? [];

    final now = DateTime.now();
    dueCards = allCards
        .where((card) => card.nextReview == null || card.nextReview!.isBefore(now))
        .toList();

    setState(() => loading = false);
  }

  Future<void> updateCard(String difficulty) async {
    final deckService = ref.read(deckServiceProvider);
    final card = dueCards[currentIndex];

    // Track counts for summary
    switch (difficulty) {
      case 'Easy':
        easyCount++;
        break;
      case 'Medium':
        mediumCount++;
        break;
      case 'Hard':
        hardCount++;
        hardCards.add(card);
        break;
    }

    // Simplified SM2 adjustment
    int interval = card.interval;
    double ef = card.easeFactor;
    switch (difficulty) {
      case 'Easy':
        ef = (ef + 0.1).clamp(1.3, 3.0);
        interval = (interval * ef).round();
        break;
      case 'Medium':
        ef = ef.clamp(1.3, 3.0);
        interval = (interval * 0.9).round().clamp(1, interval);
        break;
      case 'Hard':
        ef = (ef - 0.2).clamp(1.3, 3.0);
        interval = 1;
        break;
    }

    final updatedCard = card.copyWith(
      easeFactor: ef,
      interval: interval,
      lastReviewed: DateTime.now(),
      nextReview: DateTime.now().add(Duration(days: interval)),
    );

    // Save to Firestore/Hive
    await deckService.updateFlashcard(widget.deckId, updatedCard);

    // Advance or finish
    if (currentIndex == dueCards.length - 1) {
      if (!mounted) return;
      showSummaryDialog();
    } else {
      setState(() {
        currentIndex++;
        showAnswer = false;
      });
    }
  }

  void showSummaryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Review Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Easy: $easyCount'),
            Text('Medium: $mediumCount'),
            Text('Hard: $hardCount'),
            if (hardCount > 0) const SizedBox(height: 12),
            if (hardCount > 0)
              const Text('Would you like to review the Hard cards again?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // close dialog
              Navigator.of(context).pop(); // back to deck
            },
            child: const Text('Done'),
          ),
          if (hardCount > 0)
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                startHardReview();
              },
              child: const Text('Review Hard Again'),
            ),
        ],
      ),
    );
  }

  void startHardReview() {
    setState(() {
      dueCards = List.from(hardCards);
      currentIndex = 0;
      hardCards.clear();
      showAnswer = false;
      easyCount = 0;
      mediumCount = 0;
      hardCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (dueCards.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Spaced Repetition')),
        body: const Center(child: Text('🎉 No cards due for review!')),
      );
    }

    final card = dueCards[currentIndex];

    return Scaffold(
      appBar: AppBar(title: const Text("Spaced Repetition"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              "Card ${currentIndex + 1} of ${dueCards.length}",
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 30),
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text("Q.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text(card.question, style: const TextStyle(fontSize: 22)),
                    if (showAnswer) ...[
                      const Divider(height: 30, thickness: 1.2),
                      const Text("A.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      Text(card.answer,
                          style: TextStyle(fontSize: 20, color: Colors.green[700])),
                    ]
                  ],
                ),
              ),
            ),
            const Spacer(),
            if (!showAnswer)
              ElevatedButton.icon(
                onPressed: () => setState(() => showAnswer = true),
                icon: const Icon(Icons.visibility),
                label: const Text("Show Answer"),
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
              )
            else
              Column(
                children: [
                  buildDifficultyButton("Easy", Colors.green),
                  const SizedBox(height: 10),
                  buildDifficultyButton("Medium", Colors.orange),
                  const SizedBox(height: 10),
                  buildDifficultyButton("Hard", Colors.red),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget buildDifficultyButton(String label, Color color) {
    return ElevatedButton(
      onPressed: () {
        if (currentIndex < dueCards.length) {
          updateCard(label);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 48),
      ),
      child: Text(label, style: const TextStyle(fontSize: 18)),
    );
  }
}
