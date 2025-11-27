import '../../../../shared/widgets/difficulty_rating_widget.dart';
import '../entities/study_plan.dart';

/// Repository arayüzü: günlük çalışma planını yükler.
abstract class StudyPlanRepository {
  Future<StudyPlan> loadDailyPlan();
  Future<void> updateProgress(String wordId, Difficulty difficulty);
}
