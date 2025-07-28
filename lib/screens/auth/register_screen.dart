import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../services/auth_service.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final _authService = AuthService();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegisterPressed() async {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      try {
        final user = await _authService.signUpWithEmail(email, password, username);

        if (user != null) {

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Account created successfully')),
            );
            Navigator.pushReplacementNamed(context, '/login');
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  controller: _usernameController,
                  label: 'USERNAME',
                  hint: 'Your name',
                  validator: validateUsername,
                ),
                CustomTextField(
                  controller: _emailController,
                  label: 'EMAIL',
                  hint: 'name@gmail.com',
                  validator: validateEmail,
                ),
                CustomTextField(
                  controller: _passwordController,
                  label: 'PASSWORD',
                  hint: '*******',
                  obscureText: _obscurePassword,
                  validator: validatePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.primary,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
                CustomTextField(
                  controller: _confirmPasswordController,
                  label: 'CONFIRM PASSWORD',
                  hint: '********',
                  obscureText: _obscureConfirmPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.primary,
                    ),
                    onPressed: () {
                      setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                    },
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onRegisterPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('REGISTER'),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                    child: Text.rich(
                      TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(color: AppColors.grey),
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    SizedBox(width: 10),
                    Text("OR", style: TextStyle(color: AppColors.grey)),
                    SizedBox(width: 10),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final user = await _authService.signInWithGoogle();
                      if (user != null && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Signed in with Google')),
                        );
                        Navigator.pop(context);
                      }
                    },
                    icon: Image.asset(
                      "images/google.png",
                      height: 20,
                    ),
                    label: const Text("Continue with Google"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
