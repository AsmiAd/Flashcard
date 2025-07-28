import 'package:flutter/material.dart';
import '../../core/show_banner.dart';
import '../../core/app_colors.dart';
import '../../models/deck_model.dart';
import '../../widgets/deck_card.dart';

class DecksScreen extends StatefulWidget {
  const DecksScreen({super.key});

  @override
  State<DecksScreen> createState() => _DecksScreenState();
}

class _DecksScreenState extends State<DecksScreen> {
  final List<Deck> _decks = [
    Deck(
      id: '1',
      name: 'Biology Basics',
      description: 'Learn core biology concepts',
      cardCount: 12,
      lastAccessed: DateTime.now(),
    ),
    Deck(
      id: '2',
      name: 'Physics Formulas',
      description: 'Quick physics formula reference',
      cardCount: 20,
      lastAccessed: DateTime.now(),
    ),
    Deck(
      id: '3',
      name: 'Chemistry Notes',
      description: 'Important chemistry topics',
      cardCount: 15,
      lastAccessed: DateTime.now(),
    ),
  ];

  void _openDeck(Deck deck) async {
    final result = await Navigator.pushNamed(
      context,
      '/flashcards',
      arguments: deck,
    );

    if (result == 'deleted') {
      setState(() {
        _decks.removeWhere((d) => d.id == deck.id);
      });

      showAppBanner(context, "'${deck.name}' deck deleted",
          color: AppColors.error);
    }
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(milliseconds: 700));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Decks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.pushNamed(context, '/search'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: _decks.isEmpty
            ? const Center(child: Text('No decks found.'))
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _decks.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, index) {
                  final deck = _decks[index];
                  return DeckCard(
                    deck: deck,
                    onTap: () => _openDeck(deck),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, '/add-deck'),
      ),
    );
  }
}
