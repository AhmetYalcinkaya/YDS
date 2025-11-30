import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/supabase_client_provider.dart';
import '../../data/repositories/study_plan_repository_impl.dart';
import '../../domain/entities/study_plan.dart';
import '../../domain/repositories/study_plan_repository.dart';
import '../../domain/usecases/get_daily_plan.dart';

import '../../domain/usecases/fetch_new_words.dart';

/// Çalışma planı durumunu yöneten controller.
class StudyPlanController extends StateNotifier<AsyncValue<StudyPlan>> {
  StudyPlanController(this._getDailyPlan, this._fetchNewWords)
    : super(const AsyncValue.loading());

  final GetDailyPlan _getDailyPlan;
  final FetchNewWords _fetchNewWords;

  /// Güncel çalışma planını yükler.
  Future<void> loadPlan() async {
    try {
      state = const AsyncValue.loading();
      final plan = await _getDailyPlan();
      state = AsyncValue.data(plan);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Yeni kelimeler yükler ve plana ekler.
  Future<void> loadMoreWords(int count) async {
    try {
      final currentPlan = state.value;
      if (currentPlan == null) return;

      final newWords = await _fetchNewWords(count);

      // Add new words to the existing plan
      final updatedWords = [...currentPlan.dueWords, ...newWords];

      state = AsyncValue.data(currentPlan.copyWith(dueWords: updatedWords));
    } catch (error) {
      // Keep existing state but show error if needed
      // For now just log or ignore, as we don't want to lose current state
    }
  }

  /// Bir kelimeyi çalışıldı olarak işaretler ve listeden kaldırır.
  void markAsStudied(String wordId) {
    final currentPlan = state.value;
    if (currentPlan == null) return;

    final updatedWords = currentPlan.dueWords
        .where((w) => w.id != wordId)
        .toList();

    state = AsyncValue.data(
      currentPlan.copyWith(
        dueWords: updatedWords,
        completedToday: currentPlan.completedToday + 1,
      ),
    );
  }

  /// Günlük hedefi günceller.
  void updateDailyTarget(int newTarget) {
    final currentPlan = state.value;
    if (currentPlan == null) return;

    state = AsyncValue.data(currentPlan.copyWith(dailyTarget: newTarget));
  }
}

/// Repository provider'ı.
final studyPlanRepositoryProvider = Provider<StudyPlanRepository>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return StudyPlanRepositoryImpl(supabaseClient);
});

/// Use-case provider'ları.
final getDailyPlanProvider = Provider<GetDailyPlan>((ref) {
  return GetDailyPlan(ref.read(studyPlanRepositoryProvider));
});

final fetchNewWordsProvider = Provider<FetchNewWords>((ref) {
  return FetchNewWords(ref.read(studyPlanRepositoryProvider));
});

/// Controller provider'ı.
final studyPlanControllerProvider =
    StateNotifierProvider<StudyPlanController, AsyncValue<StudyPlan>>((ref) {
      final controller = StudyPlanController(
        ref.read(getDailyPlanProvider),
        ref.read(fetchNewWordsProvider),
      );
      controller.loadPlan();
      return controller;
    });
