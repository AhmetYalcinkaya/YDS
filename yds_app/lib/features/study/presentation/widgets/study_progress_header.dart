import 'package:flutter/material.dart';

import '../../domain/entities/study_plan.dart';

/// Günlük hedef ve ilerlemeyi gösteren başlık.
class StudyProgressHeader extends StatelessWidget {
  const StudyProgressHeader({required this.plan, super.key});

  final StudyPlan plan;

  @override
  Widget build(BuildContext context) {
    final progressRatio =
        plan.dailyTarget == 0 ? 0.0 : plan.completedToday / plan.dailyTarget;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bugünkü hedef: ${plan.dailyTarget} kelime',
            style: Theme.of(context).textTheme.titleLarge,
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

