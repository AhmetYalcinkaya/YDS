import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/supabase_client_provider.dart';
import '../../data/repositories/study_plan_repository_impl.dart';
import '../../domain/entities/study_plan.dart';
import '../../domain/repositories/study_plan_repository.dart';
import '../../domain/usecases/get_daily_plan.dart';

/// Çalışma planı durumunu yöneten controller.
class StudyPlanController extends StateNotifier<AsyncValue<StudyPlan>> {
  StudyPlanController(this._getDailyPlan) : super(const AsyncValue.loading());

  final GetDailyPlan _getDailyPlan;

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
}

/// Repository provider'ı.
final studyPlanRepositoryProvider = Provider<StudyPlanRepository>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return StudyPlanRepositoryImpl(supabaseClient);
});

/// Use-case provider'ı.
final getDailyPlanProvider = Provider<GetDailyPlan>((ref) {
  return GetDailyPlan(ref.read(studyPlanRepositoryProvider));
});

/// Controller provider'ı.
final studyPlanControllerProvider =
    StateNotifierProvider<StudyPlanController, AsyncValue<StudyPlan>>((ref) {
  final controller = StudyPlanController(ref.read(getDailyPlanProvider));
  controller.loadPlan();
  return controller;
});

