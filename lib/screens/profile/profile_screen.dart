import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../core/show_banner.dart';
import '../../providers/notification_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/user_provider.dart';
import 'edit_page.dart';
import 'feedback_screen.dart';
import 'help_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
        showAppBanner(context, "Logged out successfully",
            color: AppColors.error);
      }
    } catch (e) {
      if (context.mounted) {
        showAppBanner(context, "Error signing out: ${e.toString()}",
            color: AppColors.error);
      }
    }
  }

  Future<void> _deleteAccount(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      showAppBanner(context, "No user logged in", color: AppColors.error);
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Account?"),
        content: const Text(
            "This will permanently delete your account and all associated data. Are you sure?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .delete();
      await user.delete();

      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
        showAppBanner(context, "Account deleted successfully",
            color: AppColors.error);
      }
    } catch (e) {
      showAppBanner(context, "Failed to delete account: ${e.toString()}",
          color: AppColors.error);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
            icon: const Icon(Icons.notifications),
            color: AppColors.primary,
          ),
        ],
        title: Center(
          child: Text(
            "Profile",
            style:
                AppTextStyles.headingSmall.copyWith(color: AppColors.primary),
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    foregroundImage: AssetImage("assets/images/profile.jpg"),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ref.watch(usernameProvider).when(
                      data: (username) {
                        return Text(
                          username,
                          style: AppTextStyles.headingSmall
                              .copyWith(color: AppColors.primary),
                        );
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (error, stack) {
                        return Text(
                          'User',
                          style: AppTextStyles.headingSmall
                              .copyWith(color: AppColors.primary),
                        );
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    color: AppColors.primary,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.dark_mode, color: AppColors.primary),
                title: Text("Dark Mode", style: AppTextStyles.bodyMedium),
                trailing: Switch(
                  value: isDarkMode,
                  onChanged: (value) {
                    ref.read(themeProvider.notifier).toggleTheme();
                  },
                ),
              ),
              const Divider(),
              ListTile(
                leading:
                    const Icon(Icons.notifications, color: AppColors.primary),
                title: Text("Notifications", style: AppTextStyles.bodyMedium),
                trailing: Consumer(
                  builder: (context, ref, _) {
                    final notificationsEnabled =
                        ref.watch(notificationProvider);
                    return Switch(
                      value: notificationsEnabled,
                      onChanged: (value) {
                        ref.read(notificationProvider.notifier).state = value;
                        showAppBanner(context,
                            value ? 'Notifications Enabled' : 'Notifications Disabled');
                      },
                    );
                  },
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.info, color: AppColors.primary),
                title: Text("App Version", style: AppTextStyles.bodyMedium),
                trailing: const Text("v1.0.0", style: AppTextStyles.bodySmall),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.feedback, color: AppColors.primary),
                title: Text("Give Feedback", style: AppTextStyles.bodyMedium),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FeedbackScreen()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.help, color: AppColors.primary),
                title: Text("Help", style: AppTextStyles.bodyMedium),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HelpScreen()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.share, color: AppColors.primary),
                title: Text("Share App", style: AppTextStyles.bodyMedium),
                onTap: () async {
                  final result = await Share.shareWithResult(
                    'Check out BrainBoost! An amazing flashcard app for learning.\nDownload: https://yourapp.link',
                    subject: 'Try BrainBoost App!',
                  );
                  if (result.status == ShareResultStatus.success) {
                    showAppBanner(context, "Thanks for sharing!");
                  }
                },
              ),
              const Divider(),
              ListTile(
                leading:
                    const Icon(Icons.person_remove, color: AppColors.primary),
                title: Text("Delete Account", style: AppTextStyles.bodyMedium),
                onTap: () => _deleteAccount(context),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.logout, color: AppColors.error),
                    label: Text(
                      "Logout",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () => logout(context),
                    style: OutlinedButton.styleFrom(
                      side:
                          const BorderSide(color: AppColors.error, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
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
