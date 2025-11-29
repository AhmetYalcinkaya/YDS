import 'package:flutter/material.dart';
import '../../features/study/domain/entities/study_word.dart';
import '../../core/services/tts_service.dart';
import 'flip_card_widget.dart';
import 'difficulty_rating_widget.dart';

/// Word card with flip animation and difficulty rating
class WordCard extends StatelessWidget {
  const WordCard({
    required this.word,
    required this.onDifficultySelected,
    this.onFavoriteToggle,
    super.key,
  });

  final StudyWord word;
  final void Function(Difficulty difficulty) onDifficultySelected;
  final VoidCallback? onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.volume_up),
                  onPressed: () {
                    TtsService().speak(word.english);
                  },
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  tooltip: 'Telaffuz dinle',
                ),
                if (onFavoriteToggle != null)
                  IconButton(
                    icon: Icon(
                      word.isFavorite ? Icons.star : Icons.star_border,
                    ),
                    onPressed: onFavoriteToggle,
                    color: word.isFavorite
                        ? Colors.amber
                        : Theme.of(context).colorScheme.onPrimaryContainer,
                    tooltip: word.isFavorite
                        ? 'Favorilerden çıkar'
                        : 'Favorilere ekle',
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildBadge(
                  context,
                  word.category,
                  Theme.of(
                    context,
                  ).colorScheme.onPrimaryContainer.withOpacity(0.2),
                ),
                const SizedBox(width: 8),
                _buildBadge(
                  context,
                  word.difficultyLevel,
                  Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(BuildContext context, String text, Color backgroundColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text.toUpperCase(),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
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
