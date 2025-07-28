// core/providers/auth_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// New: User's Firestore data provider
final firestoreUserProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return null;

  final doc = await ref
      .watch(firestoreProvider)
      .collection('users')
      .doc(user.uid)
      .get();

  return doc.data();
});
