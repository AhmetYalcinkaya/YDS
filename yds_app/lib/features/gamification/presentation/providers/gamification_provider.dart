import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_stats.dart';
import '../../data/repositories/gamification_repository_impl.dart';

final userStatsProvider = FutureProvider<UserStats>((ref) async {
  final repository = ref.read(gamificationRepositoryProvider);
  return repository.getUserStats();
});
