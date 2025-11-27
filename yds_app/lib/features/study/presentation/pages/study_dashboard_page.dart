import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/study_plan.dart';
import '../../domain/entities/study_word.dart';
import '../providers/study_plan_controller.dart';
import '../widgets/study_progress_header.dart';
import '../widgets/word_list_view.dart';
import '../../../../shared/widgets/difficulty_rating_widget.dart';

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

class _DashboardBody extends ConsumerStatefulWidget {
  const _DashboardBody({required this.plan});

  final StudyPlan plan;

  @override
  ConsumerState<_DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends ConsumerState<_DashboardBody> {
  late List<StudyWord> _displayedWords;
  late int _completedToday;
  late int _dailyTarget;

  @override
  void initState() {
    super.initState();
    _displayedWords = List.from(widget.plan.dueWords);
    _completedToday = widget.plan.completedToday;
    _dailyTarget = widget.plan.dailyTarget;
  }

  @override
  void didUpdateWidget(_DashboardBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.plan != oldWidget.plan) {
      _displayedWords = List.from(widget.plan.dueWords);
      _completedToday = widget.plan.completedToday;
      _dailyTarget = widget.plan.dailyTarget;
    }
  }

  Future<void> _handleWordRated(StudyWord word, Difficulty difficulty) async {
    // Optimistic UI update - remove word immediately
    setState(() {
      _displayedWords.removeWhere((w) => w.id == word.id);
      _completedToday++;
    });

    try {
      // Update progress in Supabase in background
      await ref
          .read(studyPlanRepositoryProvider)
          .updateProgress(word.id, difficulty);
    } catch (e) {
      // Revert on error
      setState(() {
        _displayedWords.insert(0, word);
        _completedToday--;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Hata: ${e.toString()}')));
      }
    }
  }

  void _handleDailyTargetChanged(int newTarget) async {
    setState(() {
      _dailyTarget = newTarget;
    });

    // If target increased and we need more words, reload plan
    if (newTarget > _displayedWords.length + _completedToday) {
      await ref.read(studyPlanControllerProvider.notifier).loadPlan();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPlan = StudyPlan(
      dueWords: _displayedWords,
      dailyTarget: _dailyTarget,
      completedToday: _completedToday,
    );

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StudyProgressHeader(
            plan: currentPlan,
            onDailyTargetChanged: _handleDailyTargetChanged,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: WordListView(
              words: _displayedWords,
              onWordRated: _handleWordRated,
            ),
          ),
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
