import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../models/deck_model.dart';
import '../../providers/deck_list_provider.dart';

class TestModeScreen extends ConsumerWidget {
  final Deck? deck; // Optional: allows showing only one deck

  const TestModeScreen({super.key, this.deck});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decks = ref.watch(deckListProvider);

    final testDecks = deck != null ? [deck!] : decks; // Single or all decks

    return Scaffold(
      appBar: AppBar(
        title: Text(deck != null ? "Test: ${deck!.name}" : "Test Your Knowledge"),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: testDecks.isEmpty
          ? const Center(child: Text("No decks available for testing"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: testDecks.length,
              itemBuilder: (_, i) {
                final d = testDecks[i];
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
              Text("Select Test Mode", style: AppTextStyles.headingMedium),
              const SizedBox(height: 16),
              _buildModeButton(context, deck, "Quiz Mode", Icons.quiz, '/quiz'),
              _buildModeButton(context, deck, "True/False", Icons.check_circle, '/truefalse'),
              _buildModeButton(context, deck, "Timed Mode", Icons.timer, '/timed'),
              _buildModeButton(context, deck, "Random Mix", Icons.shuffle, '/randommix'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModeButton(
      BuildContext context, Deck deck, String title, IconData icon, String route) {
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
        onPressed: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, route, arguments: deck);
        },
      ),
    );
  }
}
