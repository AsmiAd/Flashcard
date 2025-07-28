import 'package:flutter/material.dart';

import '../../core/app_colors.dart';

class SettingsPage extends StatelessWidget {
  final List<SettingsItem> settingsItems = [
    SettingsItem(
      icon: Icons.settings,
      title: 'General',
      subtitle: 'Language • Studying • System-wide',
    ),
    SettingsItem(
      icon: Icons.tv,
      title: 'Reviewing',
      subtitle: 'Scheduling • Automatic display answer',
    ),
    SettingsItem(
      icon: Icons.sync,
      title: 'Sync',
      subtitle: 'AnkiWeb account • Automatic synchronization',
    ),
    SettingsItem(
      icon: Icons.notifications,
      title: 'Notifications',
      subtitle: 'Notify when • Vibrate • Blink light',
    ),
    SettingsItem(
      icon: Icons.palette,
      title: 'Appearance',
      subtitle: 'Themes • Reviewer',
    ),
    SettingsItem(
      icon: Icons.touch_app,
      title: 'Controls',
      subtitle: 'Gestures • Keyboard • Bluetooth',
    ),
    SettingsItem(
      icon: Icons.accessibility,
      title: 'Accessibility',
      subtitle: 'Card zoom • Answer button size',
    ),
    SettingsItem(
      icon: Icons.backup,
      title: 'Backups',
      subtitle: 'Frequency • Lifetime',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          'Settings',
          style: TextStyle(color: AppColors.text),
        ),
        leading: BackButton(color: AppColors.text),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: TextField(
              style: TextStyle(color: AppColors.text),
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(color: AppColors.grey),
                filled: true,
                fillColor: AppColors.white,
                prefixIcon: Icon(Icons.search, color: AppColors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: settingsItems.length,
              itemBuilder: (context, index) {
                final item = settingsItems[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    tileColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    leading: Icon(item.icon, color: AppColors.primary),
                    title: Text(
                      item.title,
                      style: TextStyle(
                        color: AppColors.text,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      item.subtitle,
                      style: TextStyle(color: AppColors.grey),
                    ),
                    onTap: () {
                      // TODO: Add action
                    },
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsItem {
  final IconData icon;
  final String title;
  final String subtitle;

  SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}
