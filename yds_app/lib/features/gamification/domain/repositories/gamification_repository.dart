import '../entities/user_stats.dart';
import '../entities/badge.dart';
import '../entities/leaderboard_entry.dart';

abstract class GamificationRepository {
  Future<UserStats> getUserStats();
  Future<List<Badge>> getBadges();
  Future<void> addXp(int amount);
  Future<void> checkAndAwardBadges();

  /// Checks if the user has earned any quiz badges
  Future<List<String>> checkQuizBadges(int correctAnswers, int totalQuestions);

  /// Retrieves the leaderboard
  Future<List<LeaderboardEntry>> getLeaderboard();
}
