import 'dart:math';
import '../../study/domain/entities/study_word.dart';
import '../../study/domain/repositories/study_plan_repository.dart';
import '../domain/entities/quiz_question.dart';

/// Service for generating quiz questions
class QuizGenerator {
  QuizGenerator(this._repository);

  final StudyPlanRepository _repository;
  final _random = Random();

  /// Generate a quiz with specified number of questions
  Future<List<QuizQuestion>> generateQuiz({
    required int questionCount,
    String? category,
    String? difficulty,
  }) async {
    // Fetch all words (mastered + learning)
    final masteredWords = await _repository.getWordsByStatus(
      WordStatus.mastered,
    );
    final learningWords = await _repository.getWordsByStatus(
      WordStatus.learning,
    );

    var allWords = [...masteredWords, ...learningWords];

    // Apply filters
    if (category != null) {
      allWords = allWords.where((w) => w.category == category).toList();
    }
    if (difficulty != null) {
      allWords = allWords
          .where((w) => w.difficultyLevel == difficulty)
          .toList();
    }

    // Check if we have enough words
    if (allWords.length < 4) {
      throw Exception(
        'En az 4 kelime gerekli. Lütfen daha fazla kelime öğrenin.',
      );
    }

    // Limit question count to available words
    final actualQuestionCount = min(questionCount, allWords.length);

    // Shuffle and select words for questions
    allWords.shuffle(_random);
    final selectedWords = allWords.take(actualQuestionCount).toList();

    // Generate questions
    final questions = <QuizQuestion>[];
    for (final word in selectedWords) {
      final question = _generateQuestion(word, allWords);
      questions.add(question);
    }

    return questions;
  }

  /// Generate a single question with 4 options
  QuizQuestion _generateQuestion(
    StudyWord correctWord,
    List<StudyWord> allWords,
  ) {
    // Get wrong options (different words)
    final wrongWords = allWords.where((w) => w.id != correctWord.id).toList()
      ..shuffle(_random);

    // Take 3 wrong answers
    final wrongOptions = wrongWords.take(3).map((w) => w.turkish).toList();

    // Create options list with correct answer
    final options = [...wrongOptions, correctWord.turkish];

    // Shuffle options
    options.shuffle(_random);

    // Find correct index after shuffling
    final correctIndex = options.indexOf(correctWord.turkish);

    return QuizQuestion(
      correctWord: correctWord,
      options: options,
      correctIndex: correctIndex,
    );
  }
}
