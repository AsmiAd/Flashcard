import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Simple boolean state provider for notifications (can be expanded later)
final notificationProvider = StateProvider<bool>((ref) => true);

class NotificationProvider extends StatelessWidget {
  const NotificationProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}