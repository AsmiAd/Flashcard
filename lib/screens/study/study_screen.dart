import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../models/deck_model.dart';
import '../../providers/deck_list_provider.dart';
import 'spaced_repetition_screen.dart';

class StudyScreen extends ConsumerWidget {
  final Deck? deck; // Optional deck (can study all or one)

  const StudyScreen({super.key, this.deck});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decks = ref.watch(deckListProvider);

    final studyDecks = deck != null ? [deck!] : decks; // If deck passed, show only that one

    return Scaffold(
      appBar: AppBar(
        title: Text(deck != null ? "Study: ${deck!.name}" : "Study Decks"),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: studyDecks.isEmpty
          ? const Center(child: Text("No decks available to study"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: studyDecks.length,
              itemBuilder: (_, i) {
                final d = studyDecks[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(d.name, style: AppTextStyles.headingSmall),
                    subtitle: Text("${d.cardCount} cards",
                        style: AppTextStyles.bodySmall),
                    trailing: const Icon(Icons.arrow_forward_ios,
                        color: AppColors.grey),
                    onTap: () => _showModePicker(context, d),
                  ),
                );
              },
            ),
    );
  }

  void _showModePicker(BuildContext context, Deck deck) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: AppColors.white,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Select Study Mode", style: AppTextStyles.headingMedium),
              const SizedBox(height: 16),
              _buildModeButton(context, deck, "Spaced Repetition", Icons.repeat, () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => SpacedRepetitionScreen(deckId: deck.id)),
                );
              }),
              _buildModeButton(context, deck, "Random Mix Mode", Icons.shuffle, () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/random_mix', arguments: deck);
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModeButton(
      BuildContext context, Deck deck, String title, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 22),
        label: Text(title, style: AppTextStyles.buttonLarge),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onTap,
      ),
    );
  }
}
