import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    const brown = Color(0xFF4E342E);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: brown)),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator, // ✅ Corrected
          style: const TextStyle(color: brown),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: brown),
            ),
            suffixIcon: suffixIcon,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
