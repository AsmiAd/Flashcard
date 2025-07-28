import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../core/show_banner.dart';

// Models
class StudyProgress {
  final String period;
  final int actualMinutes;
  final int goalMinutes;

  StudyProgress({
    required this.period,
    required this.actualMinutes,
    required this.goalMinutes,
  });
}

class LeaderboardUser {
  final String userName;
  final int points;
  final String avatarUrl;

  LeaderboardUser({
    required this.userName,
    required this.points,
    required this.avatarUrl,
  });
}

// Mock Providers (replace later)
final studyProgressProvider = FutureProvider<List<StudyProgress>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 800));
  return [
    StudyProgress(period: 'Day 1', actualMinutes: 18, goalMinutes: 20),
    StudyProgress(period: 'Day 2', actualMinutes: 12, goalMinutes: 15),
    StudyProgress(period: 'Day 3', actualMinutes: 9, goalMinutes: 10),
    StudyProgress(period: 'Day 4', actualMinutes: 11, goalMinutes: 13),
    StudyProgress(period: 'Day 5', actualMinutes: 16, goalMinutes: 18),
  ];
});

final leaderboardProvider = FutureProvider<List<LeaderboardUser>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 800));
  return [
    LeaderboardUser(userName: 'Asmi', points: 150, avatarUrl: ''),
    LeaderboardUser(userName: 'Hari', points: 120, avatarUrl: ''),
    LeaderboardUser(userName: 'Krisha', points: 90, avatarUrl: ''),
    LeaderboardUser(userName: 'Shyam', points: 70, avatarUrl: ''),
    LeaderboardUser(userName: 'Amisha', points: 50, avatarUrl: ''),
  ];
});

class StatisticScreen extends ConsumerWidget {
  const StatisticScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studyProgressAsync = ref.watch(studyProgressProvider);
    final leaderboardAsync = ref.watch(leaderboardProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Center(
          child: Text(
            "Statistics",
            style: AppTextStyles.headingSmall.copyWith(color: AppColors.primary),
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(studyProgressProvider);
          ref.invalidate(leaderboardProvider);
          showAppBanner(context, "Statistics refreshed", color: AppColors.primary);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle("Study Progress"),
              const SizedBox(height: 12),
              studyProgressAsync.when(
                data: (progressList) => _buildProgressChart(context, progressList),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) {
                  showAppBanner(context, "Failed to load progress", color: AppColors.error);
                  return _errorText("Unable to fetch study progress");
                },
              ),
              const SizedBox(height: 28),
              _sectionTitle("Leaderboard"),
              const SizedBox(height: 12),
              leaderboardAsync.when(
                data: (users) => _buildLeaderboard(context, users),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) {
                  showAppBanner(context, "Failed to load leaderboard", color: AppColors.error);
                  return _errorText("Unable to fetch leaderboard");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: AppTextStyles.headingLarge.copyWith(color: AppColors.primary),
    );
  }

  Widget _errorText(String text) {
    return Text(
      text,
      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
    );
  }

  Widget _buildProgressChart(BuildContext context, List<StudyProgress> progressList) {
    if (progressList.isEmpty) {
      return _errorText("No study progress data available");
    }

    final List<charts.Series<StudyProgress, String>> seriesList = [
      charts.Series<StudyProgress, String>(
        id: 'Actual',
        domainFn: (StudyProgress sp, _) => sp.period,
        measureFn: (StudyProgress sp, _) => sp.actualMinutes,
        data: progressList,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(AppColors.primary),
        labelAccessorFn: (StudyProgress sp, _) => '${sp.actualMinutes} min',
      ),
      charts.Series<StudyProgress, String>(
        id: 'Goal',
        domainFn: (StudyProgress sp, _) => sp.period,
        measureFn: (StudyProgress sp, _) => sp.goalMinutes,
        data: progressList,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(AppColors.secondary),
        labelAccessorFn: (StudyProgress sp, _) => '${sp.goalMinutes} min',
      ),
    ];

    return Container(
      height: 280,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: charts.BarChart(
        seriesList,
        animate: true,
        barGroupingType: charts.BarGroupingType.grouped,
        behaviors: [
          charts.SeriesLegend(position: charts.BehaviorPosition.bottom, desiredMaxRows: 1),
          charts.ChartTitle('Period', behaviorPosition: charts.BehaviorPosition.bottom),
          charts.ChartTitle('Minutes', behaviorPosition: charts.BehaviorPosition.start),
        ],
        domainAxis: const charts.OrdinalAxisSpec(),
        primaryMeasureAxis: const charts.NumericAxisSpec(),
        defaultRenderer: charts.BarRendererConfig(
          cornerStrategy: const charts.ConstCornerStrategy(6),
          groupingType: charts.BarGroupingType.grouped,
        ),
      ),
    );
  }

  Widget _buildLeaderboard(BuildContext context, List<LeaderboardUser> users) {
    if (users.isEmpty) {
      return _errorText("No leaderboard data available");
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: users.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primary.withOpacity(0.2),
              child: user.avatarUrl.isNotEmpty
                  ? ClipOval(
                      child: Image.network(user.avatarUrl, fit: BoxFit.cover, width: 40, height: 40),
                    )
                  : Text(
                      user.userName.substring(0, 1).toUpperCase(),
                      style: AppTextStyles.headingMedium.copyWith(color: AppColors.primary),
                    ),
            ),
            title: Text(user.userName, style: AppTextStyles.bodyLarge),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                '${user.points} pts',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary),
              ),
            ),
          );
        },
      ),
    );
  }
}
