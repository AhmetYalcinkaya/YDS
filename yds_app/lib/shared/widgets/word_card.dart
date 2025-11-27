import 'package:flutter/material.dart';
import '../../features/study/domain/entities/study_word.dart';
import 'flip_card_widget.dart';
import 'difficulty_rating_widget.dart';

/// Word card with flip animation and difficulty rating
class WordCard extends StatelessWidget {
  const WordCard({
    required this.word,
    required this.onDifficultySelected,
    super.key,
  });

  final StudyWord word;
  final void Function(Difficulty difficulty) onDifficultySelected;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FlipCardWidget(
              frontChild: _buildFront(context),
              backChild: _buildBack(context),
            ),
            const SizedBox(height: 16),
            const Text(
              'Kartı çevirmek için dokunun',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            DifficultyRatingWidget(onRatingSelected: onDifficultySelected),
          ],
        ),
      ),
    );
  }

  Widget _buildFront(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              word.english,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              word.partOfSpeech,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onPrimaryContainer.withOpacity(0.7),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBack(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            word.turkish,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
            textAlign: TextAlign.center,
          ),
          if (word.exampleSentence.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              word.exampleSentence,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSecondaryContainer.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
