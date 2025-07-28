import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

void showAppBanner(BuildContext context, String message,
    {Color? color, int durationSeconds = 2}) {
  final overlay = Overlay.of(context);
  if (overlay == null) return;

  final entry = OverlayEntry(
    builder: (context) => Positioned(
      top: 50,
      left: MediaQuery.of(context).size.width * 0.1,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Material(
        color: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: color ?? AppColors.primary.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
          ),
        ),
      ),
    ),
  );

  overlay.insert(entry);
  Future.delayed(Duration(seconds: durationSeconds)).then((_) => entry.remove());
}
