import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../core/show_banner.dart';
import '../../models/deck_model.dart';
import '../../providers/deck_list_provider.dart';
import '../../widgets/deck_card.dart';
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decks = ref.watch(deckListProvider);
    final usernameAsync = AsyncValue.data("Asmi"); // Replace with real provider

    return Scaffold(
  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
  appBar: _buildAppBar(context, usernameAsync),
  floatingActionButton: Padding(
    padding: const EdgeInsets.only(bottom: 70), // Keep above nav bar
    child: _buildImportButton(context, ref),
  ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(context),
              const SizedBox(height: 20),
              _buildActionButtons(context),
              const SizedBox(height: 24),
              Text('Your Decks',
                  style: AppTextStyles.headingSmall
                      .copyWith(color: AppColors.primary)),
              const SizedBox(height: 12),
              Expanded(
                child: decks.isEmpty
                    ? Center(
                        child: Text(
                          'No decks found',
                          style: AppTextStyles.bodyMedium
                              .copyWith(color: AppColors.grey),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.only(
                            bottom: 80), // add bottom padding
                        itemCount: decks.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, index) => DeckCard(
                          deck: decks[index],
                          onTap: () => _openDeck(context, decks[index].id),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, AsyncValue<String> usernameAsync) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      title: usernameAsync.when(
        loading: () => Text('Hi... 👋',
            style:
                AppTextStyles.headingSmall.copyWith(color: AppColors.primary)),
        error: (_, __) => Text('Hi User 👋',
            style:
                AppTextStyles.headingSmall.copyWith(color: AppColors.primary)),
        data: (name) => Text('Hi $name 👋',
            style:
                AppTextStyles.headingSmall.copyWith(color: AppColors.primary)),
      ),
      actions: [
        IconButton(
          icon: Badge(
            smallSize: 8,
            child:
                const Icon(Icons.notifications_none, color: AppColors.primary),
          ),
          onPressed: () => Navigator.pushNamed(context, '/notifications'),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) => TextField(
        decoration: InputDecoration(
          hintText: 'Search decks...',
          prefixIcon: const Icon(Icons.search, color: AppColors.primary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onTap: () => Navigator.pushNamed(context, '/search'),
      );

  Widget _buildActionButtons(BuildContext context) => Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.school, color: Colors.white),
              label: const Text('Study'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.pushNamed(context, '/study'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: OutlinedButton.icon(
              icon: const Icon(Icons.quiz, color: AppColors.primary),
              label: const Text('Test'),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.pushNamed(context, '/test'),
            ),
          ),
        ],
      );

  Widget _buildImportButton(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      backgroundColor: AppColors.primary,
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            final controller = TextEditingController();
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              title: Text("Import Deck",
                  style: AppTextStyles.headingSmall
                      .copyWith(color: AppColors.primary)),
              content: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: "Paste shared deck JSON here",
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    try {
                      final data = jsonDecode(controller.text);
                      final deck = Deck.fromJson(data);
                      ref.read(deckListProvider.notifier).importDeck(deck);
                      Navigator.pop(context);
                      showAppBanner(context, "Deck '${deck.name}' imported!");
                    } catch (_) {
                      showAppBanner(context, "Invalid JSON format",
                          color: AppColors.error);
                    }
                  },
                  child: const Text("Import"),
                ),
              ],
            );
          },
        );
      },
      child: const Icon(Icons.download, color: Colors.white),
    );
  }

  void _openDeck(BuildContext context, String deckId) {
    Navigator.pushNamed(context, '/deck-details', arguments: deckId);
  }
}

/// Simple placeholder for study mode screen
class StudyScreenWithPreselectedDeck extends StatelessWidget {
  final Deck deck;
  const StudyScreenWithPreselectedDeck({super.key, required this.deck});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Study Modes - ${deck.name}',
              style: AppTextStyles.headingSmall
                  .copyWith(color: AppColors.primary))),
      body: Center(
          child: Text('Study modes for deck ${deck.name}',
              style: AppTextStyles.bodyMedium)),
    );
  }
}

/// Simple placeholder for test mode screen
class TestModeScreenWithPreselectedDeck extends StatelessWidget {
  final Deck deck;
  const TestModeScreenWithPreselectedDeck({super.key, required this.deck});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Test Modes - ${deck.name}',
              style: AppTextStyles.headingSmall
                  .copyWith(color: AppColors.primary))),
      body: Center(
          child: Text('Test modes for deck ${deck.name}',
              style: AppTextStyles.bodyMedium)),
    );
  }
}
