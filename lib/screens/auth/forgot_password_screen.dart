import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../widgets/custom_text_field.dart';
import '../../services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onContinuePressed() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email')),
      );
      return;
    }

    try {
      await AuthService().sendPasswordResetEmail(email);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent!')),
      );

      Navigator.pop(context); // back to login
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _goBackToLogin() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Forget your password?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Enter your email address and we’ll send you instructions to reset your password.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.grey,
                ),
              ),
              const SizedBox(height: 32),
              CustomTextField(
                controller: _emailController,
                label: 'EMAIL',
                hint: 'name@email.com',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Email is required' : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onContinuePressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('CONTINUE'),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: GestureDetector(
                  onTap: _goBackToLogin,
                  child: const Text(
                    'Back to Login',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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
