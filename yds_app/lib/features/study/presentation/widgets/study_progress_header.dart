import 'package:flutter/material.dart';

import '../../domain/entities/study_plan.dart';

/// Günlük hedef ve ilerlemeyi gösteren başlık.
class StudyProgressHeader extends StatelessWidget {
  const StudyProgressHeader({
    required this.plan,
    this.onDailyTargetChanged,
    super.key,
  });

  final StudyPlan plan;
  final void Function(int newTarget)? onDailyTargetChanged;

  Future<void> _showTargetDialog(BuildContext context) async {
    final controller = TextEditingController(text: plan.dailyTarget.toString());

    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Günlük Hedef'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Kelime sayısı',
            hintText: '20',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              final value = int.tryParse(controller.text);
              if (value != null && value > 0 && value <= 100) {
                Navigator.pop(context, value);
              }
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );

    if (result != null && onDailyTargetChanged != null) {
      onDailyTargetChanged!(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final progressRatio = plan.dailyTarget == 0
        ? 0.0
        : plan.completedToday / plan.dailyTarget;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bugünkü hedef: ${plan.dailyTarget} kelime',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (onDailyTargetChanged != null)
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () => _showTargetDialog(context),
                  tooltip: 'Hedefi değiştir',
                ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: progressRatio.clamp(0.0, 1.0)),
          const SizedBox(height: 8),
          Text(
            '${plan.completedToday} / ${plan.dailyTarget} tamamlandı',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
