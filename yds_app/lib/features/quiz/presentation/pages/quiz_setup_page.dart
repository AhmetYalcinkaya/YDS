import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../study/domain/repositories/study_plan_repository.dart';
import '../../../study/presentation/providers/study_plan_controller.dart';
import 'quiz_page.dart';

/// Quiz setup/configuration page
class QuizSetupPage extends ConsumerStatefulWidget {
  const QuizSetupPage({super.key});

  @override
  ConsumerState<QuizSetupPage> createState() => _QuizSetupPageState();
}

class _QuizSetupPageState extends ConsumerState<QuizSetupPage> {
  int _selectedQuestionCount = 20;
  String? _selectedCategory;
  String? _selectedDifficulty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Quiz'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Icon(
              Icons.quiz,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Kelime Bilgini Test Et!',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Öğrendiğin kelimeleri çoktan seçmeli sorularla pekiştir',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Question count selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Soru Sayısı',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [10, 20, 30, 50].map((count) {
                        return ChoiceChip(
                          label: Text('$count Soru'),
                          selected: _selectedQuestionCount == count,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedQuestionCount = count);
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Category filter
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kategori (Opsiyonel)',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildFilterChip('Tümü', null, _selectedCategory, (
                          value,
                        ) {
                          setState(() => _selectedCategory = value);
                        }),
                        _buildFilterChip('İsim', 'noun', _selectedCategory, (
                          value,
                        ) {
                          setState(() => _selectedCategory = value);
                        }),
                        _buildFilterChip('Fiil', 'verb', _selectedCategory, (
                          value,
                        ) {
                          setState(() => _selectedCategory = value);
                        }),
                        _buildFilterChip(
                          'Sıfat',
                          'adjective',
                          _selectedCategory,
                          (value) {
                            setState(() => _selectedCategory = value);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Difficulty filter
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Zorluk Seviyesi (Opsiyonel)',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildFilterChip('Tümü', null, _selectedDifficulty, (
                          value,
                        ) {
                          setState(() => _selectedDifficulty = value);
                        }),
                        _buildFilterChip('A1', 'A1', _selectedDifficulty, (
                          value,
                        ) {
                          setState(() => _selectedDifficulty = value);
                        }),
                        _buildFilterChip('A2', 'A2', _selectedDifficulty, (
                          value,
                        ) {
                          setState(() => _selectedDifficulty = value);
                        }),
                        _buildFilterChip('B1', 'B1', _selectedDifficulty, (
                          value,
                        ) {
                          setState(() => _selectedDifficulty = value);
                        }),
                        _buildFilterChip('B2', 'B2', _selectedDifficulty, (
                          value,
                        ) {
                          setState(() => _selectedDifficulty = value);
                        }),
                        _buildFilterChip('C1', 'C1', _selectedDifficulty, (
                          value,
                        ) {
                          setState(() => _selectedDifficulty = value);
                        }),
                        _buildFilterChip('C2', 'C2', _selectedDifficulty, (
                          value,
                        ) {
                          setState(() => _selectedDifficulty = value);
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Start button
            FilledButton.icon(
              onPressed: _startQuiz,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Quiz\'e Başla'),
              style: FilledButton.styleFrom(padding: const EdgeInsets.all(16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    String? value,
    String? currentValue,
    Function(String?) onSelected,
  ) {
    return ChoiceChip(
      label: Text(label),
      selected: currentValue == value,
      onSelected: (selected) => onSelected(selected ? value : null),
    );
  }

  Future<void> _startQuiz() async {
    try {
      // Show loading
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Navigate to quiz page
      if (!mounted) return;
      Navigator.pop(context); // Close loading

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizPage(
            questionCount: _selectedQuestionCount,
            category: _selectedCategory,
            difficulty: _selectedDifficulty,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Close loading if still open

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }
}
