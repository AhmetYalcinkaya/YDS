import 'package:yds_app/features/study/domain/entities/study_word.dart';

import '../../../../shared/widgets/difficulty_rating_widget.dart';
import '../entities/study_plan.dart';

import '../entities/study_statistics.dart';

/// Repository arayüzü: günlük çalışma planını yükler.
abstract class StudyPlanRepository {
  Future<StudyPlan> loadDailyPlan();
  Future<List<StudyWord>> fetchNewWords(int count);
  Future<void> updateProgress(
    String wordId,
    Difficulty difficulty, {
    bool isUserWord = false,
  });
  Future<StudyStatistics> getStatistics();
  Future<void> updateDailyTarget(int target);
  Future<Map<String, dynamic>?> getUserProfile();
  Future<List<StudyWord>> getWordsByStatus(WordStatus status);
  Future<void> deleteUserWord(String id);
  Future<void> updateUserWord(StudyWord word);

  // Statistics methods
  Future<Map<String, int>> getWeeklyProgress();
  Future<Map<String, int>> getCategoryBreakdown();
  Future<Map<String, int>> getDifficultyBreakdown();

  // Favorites
  Future<void> toggleFavorite(String wordId, {bool isUserWord = false});
}

enum WordStatus { all, mastered, learning, favorites }
