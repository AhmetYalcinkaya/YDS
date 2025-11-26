import '../entities/study_plan.dart';
import '../repositories/study_plan_repository.dart';

/// Günlük planı yükleme use-case'i.
class GetDailyPlan {
  GetDailyPlan(this._repository);

  final StudyPlanRepository _repository;

  Future<StudyPlan> call() => _repository.loadDailyPlan();
}


