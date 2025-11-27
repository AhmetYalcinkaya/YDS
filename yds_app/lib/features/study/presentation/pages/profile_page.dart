import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yds_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:yds_app/features/study/domain/entities/study_statistics.dart';
import 'package:yds_app/features/study/domain/repositories/study_plan_repository.dart';
import 'package:yds_app/features/study/presentation/providers/study_plan_controller.dart';
import 'word_list_page.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late Future<StudyStatistics> _statisticsFuture;
  late Future<Map<String, dynamic>?> _profileFuture;

  @override
  void initState() {
    super.initState();
    final repo = ref.read(studyPlanRepositoryProvider);
    _statisticsFuture = repo.getStatistics();
    _profileFuture = repo.getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profilim'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authRepositoryProvider).signOut();
              if (mounted) {
                Navigator.of(
                  context,
                ).pop(); // Close profile page if opened as dialog/page
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
            const SizedBox(height: 16),
            FutureBuilder<Map<String, dynamic>?>(
              future: _profileFuture,
              builder: (context, snapshot) {
                final displayName = snapshot.data?['display_name'] as String?;
                return Text(
                  displayName ?? user?.email ?? 'Kullanıcı',
                  style: Theme.of(context).textTheme.titleLarge,
                );
              },
            ),
            const SizedBox(height: 32),
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
                return Column(
                  children: [
                    _buildStatCard(
                      context,
                      'Toplam Çalışılan',
                      stats.totalWordsStudied.toString(),
                      Icons.book,
                      Colors.blue,
                      WordStatus.all,
                    ),
                    const SizedBox(height: 16),
                    _buildStatCard(
                      context,
                      'Ezberlenen',
                      stats.masteredWords.toString(),
                      Icons.check_circle,
                      Colors.green,
                      WordStatus.mastered,
                    ),
                    const SizedBox(height: 16),
                    _buildStatCard(
                      context,
                      'Öğreniliyor',
                      stats.learningWords.toString(),
                      Icons.school,
                      Colors.orange,
                      WordStatus.learning,
                    ),
                  ],
                );
              },
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
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => WordListPage(status: status, title: title),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
