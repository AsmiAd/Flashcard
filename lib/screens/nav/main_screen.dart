import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../add/add_screen.dart';
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';
import '../statistic/statistic_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Widget> _screens;

  final List<IconData> _navIcons = [
    Icons.home,
    Icons.add,
    Icons.bar_chart,
    Icons.person,
  ];

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(),
      AddScreen(),
      StatisticScreen(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _screens[_currentIndex],
      bottomNavigationBar: _buildCurvedNavBar(),
    );
  }

  Widget _buildCurvedNavBar() {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.transparent,
      ),
      child: CurvedNavigationBar(
        index: _currentIndex,
        height: 60,
        color: AppColors.primary,
        buttonBackgroundColor: AppColors.primary.withOpacity(0.8),
        backgroundColor: Colors.transparent,
        animationDuration: const Duration(milliseconds: 300),
        items: _navIcons.map((icon) => Icon(icon, size: 30)).toList(),
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
