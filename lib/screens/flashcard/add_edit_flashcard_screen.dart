import 'package:flutter/material.dart';
import '../../models/flashcard_model.dart';

class AddEditFlashcardScreen extends StatefulWidget {
  final String deckId;
  final Flashcard? flashcard;

  const AddEditFlashcardScreen({super.key, required this.deckId, this.flashcard});

  @override
  State<AddEditFlashcardScreen> createState() => _AddEditFlashcardScreenState();
}

class _AddEditFlashcardScreenState extends State<AddEditFlashcardScreen> {
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.flashcard != null) {
      _questionController.text = widget.flashcard!.question;
      _answerController.text = widget.flashcard!.answer;
    }
  }

  void _save() {
    if (_questionController.text.trim().isEmpty || _answerController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill both question and answer')));
      return;
    }

    final newFlashcard = Flashcard(
      id: widget.flashcard?.id ?? UniqueKey().toString(),
      deckId: widget.deckId,
      question: _questionController.text.trim(),
      answer: _answerController.text.trim(),
    );

    Navigator.pop(context, newFlashcard);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.flashcard == null ? 'Add Flashcard' : 'Edit Flashcard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _save,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(labelText: 'Question'),
              maxLines: 2,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _answerController,
              decoration: const InputDecoration(labelText: 'Answer'),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}
