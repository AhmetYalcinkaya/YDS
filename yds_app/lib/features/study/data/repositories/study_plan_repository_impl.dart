import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yds_app/core/constants/app_constants.dart';

import '../../domain/entities/study_plan.dart';
import '../../domain/entities/study_word.dart';
import '../../domain/repositories/study_plan_repository.dart';
import '../../domain/services/spaced_repetition_service.dart';
import '../../../../shared/widgets/difficulty_rating_widget.dart';

/// Yerel/mock veri kaynağı ile çalışan repository.
class StudyPlanRepositoryImpl implements StudyPlanRepository {
  StudyPlanRepositoryImpl(this._supabaseClient);

  final SupabaseClient _supabaseClient;

  @override
  Future<StudyPlan> loadDailyPlan() async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    // 1. Fetch words due for review (where next_review_date <= now)
    final dueProgressResponse = await _supabaseClient
        .from('user_progress')
        .select('word_id')
        .eq('user_id', userId)
        .lte('next_review_date', DateTime.now().toIso8601String());

    final dueWordIds = (dueProgressResponse as List)
        .map((e) => e['word_id'] as String)
        .toList();

    // 2. If we need more words to reach daily target, fetch new words
    // For simplicity, we'll just fetch random words that are NOT in user_progress
    // In a real app, we'd want a more sophisticated selection strategy

    List<Map<String, dynamic>> newWordsData = [];
    if (dueWordIds.length < AppConstants.dailyNewWordTarget) {
      // Fetch all progress word IDs to exclude
      final allProgressResponse = await _supabaseClient
          .from('user_progress')
          .select('word_id')
          .eq('user_id', userId);
      final allProgressWordIds = (allProgressResponse as List)
          .map((e) => e['word_id'] as String)
          .toList();

      final limit = AppConstants.dailyNewWordTarget - dueWordIds.length;

      // Supabase doesn't have a simple "not in" for large lists or "random" easily exposed via client without RPC
      // For this MVP, we'll fetch a batch of words and filter client-side or use a simple range if IDs were integers.
      // Since IDs are UUIDs, we can't do range.
      // We will fetch words where id is NOT in allProgressWordIds.

      var query = _supabaseClient.from('words').select();
      if (allProgressWordIds.isNotEmpty) {
        query = query.not('id', 'in', '(${allProgressWordIds.join(',')})');
      }

      final response = await query.limit(limit);
      newWordsData = List<Map<String, dynamic>>.from(response);
    }

    // 3. Fetch details for due words
    List<Map<String, dynamic>> dueWordsData = [];
    if (dueWordIds.isNotEmpty) {
      final response = await _supabaseClient
          .from('words')
          .select()
          .inFilter('id', dueWordIds);
      dueWordsData = List<Map<String, dynamic>>.from(response);
    }

    final allWordsData = [...dueWordsData, ...newWordsData];

    final words = allWordsData
        .map(
          (data) => StudyWord(
            id: data['id'] as String,
            english: data['english'] as String,
            turkish: data['turkish'] as String,
            partOfSpeech: (data['part_of_speech'] as String?) ?? 'noun',
            exampleSentence: (data['example_sentence'] as String?) ?? '',
            masteryScore: 0,
          ),
        )
        .toList();

    return StudyPlan(
      dueWords: words,
      dailyTarget: AppConstants.dailyNewWordTarget,
      completedToday: 0,
    );
  }

  @override
  Future<void> updateProgress(String wordId, Difficulty difficulty) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    final nextReviewDate = SpacedRepetitionService.calculateNextReviewDate(
      difficulty,
    );

    // Upsert user_progress
    await _supabaseClient.from('user_progress').upsert({
      'user_id': userId,
      'word_id': wordId,
      'next_review_date': nextReviewDate.toIso8601String(),
      'interval': difficulty == Difficulty.easy
          ? 4
          : (difficulty == Difficulty.medium ? 2 : 1),
      'ease_factor': 2.5, // Default ease factor
    });
  }
}
