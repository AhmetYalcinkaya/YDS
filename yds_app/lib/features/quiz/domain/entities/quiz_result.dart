import 'package:freezed_annotation/freezed_annotation.dart';
import 'quiz_question.dart';

part 'quiz_result.freezed.dart';
part 'quiz_result.g.dart';

/// Represents the result of a completed quiz
@freezed
class QuizResult with _$QuizResult {
  const factory QuizResult({
    required int totalQuestions,
    required int correctAnswers,
    required int wrongAnswers,
    required Duration timeTaken,
    required List<QuizQuestion> questions,
    required List<int> userAnswers, // -1 for unanswered
  }) = _QuizResult;

  factory QuizResult.fromJson(Map<String, dynamic> json) =>
      _$QuizResultFromJson(json);
}

extension QuizResultExtension on QuizResult {
  double get percentage => (correctAnswers / totalQuestions) * 100;

  bool get isPerfect => correctAnswers == totalQuestions;

  String get grade {
    final percent = percentage;
    if (percent >= 90) return 'Mükemmel!';
    if (percent >= 75) return 'Çok İyi!';
    if (percent >= 60) return 'İyi!';
    if (percent >= 50) return 'Orta';
    return 'Daha Fazla Çalış';
  }
}
