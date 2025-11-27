import '../repositories/study_plan_repository.dart';
import '../../../../shared/widgets/difficulty_rating_widget.dart';

/// Use case to update user progress after word review
class UpdateUserProgress {
  UpdateUserProgress(this._repository);

  final StudyPlanRepository _repository;

  Future<void> call(String wordId, Difficulty difficulty) async {
    await _repository.updateProgress(wordId, difficulty);
  }
}
