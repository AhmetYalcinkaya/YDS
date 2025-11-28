import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../study/domain/entities/study_word.dart';

part 'quiz_question.freezed.dart';
part 'quiz_question.g.dart';

/// Represents a single quiz question with multiple choice options
@freezed
class QuizQuestion with _$QuizQuestion {
  const factory QuizQuestion({
    required StudyWord correctWord,
    required List<String> options, // 4 options including correct answer
    required int correctIndex, // Index of correct answer in options
  }) = _QuizQuestion;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) =>
      _$QuizQuestionFromJson(json);
}
