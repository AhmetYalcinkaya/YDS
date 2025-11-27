import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/study_plan.dart';
import '../../domain/entities/study_word.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/network/supabase_client_provider.dart';
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
    final currentUser = ref.watch(currentUserProvider);

    // Get user's first name or email
    final userName = currentUser?.email?.split('@').first ?? 'Kullanıcı';

    return Scaffold(
      appBar: AppBar(
        title: Text('Hoşgeldin, $userName'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authRepositoryProvider).signOut();
            },
            tooltip: 'Çıkış Yap',
          ),
        ],
      ),
      body: planState.when(
        data: (plan) => _DashboardBody(plan: plan),
        error: (error, _) => _ErrorState(message: error.toString()),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddWordDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Kelime Ekle'),
      ),
    );
  }

  Future<void> _showAddWordDialog(BuildContext context, WidgetRef ref) async {
    final englishController = TextEditingController();
    final turkishController = TextEditingController();
    final exampleController = TextEditingController();
    String partOfSpeech = 'noun';

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Yeni Kelime Ekle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: englishController,
                  decoration: const InputDecoration(
                    labelText: 'İngilizce',
                    hintText: 'abandon',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: turkishController,
                  decoration: const InputDecoration(
                    labelText: 'Türkçe',
                    hintText: 'terk etmek',
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: partOfSpeech,
                  decoration: const InputDecoration(labelText: 'Tür'),
                  items: const [
                    DropdownMenuItem(value: 'noun', child: Text('İsim')),
                    DropdownMenuItem(value: 'verb', child: Text('Fiil')),
                    DropdownMenuItem(value: 'adjective', child: Text('Sıfat')),
                    DropdownMenuItem(value: 'adverb', child: Text('Zarf')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => partOfSpeech = value);
                    }
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: exampleController,
                  decoration: const InputDecoration(
                    labelText: 'Örnek Cümle (opsiyonel)',
                    hintText: 'He decided to abandon the project.',
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('İptal'),
            ),
            FilledButton(
              onPressed: () async {
                if (englishController.text.isNotEmpty &&
                    turkishController.text.isNotEmpty) {
                  try {
                    final userId = ref
                        .read(supabaseClientProvider)
                        .auth
                        .currentUser
                        ?.id;
                    if (userId == null) {
                      throw Exception('User not logged in');
                    }

                    await ref
                        .read(supabaseClientProvider)
                        .from('user_words')
                        .insert({
                          'user_id': userId,
                          'english': englishController.text.trim(),
                          'turkish': turkishController.text.trim(),
                          'part_of_speech': partOfSpeech,
                          'example_sentence': exampleController.text.trim(),
                        });
                    if (context.mounted) {
                      Navigator.pop(context, true);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Hata: ${e.toString()}')),
                      );
                    }
                  }
                }
              },
              child: const Text('Ekle'),
            ),
          ],
        ),
      ),
    );

    if (result == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kelime başarıyla eklendi!')),
      );
    }
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
  bool _isShowingGoalDialog = false;

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
          .updateProgress(word.id, difficulty, isUserWord: word.isUserWord);

      // Check if goal is reached (only show dialog once)
      if (_completedToday == _dailyTarget && !_isShowingGoalDialog && mounted) {
        _isShowingGoalDialog = true;
        await _showGoalCompletedDialog();
        _isShowingGoalDialog = false;
      }
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

  Future<void> _showGoalCompletedDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Tebrikler!'),
        content: Text(
          'Bugünkü hedefinizi tamamladınız!\n$_dailyTarget kelime öğrendiniz.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Bitir'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Devam Et'),
          ),
        ],
      ),
    );

    if (result == true) {
      // User wants to continue - increase target by 10
      setState(() {
        _dailyTarget += 10;
      });

      // Load more words if needed
      if (_displayedWords.isEmpty) {
        await ref.read(studyPlanControllerProvider.notifier).loadPlan();
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
