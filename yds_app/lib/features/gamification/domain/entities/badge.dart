import 'package:freezed_annotation/freezed_annotation.dart';

part 'badge.freezed.dart';

@Freezed(toJson: false, fromJson: false)
class Badge with _$Badge {
  const factory Badge({
    required String id,
    required String code,
    required String name,
    required String description,
    required String iconName,
    @Default(0) int xpReward,
    @Default(false) bool isEarned,
    DateTime? earnedAt,
  }) = _Badge;

  factory Badge.fromJson(Map<String, dynamic> json) => Badge(
    id: json['id'] as String,
    code: json['code'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    iconName: json['icon_name'] as String,
    xpReward: (json['xp_reward'] as num?)?.toInt() ?? 0,
    isEarned: json['is_earned'] as bool? ?? false,
    earnedAt: json['earned_at'] == null
        ? null
        : DateTime.parse(json['earned_at'] as String),
  );
}
