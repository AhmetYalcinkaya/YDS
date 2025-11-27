import 'package:freezed_annotation/freezed_annotation.dart';

part 'study_word.freezed.dart';
part 'study_word.g.dart';

/// Çalışma listesinde gösterilecek kelime modelini temsil eder.
@freezed
class StudyWord with _$StudyWord {
  const factory StudyWord({
    required String id,
    required String english,
    required String turkish,
    required String partOfSpeech,
    required String exampleSentence,
    @Default(0) int masteryScore,
    @Default(false) bool isUserWord,
  }) = _StudyWord;

  factory StudyWord.fromJson(Map<String, dynamic> json) =>
      _$StudyWordFromJson(json);
}
