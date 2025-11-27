import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yds_app/core/constants/app_constants.dart';

import '../../domain/entities/study_plan.dart';
import '../../domain/entities/study_statistics.dart';
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

    // 0. Fetch user's daily target
    final userResponse = await _supabaseClient
        .from('users')
        .select('daily_target')
        .eq('id', userId)
        .maybeSingle();

    final dailyTarget =
        (userResponse?['daily_target'] as int?) ??
        AppConstants.dailyNewWordTarget;

    // 1. Fetch words due for review (where next_review_date <= now)
    final dueProgressResponse = await _supabaseClient
        .from('user_progress')
        .select('word_id, user_word_id')
        .eq('user_id', userId)
        .lte('next_review_date', DateTime.now().toIso8601String());

    final dueGlobalWordIds = (dueProgressResponse as List)
        .where((e) => e['word_id'] != null)
        .map((e) => e['word_id'] as String)
        .toList();

    final dueUserWordIds = (dueProgressResponse)
        .where((e) => e['user_word_id'] != null)
        .map((e) => e['user_word_id'] as String)
        .toList();

    // 2. Fetch details for due words
    List<StudyWord> dueWords = [];

    if (dueGlobalWordIds.isNotEmpty) {
      final response = await _supabaseClient
          .from('words')
          .select()
          .inFilter('id', dueGlobalWordIds);
      dueWords.addAll(
        (response as List).map((data) => _mapToStudyWord(data, false)),
      );
    }

    if (dueUserWordIds.isNotEmpty) {
      final response = await _supabaseClient
          .from('user_words')
          .select()
          .inFilter('id', dueUserWordIds);
      dueWords.addAll(
        (response as List).map((data) => _mapToStudyWord(data, true)),
      );
    }

    // 3. If we need more words to reach daily target, fetch new words
    List<StudyWord> newWords = [];
    final neededCount = dailyTarget - dueWords.length;

    // Fetch all progress word IDs to exclude
    final allProgressResponse = await _supabaseClient
        .from('user_progress')
        .select('word_id, user_word_id')
        .eq('user_id', userId);

    final excludeGlobalIds = (allProgressResponse as List)
        .where((e) => e['word_id'] != null)
        .map((e) => e['word_id'] as String)
        .toList();

    final excludeUserIds = (allProgressResponse)
        .where((e) => e['user_word_id'] != null)
        .map((e) => e['user_word_id'] as String)
        .toList();

    // Fetch new user words first (prioritize user's own words)
    var userWordsQuery = _supabaseClient.from('user_words').select();

    if (excludeUserIds.isNotEmpty) {
      userWordsQuery = userWordsQuery.not(
        'id',
        'in',
        '(${excludeUserIds.join(',')})',
      );
    }

    // Sort by created_at descending to show newest words first
    final userWordsOrdered = userWordsQuery.order(
      'created_at',
      ascending: false,
    );

    // Always fetch at least 5 newest user words if available, or fill neededCount
    final fetchCount = neededCount > 0 ? neededCount : 5;
    final newUserWordsResponse = await userWordsOrdered.limit(fetchCount);
    final newUserWords = (newUserWordsResponse as List)
        .map((data) => _mapToStudyWord(data, true))
        .toList();

    newWords.addAll(newUserWords);

    // If still need more, fetch global words
    final remainingCount = neededCount - newWords.length;
    if (remainingCount > 0) {
      var globalWordsQuery = _supabaseClient.from('words').select();
      if (excludeGlobalIds.isNotEmpty) {
        globalWordsQuery = globalWordsQuery.not(
          'id',
          'in',
          '(${excludeGlobalIds.join(',')})',
        );
      }
      final newGlobalWordsResponse = await globalWordsQuery.limit(
        remainingCount,
      );
      final newGlobalWords = (newGlobalWordsResponse as List)
          .map((data) => _mapToStudyWord(data, false))
          .toList();

      newWords.addAll(newGlobalWords);
    }

    return StudyPlan(
      dueWords: [...dueWords, ...newWords],
      dailyTarget: dailyTarget,
      completedToday: 0,
    );
  }

  StudyWord _mapToStudyWord(Map<String, dynamic> data, bool isUserWord) {
    return StudyWord(
      id: data['id'] as String,
      english: data['english'] as String,
      turkish: data['turkish'] as String,
      partOfSpeech: (data['part_of_speech'] as String?) ?? 'noun',
      exampleSentence: (data['example_sentence'] as String?) ?? '',
      masteryScore: 0,
      isUserWord: isUserWord,
    );
  }

  @override
  Future<void> updateProgress(
    String wordId,
    Difficulty difficulty, {
    bool isUserWord = false,
  }) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    final nextReviewDate = SpacedRepetitionService.calculateNextReviewDate(
      difficulty,
    );

    final data = {
      'user_id': userId,
      'next_review_date': nextReviewDate.toIso8601String(),
      'interval': difficulty == Difficulty.easy
          ? 4
          : (difficulty == Difficulty.medium ? 2 : 1),
      'ease_factor': 2.5,
    };

    if (isUserWord) {
      data['user_word_id'] = wordId;
    } else {
      data['word_id'] = wordId;
    }

    // Check if record exists
    final existing = await _supabaseClient
        .from('user_progress')
        .select('id')
        .eq('user_id', userId)
        .eq(isUserWord ? 'user_word_id' : 'word_id', wordId)
        .maybeSingle();

    if (existing != null) {
      await _supabaseClient
          .from('user_progress')
          .update(data)
          .eq('id', existing['id']);
    } else {
      await _supabaseClient.from('user_progress').insert(data);
    }
  }

  @override
  Future<StudyStatistics> getStatistics() async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    // 1. Total words studied
    final totalCountResponse = await _supabaseClient
        .from('user_progress')
        .select('id')
        .eq('user_id', userId)
        .count(CountOption.exact);
    final totalWords = totalCountResponse.count;

    // 2. Mastered words (interval > 14 days)
    final masteredCountResponse = await _supabaseClient
        .from('user_progress')
        .select('id')
        .eq('user_id', userId)
        .gt('interval', 14)
        .count(CountOption.exact);
    final masteredWords = masteredCountResponse.count;

    // 3. Learning words (total - mastered)
    final learningWords = totalWords - masteredWords;

    // 4. Streak (Placeholder for now)
    const streakDays = 0;

    return StudyStatistics(
      totalWordsStudied: totalWords,
      masteredWords: masteredWords,
      learningWords: learningWords,
      streakDays: streakDays,
    );
  }

  @override
  Future<void> updateDailyTarget(int target) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    // Check if user record exists
    final existingUser = await _supabaseClient
        .from('users')
        .select('id')
        .eq('id', userId)
        .maybeSingle();

    if (existingUser != null) {
      await _supabaseClient
          .from('users')
          .update({'daily_target': target})
          .eq('id', userId);
    } else {
      // Create user record if not exists (should exist from trigger, but safe fallback)
      await _supabaseClient.from('users').insert({
        'id': userId,
        'daily_target': target,
      });
    }
  }

  @override
  Future<Map<String, dynamic>?> getUserProfile() async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return null;

    return await _supabaseClient
        .from('users')
        .select()
        .eq('id', userId)
        .maybeSingle();
  }

  @override
  Future<List<StudyWord>> getWordsByStatus(WordStatus status) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    // 1. Get word IDs from user_progress based on status
    var query = _supabaseClient
        .from('user_progress')
        .select('word_id, user_word_id')
        .eq('user_id', userId);

    if (status == WordStatus.mastered) {
      query = query.gt('interval', 14);
    } else if (status == WordStatus.learning) {
      query = query.lte('interval', 14);
    }

    final progressResponse = await query;

    final globalWordIds = (progressResponse as List)
        .where((e) => e['word_id'] != null)
        .map((e) => e['word_id'] as String)
        .toList();

    final userWordIds = (progressResponse)
        .where((e) => e['user_word_id'] != null)
        .map((e) => e['user_word_id'] as String)
        .toList();

    List<StudyWord> words = [];

    // 2. Fetch word details
    if (globalWordIds.isNotEmpty) {
      final response = await _supabaseClient
          .from('words')
          .select()
          .inFilter('id', globalWordIds);
      words.addAll(
        (response as List).map((data) => _mapToStudyWord(data, false)),
      );
    }

    if (userWordIds.isNotEmpty) {
      final response = await _supabaseClient
          .from('user_words')
          .select()
          .inFilter('id', userWordIds);
      words.addAll(
        (response as List).map((data) => _mapToStudyWord(data, true)),
      );
    }

    return words;
  }
}
