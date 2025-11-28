import '../entities/user_stats.dart';
import '../entities/badge.dart';

abstract class GamificationRepository {
  Future<UserStats> getUserStats();
  Future<List<Badge>> getBadges();
  Future<void> addXp(int amount);
  Future<void> checkAndAwardBadges();
}
