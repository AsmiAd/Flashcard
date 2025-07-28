import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Welcome to BrainBoost",
      "description": "Sharpen your memory with interactive flashcards!",
      "image": "assets/images/sharp brain.png"
    },
    {
      "title": "Track Your Progress",
      "description": "Stay motivated with goals and achievements.",
      "image": "assets/images/progress.png"
    },
    {
      "title": "Learn Anytime, Anywhere",
      "description": "Offline study, voice input, and more!",
      "image": "assets/images/learn anywhere.png"
    },
  ];

  void navigateToNext() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemCount: onboardingData.length,
              itemBuilder: (context, index) => AnimatedOnboardingContent(
                title: onboardingData[index]['title']!,
                description: onboardingData[index]['description']!,
                image: onboardingData[index]['image']!,
                isVisible: _currentPage == index,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingData.length,
                (index) => buildDot(index),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () {
                if (_currentPage == onboardingData.length - 1) {
                  navigateToNext();
                } else {
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                minimumSize: const Size(double.infinity, 50),
                textStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              child: Text(
                _currentPage == onboardingData.length - 1
                    ? "Get Started"
                    : "Next",
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget buildDot(int index) {
    final bool isActive = index == _currentPage;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 10,
      width: isActive ? 22 : 10,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.grey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

class AnimatedOnboardingContent extends StatefulWidget {
  final String title;
  final String description;
  final String image;
  final bool isVisible;

  const AnimatedOnboardingContent({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.isVisible,
  });

  @override
  State<AnimatedOnboardingContent> createState() =>
      _AnimatedOnboardingContentState();
}

class _AnimatedOnboardingContentState extends State<AnimatedOnboardingContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _imageSlide;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _imageSlide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _textSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    if (widget.isVisible) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedOnboardingContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !_controller.isCompleted) {
      _controller.forward();
    } else if (!widget.isVisible && _controller.isCompleted) {
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SlideTransition(
            position: _imageSlide,
            child: FadeTransition(
              opacity: _fade,
              child: Image.asset(widget.image, height: 250),
            ),
          ),
          const SizedBox(height: 40),
          SlideTransition(
            position: _textSlide,
            child: FadeTransition(
              opacity: _fade,
              child: Column(
                children: [
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.text,
                          fontWeight: FontWeight.w700,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.text.withOpacity(0.7),
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
