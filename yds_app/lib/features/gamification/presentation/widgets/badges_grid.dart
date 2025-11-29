import 'package:flutter/material.dart';
import '../../domain/entities/badge.dart' as game_badge;

class BadgesGrid extends StatelessWidget {
  const BadgesGrid({super.key, required this.badges});

  final List<game_badge.Badge> badges;

  @override
  Widget build(BuildContext context) {
    if (badges.isEmpty) {
      return const Center(child: Text('Henüz rozet yok.'));
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: badges.length,
      itemBuilder: (context, index) {
        final badge = badges[index];
        return _BadgeCard(badge: badge);
      },
    );
  }
}

class _BadgeCard extends StatelessWidget {
  const _BadgeCard({required this.badge});

  final game_badge.Badge badge;

  @override
  Widget build(BuildContext context) {
    final isEarned = badge.isEarned;

    return Tooltip(
      message: '${badge.name}\n${badge.description}',
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Column(
                children: [
                  Icon(
                    _getIconData(badge.iconName),
                    size: 48,
                    color: isEarned
                        ? _getBadgeColor(badge.code)
                        : Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(badge.name, textAlign: TextAlign.center),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    badge.description,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isEarned
                          ? Colors.green.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      isEarned ? 'Kazanıldı' : 'Kazanılmadı',
                      style: TextStyle(
                        color: isEarned ? Colors.green : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Tamam'),
                ),
              ],
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: isEarned
                ? Theme.of(context).colorScheme.surfaceContainerHighest
                : Theme.of(context).colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isEarned
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
                  : Colors.transparent,
            ),
            boxShadow: isEarned
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getIconData(badge.iconName),
                size: 40,
                color: isEarned ? _getBadgeColor(badge.code) : Colors.grey[400],
              ),
              const SizedBox(height: 8),
              Text(
                badge.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isEarned
                      ? Theme.of(context).colorScheme.onSurface
                      : Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'school':
        return Icons.school;
      case 'menu_book':
        return Icons.menu_book;
      case 'emoji_events':
        return Icons.emoji_events;
      case 'local_fire_department':
        return Icons.local_fire_department;
      default:
        return Icons.star;
    }
  }

  Color _getBadgeColor(String code) {
    switch (code) {
      case 'quiz_master':
        return Colors.amber;
      case 'streak_7':
        return Colors.orange;
      case 'scholar':
        return Colors.blue;
      default:
        return Colors.green;
    }
  }
}
