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
import 'profile_page.dart';

/// Ana çalışma ekranı; günlük hedef, ilerleme ve kelime kartlarını gösterir.
class StudyDashboardPage extends ConsumerWidget {
  const StudyDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planState = ref.watch(studyPlanControllerProvider);

    return Scaffold(
      body: planState.when(
        data: (plan) => _DashboardBody(plan: plan),
        error: (error, _) => _ErrorState(message: error.toString()),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await _showAddWordDialog(context, ref);
          if (result == true) {
            // Planı yeniden yükle
            ref.read(studyPlanControllerProvider.notifier).loadPlan();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Kelime Ekle'),
      ),
    );
  }

  Future<bool?> _showAddWordDialog(BuildContext context, WidgetRef ref) async {
    final englishController = TextEditingController();
    final turkishController = TextEditingController();
    final exampleController = TextEditingController();
    String category = 'noun';
    String difficultyLevel = 'B1';

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
                  value: category,
                  decoration: const InputDecoration(labelText: 'Kategori'),
                  items: const [
                    DropdownMenuItem(value: 'noun', child: Text('İsim')),
                    DropdownMenuItem(value: 'verb', child: Text('Fiil')),
                    DropdownMenuItem(value: 'adjective', child: Text('Sıfat')),
                    DropdownMenuItem(value: 'adverb', child: Text('Zarf')),
                    DropdownMenuItem(value: 'preposition', child: Text('Edat')),
                    DropdownMenuItem(
                      value: 'conjunction',
                      child: Text('Bağlaç'),
                    ),
                    DropdownMenuItem(value: 'pronoun', child: Text('Zamir')),
                    DropdownMenuItem(value: 'other', child: Text('Diğer')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => category = value);
                    }
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: difficultyLevel,
                  decoration: const InputDecoration(
                    labelText: 'Zorluk Seviyesi',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'A1',
                      child: Text('A1 - Başlangıç'),
                    ),
                    DropdownMenuItem(value: 'A2', child: Text('A2 - Temel')),
                    DropdownMenuItem(value: 'B1', child: Text('B1 - Orta')),
                    DropdownMenuItem(
                      value: 'B2',
                      child: Text('B2 - Orta-İleri'),
                    ),
                    DropdownMenuItem(value: 'C1', child: Text('C1 - İleri')),
                    DropdownMenuItem(value: 'C2', child: Text('C2 - Uzman')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => difficultyLevel = value);
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
                          'example_sentence': exampleController.text.trim(),
                          'category': category,
                          'difficulty_level': difficultyLevel,
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

    return result;
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

      // Get current plan state
      final planState = ref.read(studyPlanControllerProvider);

      planState.whenData((currentPlan) {
        final remainingWords = currentPlan.dueWords
            .where((w) => !_displayedWords.any((dw) => dw.id == w.id))
            .toList();

        if (remainingWords.isNotEmpty) {
          setState(() {
            _displayedWords.addAll(remainingWords.take(10));
          });
        } else {
          // If no remaining words, reload the plan
          ref.read(studyPlanControllerProvider.notifier).loadPlan().then((_) {
            final newPlanState = ref.read(studyPlanControllerProvider);
            newPlanState.whenData((newPlan) {
              setState(() {
                _displayedWords.addAll(newPlan.dueWords.take(10));
              });
            });
          });
        }
      });
    }
  }

  void _handleDailyTargetChanged(int newTarget) async {
    setState(() {
      _dailyTarget = newTarget;
    });

    // Save to DB
    try {
      await ref.read(studyPlanRepositoryProvider).updateDailyTarget(newTarget);
    } catch (e) {
      // Ignore error or show snackbar
      debugPrint('Error saving daily target: $e');
    }

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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildDailyProgressCard(context, currentPlan),
            const SizedBox(height: 24),
            Text(
              'Bugünün Kelimeleri',
              style: Theme.of(context).textTheme.titleLarge,
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
      ),
    );
  }

  Widget _buildDailyProgressCard(BuildContext context, StudyPlan plan) {
    final progress = plan.dailyTarget > 0
        ? plan.completedToday / plan.dailyTarget
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Günlük Hedef',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${plan.completedToday}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '/${plan.dailyTarget}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () => _showTargetDialog(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Hedefi Düzenle',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 100,
            width: 100,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 10,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                Center(
                  child: Text(
                    '%${(progress * 100).toInt()}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showTargetDialog(BuildContext context) async {
    final controller = TextEditingController(text: _dailyTarget.toString());
    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Günlük Hedef'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Yeni Hedef',
            suffixText: 'kelime',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () {
              final val = int.tryParse(controller.text);
              if (val != null && val > 0) {
                Navigator.pop(context, val);
              }
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );

    if (result != null) {
      _handleDailyTargetChanged(result);
    }
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
