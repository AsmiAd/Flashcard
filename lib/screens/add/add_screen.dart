// lib/screens/add/add_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../core/show_banner.dart';
import '../../models/deck_model.dart';
import '../../providers/deck_list_provider.dart';
import 'add_flashcards_screen.dart';

class AddScreen extends ConsumerStatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends ConsumerState<AddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      showAppBanner(context, 'Please fill the required fields',
          color: AppColors.error);
      return;
    }

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 700)); // Simulated delay

    final newDeck = Deck(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      cardCount: 0,
      createdAt: DateTime.now(),
      lastAccessed: null,
    );

    ref.read(deckListProvider.notifier).addDeck(newDeck);

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddFlashcardsScreen(deck: newDeck),
      ),
    );

    showAppBanner(context, 'Deck created! Add flashcards now.',
        color: AppColors.primary);
    _resetForm();
  }

  void _resetForm() {
    _titleController.clear();
    _descriptionController.clear();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Deck', style: AppTextStyles.headingSmall),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      style: AppTextStyles.bodyMedium,
                      decoration: const InputDecoration(
                        labelText: "Deck Title *",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) => val == null || val.isEmpty
                          ? "Title is required"
                          : null,
                      maxLength: 50,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      style: AppTextStyles.bodyMedium,
                      decoration: const InputDecoration(
                        labelText: "Description (optional)",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      maxLength: 200,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _submitForm,
                        icon: const Icon(Icons.add, color: AppColors.white),
                        label: Text('Create Deck',
                            style: AppTextStyles.buttonLarge),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
