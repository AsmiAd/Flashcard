import 'package:flutter/material.dart';
import '../models/deck_model.dart';

class DeckCard extends StatelessWidget {
  final Deck deck;
  final VoidCallback onTap;

  const DeckCard({super.key, required this.deck, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: theme.cardTheme.elevation,
      shape: theme.cardTheme.shape,
      color: theme.cardTheme.color, // Adapts to dark/light automatically
      margin: theme.cardTheme.margin,
      child: ListTile(
        title: Text(
          deck.name,
          style: theme.textTheme.bodyLarge, // Text adapts to theme
        ),
        subtitle: Text(
          '${deck.cardCount} cards', // FIXED (uses cardCount instead of flashcards)
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
