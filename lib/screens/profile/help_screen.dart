
import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            'FAQs',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('• How do I use this app?\nUse the Study or Test modes to practice flashcards.'),
          SizedBox(height: 16),
          Text('• How can I report a bug?\nUse the Give Feedback section to report bugs or issues.'),
          SizedBox(height: 16),
          Text('• How do I change my theme?\nGo to Profile > Dark Mode to toggle between light and dark themes.'),
        ],
      ),
    );
  }
}
