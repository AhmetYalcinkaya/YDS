import 'package:flutter/material.dart';

import '../../domain/entities/study_word.dart';
import '../../../../shared/widgets/word_card.dart';
import '../../../../shared/widgets/difficulty_rating_widget.dart';

/// Kelime listesini gösteren widget.
class WordListView extends StatelessWidget {
  const WordListView({
    required this.words,
    required this.onWordRated,
    super.key,
  });

  final List<StudyWord> words;
  final void Function(StudyWord word, Difficulty difficulty) onWordRated;

  @override
  Widget build(BuildContext context) {
    if (words.isEmpty) {
      return const Center(child: Text('Bugün için kelime kalmadı! 🎉'));
    }

    return ListView.builder(
      itemCount: words.length,
      itemBuilder: (context, index) {
        final word = words[index];
        return WordCard(
          word: word,
          onDifficultySelected: (difficulty) => onWordRated(word, difficulty),
        );
      },
    );
  }
}
