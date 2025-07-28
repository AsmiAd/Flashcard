import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../core/show_banner.dart';
import '../../models/deck_model.dart';
import '../../widgets/deck_card.dart';
import '../flashcard/flashcards_screen.dart';
import '../../providers/deck_list_provider.dart';
import '../../providers/flashcard_list_provider.dart';
import '../test/test_mode_screen.dart' as test;
import '../study/study_screen.dart' as study;

class DeckDetailsScreen extends ConsumerWidget {
  final String deckId;

  const DeckDetailsScreen({super.key, required this.deckId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decks = ref.watch(deckListProvider);
    final flashcardsMap = ref.watch(flashcardListProvider);

    final deck = decks.firstWhere(
      (d) => d.id == deckId,
      orElse: () => Deck(
        id: deckId,
        name: 'Unknown Deck',
        description: 'No description available',
        cardCount: 0,
        lastAccessed: DateTime.now(),
      ),
    );

    final flashcards = flashcardsMap[deck.id] ?? [];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(deck.name,
            style: AppTextStyles.headingSmall.copyWith(color: AppColors.primary)),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: AppColors.primary),
            onPressed: () async {
              final deckJson = jsonEncode(deck.toJson());
              final shareMessage =
                  "Check out my BrainBoost deck: *${deck.name}* "
                  "(${flashcards.length} cards)\n\n"
                  "Copy the code below and import it in your app:\n"
                  "$deckJson\n\n"
                  "Download BrainBoost: https://yourapp.link";

              final result = await Share.shareWithResult(
                shareMessage,
                subject: 'BrainBoost Deck - ${deck.name}',
              );

              if (result.status == ShareResultStatus.success) {
                showAppBanner(context, "Deck shared successfully!");
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: AppColors.error),
            onPressed: () => _confirmDelete(context, ref, deck.id),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DeckCard(
              deck: deck,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FlashcardsScreen(deck: deck),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.school, color: Colors.white),
                    label: const Text('Study'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => study.StudyScreen(deck: deck),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.quiz, color: AppColors.primary),
                    label: const Text('Test'),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => test.TestModeScreen(deck: deck),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              "Number of flashcards: ${flashcards.length}",
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, String deckId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Delete Deck"),
        content: const Text("Are you sure you want to delete this deck?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              ref.read(deckListProvider.notifier).deleteDeck(deckId);
              Navigator.pop(context);
              Navigator.pop(context);
              showAppBanner(context, "Deck deleted", color: AppColors.error);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}
