import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yds_app/core/theme/theme_provider.dart';
import 'package:yds_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:yds_app/features/study/domain/entities/study_statistics.dart';
import 'package:yds_app/features/study/domain/repositories/study_plan_repository.dart';
import 'package:yds_app/features/study/presentation/providers/study_plan_controller.dart';
import '../../../gamification/domain/entities/badge.dart' as game_badge;
import '../../../gamification/data/repositories/gamification_repository_impl.dart';
import '../../../gamification/presentation/widgets/level_progress_card.dart';
import '../../../gamification/presentation/widgets/badges_grid.dart';
import '../../../gamification/presentation/providers/gamification_provider.dart';
import '../../../gamification/presentation/pages/leaderboard_page.dart';
import 'statistics_page.dart';
import 'word_list_page.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late Future<StudyStatistics> _statisticsFuture;
  late Future<Map<String, dynamic>?> _profileFuture;
  late Future<List<game_badge.Badge>> _badgesFuture;

  @override
  void initState() {
    super.initState();
    final repo = ref.read(studyPlanRepositoryProvider);
    final gameRepo = ref.read(gamificationRepositoryProvider);

    _statisticsFuture = repo.getStatistics();
    _profileFuture = repo.getUserProfile();
    _badgesFuture = gameRepo.getBadges();

    // Check for new badges on profile load
    gameRepo.checkAndAwardBadges();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profilim'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authRepositoryProvider).signOut();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Center(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 3,
                  ),
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: FutureBuilder<Map<String, dynamic>?>(
                future: _profileFuture,
                builder: (context, snapshot) {
                  final displayName = snapshot.data?['display_name'] as String?;
                  return Text(
                    displayName ?? user?.email ?? 'Kullanıcı',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            Center(
              child: Text(
                user?.email ?? '',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 24),

            // Level Progress
            Consumer(
              builder: (context, ref, child) {
                final userStatsAsync = ref.watch(userStatsProvider);
                return userStatsAsync.when(
                  data: (stats) => LevelProgressCard(stats: stats),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => const SizedBox.shrink(),
                );
              },
            ),

            const SizedBox(height: 16),

            // Leaderboard Button
            FilledButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LeaderboardPage(),
                  ),
                );
              },
              icon: const Icon(Icons.leaderboard),
              label: const Text('Liderlik Tablosu'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Statistics Button
            FilledButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const StatisticsPage(),
                  ),
                );
              },
              icon: const Icon(Icons.bar_chart),
              label: const Text('Detaylı İstatistikler'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Statistics Grid
            FutureBuilder<StudyStatistics>(
              future: _statisticsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Hata: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: Text('İstatistik bulunamadı'));
                }

                final stats = snapshot.data!;
                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildStatCard(
                      context,
                      'Toplam',
                      stats.totalWordsStudied.toString(),
                      Icons.book,
                      const Color(0xFF4E6AF3), // Royal Blue
                      WordStatus.all,
                    ),
                    _buildStatCard(
                      context,
                      'Ezberlenen',
                      stats.masteredWords.toString(),
                      Icons.check_circle,
                      const Color(0xFF2ECC71), // Mint Green
                      WordStatus.mastered,
                    ),
                    _buildStatCard(
                      context,
                      'Öğreniliyor',
                      stats.learningWords.toString(),
                      Icons.school,
                      const Color(0xFFF1C40F), // Sunflower Yellow
                      WordStatus.learning,
                    ),
                    _buildStatCard(
                      context,
                      'Favoriler',
                      stats.favoriteCount.toString(),
                      Icons.star,
                      const Color(0xFFFFA726), // Amber
                      WordStatus.favorites,
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 32),

            // Badges Section
            Text(
              'Rozetler',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<game_badge.Badge>>(
              future: _badgesFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return BadgesGrid(badges: snapshot.data!);
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),

            const SizedBox(height: 40),
            // Settings Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ayarlar',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.dark_mode,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Karanlık Mod',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      Switch(
                        value: ref.watch(themeModeProvider) == ThemeMode.dark,
                        onChanged: (value) {
                          ref.read(themeModeProvider.notifier).toggleTheme();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    WordStatus status,
  ) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => WordListPage(status: status, title: title),
          ),
        );
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
