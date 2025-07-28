import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../providers/user_provider.dart';

class EditPage extends ConsumerStatefulWidget {
  const EditPage({Key? key}) : super(key: key);

  @override
  ConsumerState<EditPage> createState() => _EditPageState();
}

class _EditPageState extends ConsumerState<EditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  File? _selectedImage;

  Future<void> _pickImage() async {
  final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  Future<String?> _uploadProfilePicture(String uid) async {
    if (_selectedImage == null) return null;

    final ref = FirebaseStorage.instance.ref().child('user_photos/$uid.jpg');
    await ref.putFile(_selectedImage!);
    return await ref.getDownloadURL();
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final newUsername = _usernameController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final currentPassword = _currentPasswordController.text.trim();

    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      if (user.displayName != newUsername) {
        await user.updateDisplayName(newUsername);
      }

      if (newPassword.isNotEmpty) {
        await user.updatePassword(newPassword);
      }

      String? photoUrl = await _uploadProfilePicture(user.uid);
      if (photoUrl != null) {
        await user.updatePhotoURL(photoUrl);
      }

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'username': newUsername,
        if (photoUrl != null) 'photoUrl': photoUrl,
      }, SetOptions(merge: true));

      ref.invalidate(usernameProvider);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _usernameController = TextEditingController(text: user?.displayName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Widget buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback toggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility,
              color: AppColors.grey),
          onPressed: toggle,
        ),
      ),
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: textTheme.displaySmall),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: AppColors.primary),
            onPressed: _updateProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : (FirebaseAuth.instance.currentUser?.photoURL != null
                              ? NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!)
                              : const AssetImage("assets/images/profile.jpg")) as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                          ),
                          child: const Icon(Icons.edit, size: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Username
              TextFormField(
                controller: _usernameController,
                style: textTheme.bodyMedium,
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter username' : null,
              ),
              const SizedBox(height: 16),

              // Current Password
              buildPasswordField(
                controller: _currentPasswordController,
                label: 'Current Password',
                obscure: _obscureCurrent,
                toggle: () => setState(() {
                  _obscureCurrent = !_obscureCurrent;
                }),
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter current password'
                    : null,
              ),
              const SizedBox(height: 16),

              // New Password
              buildPasswordField(
                controller: _newPasswordController,
                label: 'New Password (optional)',
                obscure: _obscureNew,
                toggle: () => setState(() {
                  _obscureNew = !_obscureNew;
                }),
                validator: (value) {
                  if (value != null && value.isNotEmpty && value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Confirm Password
              buildPasswordField(
                controller: _confirmPasswordController,
                label: 'Confirm New Password',
                obscure: _obscureConfirm,
                toggle: () => setState(() {
                  _obscureConfirm = !_obscureConfirm;
                }),
                validator: (value) {
                  if (_newPasswordController.text.isNotEmpty &&
                      value != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Save Changes',
                    style: AppTextStyles.buttonLarge),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
