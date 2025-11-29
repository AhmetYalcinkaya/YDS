import 'package:freezed_annotation/freezed_annotation.dart';

part 'study_statistics.freezed.dart';
part 'study_statistics.g.dart';

@freezed
class StudyStatistics with _$StudyStatistics {
  const factory StudyStatistics({
    required int totalWordsStudied,
    required int masteredWords,
    required int learningWords,
    required int streakDays,
    @Default(0) int favoriteCount,
  }) = _StudyStatistics;

  factory StudyStatistics.fromJson(Map<String, dynamic> json) =>
      _$StudyStatisticsFromJson(json);
}
