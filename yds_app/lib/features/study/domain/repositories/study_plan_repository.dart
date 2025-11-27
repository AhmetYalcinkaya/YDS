import 'package:yds_app/features/study/domain/entities/study_word.dart';

import '../../../../shared/widgets/difficulty_rating_widget.dart';
import '../entities/study_plan.dart';

import '../entities/study_statistics.dart';

/// Repository arayüzü: günlük çalışma planını yükler.
abstract class StudyPlanRepository {
  Future<StudyPlan> loadDailyPlan();
  Future<void> updateProgress(
    String wordId,
    Difficulty difficulty, {
    bool isUserWord = false,
  });
  Future<StudyStatistics> getStatistics();
  Future<void> updateDailyTarget(int target);
  Future<Map<String, dynamic>?> getUserProfile();
  Future<List<StudyWord>> getWordsByStatus(WordStatus status);
}

enum WordStatus { all, mastered, learning }
