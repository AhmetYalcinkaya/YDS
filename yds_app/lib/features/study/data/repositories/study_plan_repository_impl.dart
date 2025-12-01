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
    int dailyTarget = AppConstants.dailyNewWordTarget;
    try {
      final userResponse = await _supabaseClient
          .from('users')
          .select('daily_target')
          .eq('id', userId)
          .maybeSingle();

      if (userResponse != null && userResponse['daily_target'] != null) {
        dailyTarget = userResponse['daily_target'] as int;
      }
    } catch (e) {
      // Ignore error and use default
    }

    // 1. Fetch words due for review (where next_review_date <= now)
    // Limit to dailyTarget to avoid loading too many words
    final dueProgressResponse = await _supabaseClient
        .from('user_progress')
        .select('word_id, user_word_id, is_favorite')
        .eq('user_id', userId)
        .lte('next_review_date', DateTime.now().toIso8601String())
        .limit(dailyTarget);

    // Create maps to store favorite status
    final Map<String, bool> globalWordFavorites = {};
    final Map<String, bool> userWordFavorites = {};

    final dueGlobalWordIds = (dueProgressResponse as List)
        .where((e) => e['word_id'] != null)
        .map((e) {
          final wordId = e['word_id'] as String;
          globalWordFavorites[wordId] = e['is_favorite'] as bool? ?? false;
          return wordId;
        })
        .toList();

    final dueUserWordIds = (dueProgressResponse)
        .where((e) => e['user_word_id'] != null)
        .map((e) {
          final wordId = e['user_word_id'] as String;
          userWordFavorites[wordId] = e['is_favorite'] as bool? ?? false;
          return wordId;
        })
        .toList();

    // 2. Fetch details for due words
    List<StudyWord> dueWords = [];

    if (dueGlobalWordIds.isNotEmpty) {
      final response = await _supabaseClient
          .from('words')
          .select()
          .inFilter('id', dueGlobalWordIds);
      dueWords.addAll(
        (response as List).map((data) {
          data['is_favorite'] = globalWordFavorites[data['id']] ?? false;
          return _mapToStudyWord(data, false);
        }),
      );
    }

    if (dueUserWordIds.isNotEmpty) {
      final response = await _supabaseClient
          .from('user_words')
          .select()
          .inFilter('id', dueUserWordIds);
      dueWords.addAll(
        (response as List).map((data) {
          data['is_favorite'] = userWordFavorites[data['id']] ?? false;
          return _mapToStudyWord(data, true);
        }),
      );
    }

    // 3. If we need more words to reach daily target, fetch new words
    final neededCount = dailyTarget - dueWords.length;
    if (neededCount > 0) {
      final newWords = await fetchNewWords(neededCount);
      dueWords.addAll(newWords);
    }

    // Calculate how many words were studied today
    int completedToday = 0;
    try {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);

      final todayProgressResponse = await _supabaseClient
          .from('user_progress')
          .select('id')
          .eq('user_id', userId)
          .gte('created_at', startOfDay.toIso8601String());

      completedToday = (todayProgressResponse as List).length;
    } catch (e) {
      // Ignore error, default to 0
    }

    return StudyPlan(
      dailyTarget: dailyTarget,
      dueWords: dueWords,
      completedToday: completedToday,
    );
  }

  @override
  Future<List<StudyWord>> fetchNewWords(int count) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return [];

    List<StudyWord> newWords = [];

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

    // Fetch user words
    final newUserWordsResponse = await userWordsOrdered.limit(count);
    final newUserWords = (newUserWordsResponse as List)
        .map((data) => _mapToStudyWord(data, true))
        .toList();

    newWords.addAll(newUserWords);

    // If still need more, fetch global words
    final remainingCount = count - newWords.length;
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

    return newWords;
  }

  StudyWord _mapToStudyWord(Map<String, dynamic> data, bool isUserWord) {
    return StudyWord(
      id: (data['id'] as String?) ?? '',
      english: (data['english'] as String?) ?? '',
      turkish: (data['turkish'] as String?) ?? '',
      exampleSentence: (data['example_sentence'] as String?) ?? '',
      masteryScore: 0,
      isUserWord: isUserWord,
      category: (data['category'] as String?) ?? 'noun',
      difficultyLevel: (data['difficulty_level'] as String?) ?? 'B1',
      isFavorite: (data['is_favorite'] as bool?) ?? false,
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

    // Update streak
    await _updateUserStreak(userId);
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

    // 4. Streak
    int streakDays = 0;
    try {
      final userResponse = await _supabaseClient
          .from('users')
          .select('streak')
          .eq('id', userId)
          .maybeSingle();

      if (userResponse != null && userResponse['streak'] != null) {
        streakDays = userResponse['streak'] as int;
      }
    } catch (e) {
      // Ignore error
    }

    // 5. Favorites
    final globalFavoritesResponse = await _supabaseClient
        .from('user_progress')
        .select('id')
        .eq('user_id', userId)
        .eq('is_favorite', true)
        .count(CountOption.exact);

    final userFavoritesResponse = await _supabaseClient
        .from('user_words')
        .select('id')
        .eq('user_id', userId)
        .eq('is_favorite', true)
        .count(CountOption.exact);

    final favoriteCount =
        (globalFavoritesResponse.count) + (userFavoritesResponse.count);

    return StudyStatistics(
      totalWordsStudied: totalWords,
      masteredWords: masteredWords,
      learningWords: learningWords,
      streakDays: streakDays,
      favoriteCount: favoriteCount,
    );
  }

  Future<void> _updateUserStreak(String userId) async {
    try {
      final userResponse = await _supabaseClient
          .from('users')
          .select('last_study_date, streak')
          .eq('id', userId)
          .maybeSingle();

      if (userResponse == null) return;

      final lastStudyDateStr = userResponse['last_study_date'] as String?;
      final currentStreak = (userResponse['streak'] as int?) ?? 0;

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      DateTime? lastStudyDate;
      if (lastStudyDateStr != null) {
        lastStudyDate = DateTime.parse(lastStudyDateStr);
        // Normalize to date only
        lastStudyDate = DateTime(
          lastStudyDate.year,
          lastStudyDate.month,
          lastStudyDate.day,
        );
      }

      int newStreak = currentStreak;

      if (lastStudyDate == null) {
        // First time studying
        newStreak = 1;
      } else if (lastStudyDate == today) {
        // Already studied today, do nothing
        return;
      } else if (lastStudyDate == today.subtract(const Duration(days: 1))) {
        // Studied yesterday, increment streak
        newStreak++;
      } else {
        // Missed a day (or more), reset streak
        newStreak = 1;
      }

      await _supabaseClient
          .from('users')
          .update({
            'last_study_date': today.toIso8601String(),
            'streak': newStreak,
          })
          .eq('id', userId);
    } catch (e) {
      // Ignore error to not block study flow
      print('Error updating streak: $e');
    }
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
    } else if (status == WordStatus.favorites) {
      query = query.eq('is_favorite', true);
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

  @override
  Future<void> deleteUserWord(String id) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return;

    await _supabaseClient
        .from('user_words')
        .delete()
        .eq('id', id)
        .eq('user_id', userId);
  }

  @override
  Future<void> updateUserWord(StudyWord word) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return;

    await _supabaseClient
        .from('user_words')
        .update({
          'english': word.english,
          'turkish': word.turkish,
          'example_sentence': word.exampleSentence,
        })
        .eq('id', word.id)
        .eq('user_id', userId);
  }

  @override
  Future<Map<String, int>> getWeeklyProgress() async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return {};

    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));

    final response = await _supabaseClient
        .from('user_progress')
        .select('created_at')
        .eq('user_id', userId)
        .gte('created_at', sevenDaysAgo.toIso8601String());

    final progressList = response as List;
    final Map<String, int> dailyCounts = {};

    for (var i = 0; i < 7; i++) {
      final date = DateTime.now().subtract(Duration(days: 6 - i));
      final dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      dailyCounts[dateKey] = 0;
    }

    for (var item in progressList) {
      final createdAt = DateTime.parse(item['created_at'] as String);
      final dateKey =
          '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}';
      if (dailyCounts.containsKey(dateKey)) {
        dailyCounts[dateKey] = dailyCounts[dateKey]! + 1;
      }
    }

    return dailyCounts;
  }

  @override
  Future<Map<String, int>> getCategoryBreakdown() async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return {};

    final progressResponse = await _supabaseClient
        .from('user_progress')
        .select('word_id, user_word_id')
        .eq('user_id', userId);

    final globalWordIds = (progressResponse as List)
        .where((e) => e['word_id'] != null)
        .map((e) => e['word_id'] as String)
        .toList();

    final userWordIds = (progressResponse)
        .where((e) => e['user_word_id'] != null)
        .map((e) => e['user_word_id'] as String)
        .toList();

    final Map<String, int> categoryCount = {};

    if (globalWordIds.isNotEmpty) {
      final response = await _supabaseClient
          .from('words')
          .select('category')
          .inFilter('id', globalWordIds);

      for (var item in response as List) {
        final category = item['category'] as String? ?? 'other';
        categoryCount[category] = (categoryCount[category] ?? 0) + 1;
      }
    }

    if (userWordIds.isNotEmpty) {
      final response = await _supabaseClient
          .from('user_words')
          .select('category')
          .inFilter('id', userWordIds);

      for (var item in response as List) {
        final category = item['category'] as String? ?? 'other';
        categoryCount[category] = (categoryCount[category] ?? 0) + 1;
      }
    }

    return categoryCount;
  }

  @override
  Future<Map<String, int>> getDifficultyBreakdown() async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return {};

    final progressResponse = await _supabaseClient
        .from('user_progress')
        .select('word_id, user_word_id')
        .eq('user_id', userId);

    final globalWordIds = (progressResponse as List)
        .where((e) => e['word_id'] != null)
        .map((e) => e['word_id'] as String)
        .toList();

    final userWordIds = (progressResponse)
        .where((e) => e['user_word_id'] != null)
        .map((e) => e['user_word_id'] as String)
        .toList();

    final Map<String, int> difficultyCount = {};

    if (globalWordIds.isNotEmpty) {
      final response = await _supabaseClient
          .from('words')
          .select('difficulty_level')
          .inFilter('id', globalWordIds);

      for (var item in response as List) {
        final difficulty = item['difficulty_level'] as String? ?? 'B1';
        difficultyCount[difficulty] = (difficultyCount[difficulty] ?? 0) + 1;
      }
    }

    if (userWordIds.isNotEmpty) {
      final response = await _supabaseClient
          .from('user_words')
          .select('difficulty_level')
          .inFilter('id', userWordIds);

      for (var item in response as List) {
        final difficulty = item['difficulty_level'] as String? ?? 'B1';
        difficultyCount[difficulty] = (difficultyCount[difficulty] ?? 0) + 1;
      }
    }

    return difficultyCount;
  }

  @override
  Future<void> toggleFavorite(String wordId, {bool isUserWord = false}) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return;

    if (isUserWord) {
      // Toggle favorite for user word
      final currentResponse = await _supabaseClient
          .from('user_words')
          .select('is_favorite')
          .eq('id', wordId)
          .eq('user_id', userId)
          .maybeSingle();

      if (currentResponse != null) {
        final currentFavorite =
            currentResponse['is_favorite'] as bool? ?? false;
        await _supabaseClient
            .from('user_words')
            .update({'is_favorite': !currentFavorite})
            .eq('id', wordId)
            .eq('user_id', userId);
      }
    } else {
      // Toggle favorite for global word
      final currentResponse = await _supabaseClient
          .from('user_progress')
          .select('is_favorite')
          .eq('word_id', wordId)
          .eq('user_id', userId)
          .maybeSingle();

      if (currentResponse != null) {
        final currentFavorite =
            currentResponse['is_favorite'] as bool? ?? false;
        await _supabaseClient
            .from('user_progress')
            .update({'is_favorite': !currentFavorite})
            .eq('word_id', wordId)
            .eq('user_id', userId);
      } else {
        // Create new progress record with favorite=true
        await _supabaseClient.from('user_progress').insert({
          'user_id': userId,
          'word_id': wordId,
          'is_favorite': true,
          'interval': 0,
          'ease_factor': 2.5,
          'next_review_date': DateTime.now().toIso8601String(),
        });
      }
    }
  }
}
