import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_stats.freezed.dart';

@Freezed(toJson: false, fromJson: false)
class UserStats with _$UserStats {
  const factory UserStats({
    required String userId,
    @Default(0) int xp,
    @Default(1) int level,
    @Default(0) int currentStreak,
    required DateTime lastActivityDate,
  }) = _UserStats;

  factory UserStats.fromJson(Map<String, dynamic> json) => UserStats(
    userId: json['user_id'] as String,
    xp: (json['xp'] as num?)?.toInt() ?? 0,
    level: (json['level'] as num?)?.toInt() ?? 1,
    currentStreak: (json['current_streak'] as num?)?.toInt() ?? 0,
    lastActivityDate: DateTime.parse(json['last_activity_date'] as String),
  );
}
