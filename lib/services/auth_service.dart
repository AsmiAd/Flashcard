import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Email login
  Future<User?> signInWithEmail(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return credential.user;
  }

  /// Email registration with username
  Future<User?> signUpWithEmail(
    String email, String password, String username) async {
  final credential = await _auth.createUserWithEmailAndPassword(
      email: email, password: password);
  final user = credential.user;

  if (user != null) {
    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
      'username': username,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  return user;
}

  Future<void> saveUserToFirestore(
      String uid, String username, String email) async {
    await _firestore.collection('users').doc(uid).set({
      'username': username,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<String> getUsernameFromFirestore() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (doc.exists) {
      final data = doc.data();
      if (data != null && data.containsKey('username')) {
        return data['username'];
      } else {
        throw Exception('Username field not found in document for ${user.uid}');
      }
    } else {
      throw Exception('User document not found for ${user.uid}');
    }
  }
  throw Exception('No user is currently signed in');
}


  /// Reset password
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  /// Google Sign-In
  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null; // user canceled

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    final user = userCredential.user;

    if (user != null) {
      final docRef = _firestore.collection('users').doc(user.uid);
      final docSnapshot = await docRef.get();

      // Only write data if user doc doesn't exist
      if (!docSnapshot.exists) {
        await docRef.set({
          'uid': user.uid,
          'email': user.email,
          'username': user.displayName ?? 'No Name',
          'createdAt': FieldValue.serverTimestamp(),
        });
        
      debugPrint("Google user signed in. Firestore document written for: ${user.uid}");
    } else {
      /// Optional: Print if user already existed
      debugPrint("Google user signed in. Firestore document already exists for: ${user.uid}");
    }
  }

  return user;
}

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }

  /// Current user
  User? get currentUser => _auth.currentUser;
}
