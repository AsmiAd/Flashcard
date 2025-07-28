import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_colors.dart';
import '../auth/auth_checker.dart';
import '../onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 2), _checkIfFirstLaunch);
  }

  Future<void> _checkIfFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

    if (!mounted) return;

    if (hasSeenOnboarding) {
      _navigateToHome();
    } else {
      await prefs.setBool('hasSeenOnboarding', true);
      _navigateToOnboarding();
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const AuthChecker(),
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void _navigateToOnboarding() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const OnboardingScreen(),
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _opacityAnimation,
                builder: (_, child) {
                  return Opacity(
                    opacity: _opacityAnimation.value,
                    child: child,
                  );
                },
                child: SizedBox(
                  width: screenHeight * 0.5,
                  height: screenHeight * 0.5,
                  child: Image.asset(
                    'assets/images/splash_logo.png',
                    filterQuality: FilterQuality.high,
                    frameBuilder: (_, child, frame, wasSynchronouslyLoaded) {
                      if (wasSynchronouslyLoaded || frame != null) {
                        return child;
                      }
                      return const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(AppColors.primary),
                      );
                    },
                    errorBuilder: (_, __, ___) => const Icon(Icons.error),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const SizedBox(height: 32),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                strokeWidth: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
