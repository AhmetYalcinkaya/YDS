import 'package:freezed_annotation/freezed_annotation.dart';

import 'study_word.dart';

part 'study_plan.freezed.dart';
part 'study_plan.g.dart';

/// Günlük çalışma planını temsil eder.
@freezed
class StudyPlan with _$StudyPlan {
  const factory StudyPlan({
    required List<StudyWord> dueWords,
    required int dailyTarget,
    required int completedToday,
  }) = _StudyPlan;

  factory StudyPlan.fromJson(Map<String, dynamic> json) => _$StudyPlanFromJson(json);
}

