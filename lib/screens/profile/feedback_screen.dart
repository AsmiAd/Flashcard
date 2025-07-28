import 'package:flutter/material.dart';

import '../../core/app_text_styles.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _controller = TextEditingController();

  void _submitFeedback() {
    final feedback = _controller.text.trim();
    if (feedback.isNotEmpty) {
      // Optionally save to Firestore or send to email
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thank you for your feedback!')),
      );
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Give Feedback')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Your feedback helps us improve!', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Write your feedback here...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.send),
              label: const Text('Submit'),
              onPressed: _submitFeedback,
            ),
          ],
        ),
      ),
    );
  }
}
