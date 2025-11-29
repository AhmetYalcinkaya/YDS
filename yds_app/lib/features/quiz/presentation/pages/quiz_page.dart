import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/quiz_generator.dart';
import '../../domain/entities/quiz_question.dart';
import '../../domain/entities/quiz_result.dart';
import '../../../study/presentation/providers/study_plan_controller.dart';
import '../../../gamification/data/repositories/gamification_repository_impl.dart';
import '../../../gamification/presentation/providers/gamification_provider.dart';
import 'quiz_result_page.dart';

/// Main quiz gameplay page
class QuizPage extends ConsumerStatefulWidget {
  const QuizPage({
    super.key,
    required this.questionCount,
    this.category,
    this.difficulty,
  });

  final int questionCount;
  final String? category;
  final String? difficulty;

  @override
  ConsumerState<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends ConsumerState<QuizPage> {
  List<QuizQuestion>? _questions;
  int _currentQuestionIndex = 0;
  final List<int> _userAnswers = [];
  int? _selectedAnswer;
  bool _isLoading = true;
  String? _error;
  late DateTime _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _loadQuiz();
  }

  Future<void> _loadQuiz() async {
    try {
      final generator = QuizGenerator(ref.read(studyPlanRepositoryProvider));
      final questions = await generator.generateQuiz(
        questionCount: widget.questionCount,
        category: widget.category,
        difficulty: widget.difficulty,
      );

      setState(() {
        _questions = questions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz Yükleniyor...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Hata')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Geri Dön'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final question = _questions![_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / _questions!.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Soru ${_currentQuestionIndex + 1}/${_questions!.length}'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Question
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      question.correctWord.english,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            question.correctWord.category.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Options
            Expanded(
              child: ListView.builder(
                itemCount: question.options.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedAnswer == index;

                  Color? backgroundColor;
                  Color? borderColor;

                  if (isSelected) {
                    backgroundColor = Theme.of(
                      context,
                    ).colorScheme.primaryContainer;
                    borderColor = Theme.of(context).colorScheme.primary;
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () => _selectAnswer(index),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: borderColor ?? Colors.grey[300]!,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: borderColor?.withOpacity(0.2),
                                border: Border.all(
                                  color: borderColor ?? Colors.grey,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  String.fromCharCode(65 + index), // A, B, C, D
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: borderColor ?? Colors.grey[700],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                question.options[index],
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : null,
                                    ),
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Next button
            if (_selectedAnswer != null)
              FilledButton(
                onPressed: _nextQuestion,
                child: Text(
                  _currentQuestionIndex < _questions!.length - 1
                      ? 'Sonraki Soru'
                      : 'Sonuçları Gör',
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _selectAnswer(int index) {
    setState(() {
      _selectedAnswer = index;
    });
  }

  void _nextQuestion() {
    // Save answer
    _userAnswers.add(_selectedAnswer!);

    if (_currentQuestionIndex < _questions!.length - 1) {
      // Next question
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
      });
    } else {
      // Quiz completed
      _showResults();
    }
  }

  Future<void> _showResults() async {
    final timeTaken = DateTime.now().difference(_startTime);
    final correctAnswers = _userAnswers.asMap().entries.where((entry) {
      return entry.value == _questions![entry.key].correctIndex;
    }).length;

    // Award XP and check badges
    final earnedBadges = await _awardQuizRewards(
      correctAnswers,
      _questions!.length,
    );

    if (!mounted) return;

    final result = QuizResult(
      totalQuestions: _questions!.length,
      correctAnswers: correctAnswers,
      wrongAnswers: _questions!.length - correctAnswers,
      timeTaken: timeTaken,
      questions: _questions!,
      userAnswers: _userAnswers,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
        builder: (context) =>
            QuizResultPage(result: result, earnedBadges: earnedBadges),
      ),
    );
  }

  Future<List<String>> _awardQuizRewards(
    int correctAnswers,
    int totalQuestions,
  ) async {
    final earnedBadges = <String>[];
    if (correctAnswers > 0) {
      // 10 XP per correct answer
      final xpEarned = correctAnswers * 10;
      await ref.read(gamificationRepositoryProvider).addXp(xpEarned);

      // Check for quiz badges
      final badges = await ref
          .read(gamificationRepositoryProvider)
          .checkQuizBadges(correctAnswers, totalQuestions);

      earnedBadges.addAll(badges);

      // Refresh user stats
      ref.invalidate(userStatsProvider);
    }
    return earnedBadges;
  }
}
