// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$UserStats {
  String get userId => throw _privateConstructorUsedError;
  int get xp => throw _privateConstructorUsedError;
  int get level => throw _privateConstructorUsedError;
  int get currentStreak => throw _privateConstructorUsedError;
  DateTime get lastActivityDate => throw _privateConstructorUsedError;
  int get favoriteCount => throw _privateConstructorUsedError;

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserStatsCopyWith<UserStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserStatsCopyWith<$Res> {
  factory $UserStatsCopyWith(UserStats value, $Res Function(UserStats) then) =
      _$UserStatsCopyWithImpl<$Res, UserStats>;
  @useResult
  $Res call({
    String userId,
    int xp,
    int level,
    int currentStreak,
    DateTime lastActivityDate,
    int favoriteCount,
  });
}

/// @nodoc
class _$UserStatsCopyWithImpl<$Res, $Val extends UserStats>
    implements $UserStatsCopyWith<$Res> {
  _$UserStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? xp = null,
    Object? level = null,
    Object? currentStreak = null,
    Object? lastActivityDate = null,
    Object? favoriteCount = null,
  }) {
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            xp: null == xp
                ? _value.xp
                : xp // ignore: cast_nullable_to_non_nullable
                      as int,
            level: null == level
                ? _value.level
                : level // ignore: cast_nullable_to_non_nullable
                      as int,
            currentStreak: null == currentStreak
                ? _value.currentStreak
                : currentStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            lastActivityDate: null == lastActivityDate
                ? _value.lastActivityDate
                : lastActivityDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            favoriteCount: null == favoriteCount
                ? _value.favoriteCount
                : favoriteCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserStatsImplCopyWith<$Res>
    implements $UserStatsCopyWith<$Res> {
  factory _$$UserStatsImplCopyWith(
    _$UserStatsImpl value,
    $Res Function(_$UserStatsImpl) then,
  ) = __$$UserStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    int xp,
    int level,
    int currentStreak,
    DateTime lastActivityDate,
    int favoriteCount,
  });
}

/// @nodoc
class __$$UserStatsImplCopyWithImpl<$Res>
    extends _$UserStatsCopyWithImpl<$Res, _$UserStatsImpl>
    implements _$$UserStatsImplCopyWith<$Res> {
  __$$UserStatsImplCopyWithImpl(
    _$UserStatsImpl _value,
    $Res Function(_$UserStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? xp = null,
    Object? level = null,
    Object? currentStreak = null,
    Object? lastActivityDate = null,
    Object? favoriteCount = null,
  }) {
    return _then(
      _$UserStatsImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        xp: null == xp
            ? _value.xp
            : xp // ignore: cast_nullable_to_non_nullable
                  as int,
        level: null == level
            ? _value.level
            : level // ignore: cast_nullable_to_non_nullable
                  as int,
        currentStreak: null == currentStreak
            ? _value.currentStreak
            : currentStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        lastActivityDate: null == lastActivityDate
            ? _value.lastActivityDate
            : lastActivityDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        favoriteCount: null == favoriteCount
            ? _value.favoriteCount
            : favoriteCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$UserStatsImpl implements _UserStats {
  const _$UserStatsImpl({
    required this.userId,
    this.xp = 0,
    this.level = 1,
    this.currentStreak = 0,
    required this.lastActivityDate,
    this.favoriteCount = 0,
  });

  @override
  final String userId;
  @override
  @JsonKey()
  final int xp;
  @override
  @JsonKey()
  final int level;
  @override
  @JsonKey()
  final int currentStreak;
  @override
  final DateTime lastActivityDate;
  @override
  @JsonKey()
  final int favoriteCount;

  @override
  String toString() {
    return 'UserStats(userId: $userId, xp: $xp, level: $level, currentStreak: $currentStreak, lastActivityDate: $lastActivityDate, favoriteCount: $favoriteCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserStatsImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.xp, xp) || other.xp == xp) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.lastActivityDate, lastActivityDate) ||
                other.lastActivityDate == lastActivityDate) &&
            (identical(other.favoriteCount, favoriteCount) ||
                other.favoriteCount == favoriteCount));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    xp,
    level,
    currentStreak,
    lastActivityDate,
    favoriteCount,
  );

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserStatsImplCopyWith<_$UserStatsImpl> get copyWith =>
      __$$UserStatsImplCopyWithImpl<_$UserStatsImpl>(this, _$identity);
}

abstract class _UserStats implements UserStats {
  const factory _UserStats({
    required final String userId,
    final int xp,
    final int level,
    final int currentStreak,
    required final DateTime lastActivityDate,
    final int favoriteCount,
  }) = _$UserStatsImpl;

  @override
  String get userId;
  @override
  int get xp;
  @override
  int get level;
  @override
  int get currentStreak;
  @override
  DateTime get lastActivityDate;
  @override
  int get favoriteCount;

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserStatsImplCopyWith<_$UserStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
