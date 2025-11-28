import 'package:flutter/material.dart';
import '../../domain/entities/user_stats.dart';

class LevelProgressCard extends StatelessWidget {
  const LevelProgressCard({super.key, required this.stats});

  final UserStats stats;

  @override
  Widget build(BuildContext context) {
    final nextLevelXp = stats.level * 100;
    final currentLevelXp = (stats.level - 1) * 100;
    final progress =
        (stats.xp - currentLevelXp) / (nextLevelXp - currentLevelXp);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Seviye ${stats.level}',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    Text(
                      'Toplam XP: ${stats.xp}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.emoji_events,
                    color: Theme.of(context).colorScheme.primary,
                    size: 32,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Seviye ${stats.level}'),
                Text('${(progress * 100).toInt()}%'),
                Text('Seviye ${stats.level + 1}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
