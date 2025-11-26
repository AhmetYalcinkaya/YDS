import 'package:flutter/material.dart';

import '../../domain/entities/study_word.dart';
import '../../../../shared/widgets/word_card.dart';

/// Kelime listesini kaydırılabilir olarak gösterir.
class WordListView extends StatelessWidget {
  const WordListView({required this.words, super.key});

  final List<StudyWord> words;

  @override
  Widget build(BuildContext context) {
    if (words.isEmpty) {
      return const Center(child: Text('Bugün için kelime bulunamadı.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: words.length,
      itemBuilder: (context, index) => WordCard(word: words[index]),
    );
  }
}

