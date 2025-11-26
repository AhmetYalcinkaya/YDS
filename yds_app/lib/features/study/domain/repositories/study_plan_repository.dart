import '../entities/study_plan.dart';

/// Çalışma planı veri operasyonları için sözleşme.
abstract class StudyPlanRepository {
  Future<StudyPlan> loadDailyPlan();
}


