import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final usernameProvider = FutureProvider.autoDispose<String>((ref) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return 'User';

  try {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (doc.exists) {
      return doc.data()?['username'] ?? 'User';
    }
    
    // If document doesn't exist, create it with default values
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set({
          'username': user.displayName ?? 'User',
          'email': user.email,
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

    return user.displayName ?? 'User';
  } catch (e) {
    debugPrint('Error fetching username: $e');
    return 'User';
  }
});