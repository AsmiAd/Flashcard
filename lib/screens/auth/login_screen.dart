import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../../widgets/custom_text_field.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _loading = false;

  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      final user = await _authService.signInWithEmail(
          _emailController.text.trim(), _passwordController.text);
      if (user != null) {
        Navigator.of(context).pushReplacementNamed('/main_screen');
      }
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? 'Login failed');
    } catch (e) {
      _showError('An error occurred');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loginWithGoogle() async {
    setState(() => _loading = true);
    try {
      final user = await _authService.signInWithGoogle();
      if (user != null) {
        Navigator.of(context).pushReplacementNamed('/');
      }
    } catch (e) {
      _showError('Google sign-in failed');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      SizedBox(
                        height: screenHeight * 0.2,
                        child: Image.asset('assets/images/splash_logo.png'),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 32),

                      CustomTextField(
                        controller: _emailController,
                        label: 'EMAIL',
                        hint: 'name@gmail.com',
                        validator: (value) => value == null || value.isEmpty
                            ? 'Email is required'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: _passwordController,
                        label: 'PASSWORD',
                        hint: 'Enter password',
                        obscureText: _obscurePassword,
                        validator: (value) => value == null || value.length < 6
                            ? 'Password must be at least 6 characters'
                            : null,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.primary,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/forgot-password');
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loginWithEmail,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.white,
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Login'),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account? ",
                              style: TextStyle(color: AppColors.grey)),
                          GestureDetector(
                            onTap: () =>
                                Navigator.pushNamed(context, '/register'),
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      Row(
                        children: const [
                          Expanded(
                              child:
                                  Divider(thickness: 1, color: AppColors.grey)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text('OR',
                                style: TextStyle(color: AppColors.grey)),
                          ),
                          Expanded(
                              child:
                                  Divider(thickness: 1, color: AppColors.grey)),
                        ],
                      ),

                      const SizedBox(height: 24),

                      
                      _buildSocialButton(
                        iconPath: 'assets/images/google.png',
                        label: 'Continue with Google',
                        onPressed: _loginWithGoogle,
                      ),
                      const SizedBox(height: 12),

                      _buildSocialButton(
                        iconPath: 'assets/images/gmail.png',
                        label: 'Continue with Gmail',
                        onPressed: _loginWithGoogle,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildSocialButton({
    required String iconPath,
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: Image.asset(
          iconPath,
          width: 20,
          height: 20,
        ),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.text,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(color: AppColors.grey),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
