import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/study_plan.dart';
import '../providers/study_plan_controller.dart';
import '../widgets/study_progress_header.dart';
import '../widgets/word_list_view.dart';

/// Ana çalışma ekranı; günlük hedef, ilerleme ve kelime kartlarını gösterir.
class StudyDashboardPage extends ConsumerWidget {
  const StudyDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planState = ref.watch(studyPlanControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('YDS 1000 Kelime')),
      body: planState.when(
        data: (plan) => _DashboardBody(plan: plan),
        error: (error, _) => _ErrorState(message: error.toString()),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({required this.plan});

  final StudyPlan plan;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StudyProgressHeader(plan: plan),
          const SizedBox(height: 12),
          Expanded(child: WordListView(words: plan.dueWords)),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 12),
            Text(
              'Bir şeyler ters gitti',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
