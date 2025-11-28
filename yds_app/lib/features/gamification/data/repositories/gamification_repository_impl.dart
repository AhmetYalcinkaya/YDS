import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/user_stats.dart';
import '../../domain/entities/badge.dart';
import '../../domain/repositories/gamification_repository.dart';

final gamificationRepositoryProvider = Provider<GamificationRepository>((ref) {
  return GamificationRepositoryImpl(Supabase.instance.client);
});

class GamificationRepositoryImpl implements GamificationRepository {
  final SupabaseClient _supabase;

  GamificationRepositoryImpl(this._supabase);

  @override
  Future<UserStats> getUserStats() async {
    final userId = _supabase.auth.currentUser!.id;
    final response = await _supabase
        .from('user_stats')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) {
      // Create default stats for existing user
      final newStats = {
        'user_id': userId,
        'xp': 0,
        'level': 1,
        'current_streak': 0,
        'last_activity_date': DateTime.now().toIso8601String(),
      };

      // Use upsert with ignoreDuplicates to avoid exception
      await _supabase
          .from('user_stats')
          .upsert(newStats, onConflict: 'user_id', ignoreDuplicates: true);

      // Fetch the stats (whether newly created or existing)
      final retryResponse = await _supabase
          .from('user_stats')
          .select()
          .eq('user_id', userId)
          .single();

      return UserStats.fromJson(retryResponse);
    }

    return UserStats.fromJson(response);
  }

  @override
  Future<List<Badge>> getBadges() async {
    final userId = _supabase.auth.currentUser!.id;

    // Fetch all badges
    final badgesResponse = await _supabase.from('badges').select();
    final allBadges = (badgesResponse as List)
        .map((json) => Badge.fromJson(json))
        .toList();

    // Fetch user earned badges
    final userBadgesResponse = await _supabase
        .from('user_badges')
        .select('badge_id, earned_at')
        .eq('user_id', userId);

    final earnedBadgeIds = (userBadgesResponse as List)
        .map((e) => e['badge_id'] as String)
        .toSet();

    // Merge info
    return allBadges.map((badge) {
      final isEarned = earnedBadgeIds.contains(badge.id);
      DateTime? earnedAt;
      if (isEarned) {
        final earnedData = userBadgesResponse.firstWhere(
          (e) => e['badge_id'] == badge.id,
        );
        earnedAt = DateTime.parse(earnedData['earned_at']);
      }

      return badge.copyWith(isEarned: isEarned, earnedAt: earnedAt);
    }).toList();
  }

  @override
  Future<void> addXp(int amount) async {
    final userId = _supabase.auth.currentUser!.id;

    // Get current stats
    final stats = await getUserStats();
    final newXp = stats.xp + amount;

    // Calculate level (Simple logic: Level = XP / 100 + 1)
    final newLevel = (newXp / 100).floor() + 1;

    await _supabase
        .from('user_stats')
        .update({
          'xp': newXp,
          'level': newLevel,
          'last_activity_date': DateTime.now().toIso8601String(),
        })
        .eq('user_id', userId);
  }

  @override
  Future<void> checkAndAwardBadges() async {
    final userId = _supabase.auth.currentUser!.id;
    final stats = await getUserStats();

    // Check 'newbie' badge (First word added)
    if (stats.xp > 0) {
      await _awardBadge('newbie');
    }

    if (stats.level >= 5) {
      await _awardBadge('scholar');
    }
  }

  Future<void> _awardBadge(String badgeCode) async {
    final userId = _supabase.auth.currentUser!.id;

    // Get badge ID
    final badgeRes = await _supabase
        .from('badges')
        .select('id')
        .eq('code', badgeCode)
        .maybeSingle();

    if (badgeRes == null) return;
    final badgeId = badgeRes['id'];

    // Check if already earned
    final earnedRes = await _supabase
        .from('user_badges')
        .select()
        .eq('user_id', userId)
        .eq('badge_id', badgeId)
        .maybeSingle();

    if (earnedRes != null) return; // Already earned

    // Award badge
    await _supabase.from('user_badges').insert({
      'user_id': userId,
      'badge_id': badgeId,
    });
  }
}
