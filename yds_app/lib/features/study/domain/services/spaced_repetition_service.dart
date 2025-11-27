import '../../../../shared/widgets/difficulty_rating_widget.dart';

/// Spaced repetition service to calculate next review dates
class SpacedRepetitionService {
  SpacedRepetitionService._();

  /// Calculate next review date based on difficulty
  static DateTime calculateNextReviewDate(Difficulty difficulty) {
    final now = DateTime.now();

    switch (difficulty) {
      case Difficulty.easy:
        return now.add(const Duration(days: 4));
      case Difficulty.medium:
        return now.add(const Duration(days: 2));
      case Difficulty.hard:
        return now.add(const Duration(days: 1));
    }
  }

  /// Calculate ease factor (for future advanced algorithm)
  static double calculateEaseFactor(Difficulty difficulty, double currentEase) {
    switch (difficulty) {
      case Difficulty.easy:
        return (currentEase + 0.1).clamp(1.3, 2.5);
      case Difficulty.medium:
        return currentEase;
      case Difficulty.hard:
        return (currentEase - 0.2).clamp(1.3, 2.5);
    }
  }

  /// Calculate interval in days (for future advanced algorithm)
  static int calculateInterval(Difficulty difficulty, int currentInterval) {
    switch (difficulty) {
      case Difficulty.easy:
        return (currentInterval * 2.5).round();
      case Difficulty.medium:
        return (currentInterval * 1.5).round();
      case Difficulty.hard:
        return 1;
    }
  }
}
