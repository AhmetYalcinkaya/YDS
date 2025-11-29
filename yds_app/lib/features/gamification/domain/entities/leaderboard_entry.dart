class LeaderboardEntry {
  final String userId;
  final String displayName;
  final int xp;
  final int level;
  final int rank;
  final String? avatarUrl;

  const LeaderboardEntry({
    required this.userId,
    required this.displayName,
    required this.xp,
    required this.level,
    required this.rank,
    this.avatarUrl,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      userId: json['user_id'] as String,
      displayName: json['display_name'] as String? ?? 'Kullanıcı',
      xp: json['xp'] as int,
      level: json['level'] as int,
      rank: json['rank'] as int,
      avatarUrl: json['avatar_url'] as String?,
    );
  }
}
