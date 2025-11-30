import '../entities/study_word.dart';
import '../repositories/study_plan_repository.dart';

/// Yeni kelimeler getirme use-case'i.
class FetchNewWords {
  FetchNewWords(this._repository);

  final StudyPlanRepository _repository;

  Future<List<StudyWord>> call(int count) => _repository.fetchNewWords(count);
}
