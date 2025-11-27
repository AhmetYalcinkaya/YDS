// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'study_statistics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StudyStatistics _$StudyStatisticsFromJson(Map<String, dynamic> json) {
  return _StudyStatistics.fromJson(json);
}

/// @nodoc
mixin _$StudyStatistics {
  int get totalWordsStudied => throw _privateConstructorUsedError;
  int get masteredWords => throw _privateConstructorUsedError;
  int get learningWords => throw _privateConstructorUsedError;
  int get streakDays => throw _privateConstructorUsedError;

  /// Serializes this StudyStatistics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StudyStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StudyStatisticsCopyWith<StudyStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudyStatisticsCopyWith<$Res> {
  factory $StudyStatisticsCopyWith(
    StudyStatistics value,
    $Res Function(StudyStatistics) then,
  ) = _$StudyStatisticsCopyWithImpl<$Res, StudyStatistics>;
  @useResult
  $Res call({
    int totalWordsStudied,
    int masteredWords,
    int learningWords,
    int streakDays,
  });
}

/// @nodoc
class _$StudyStatisticsCopyWithImpl<$Res, $Val extends StudyStatistics>
    implements $StudyStatisticsCopyWith<$Res> {
  _$StudyStatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StudyStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalWordsStudied = null,
    Object? masteredWords = null,
    Object? learningWords = null,
    Object? streakDays = null,
  }) {
    return _then(
      _value.copyWith(
            totalWordsStudied: null == totalWordsStudied
                ? _value.totalWordsStudied
                : totalWordsStudied // ignore: cast_nullable_to_non_nullable
                      as int,
            masteredWords: null == masteredWords
                ? _value.masteredWords
                : masteredWords // ignore: cast_nullable_to_non_nullable
                      as int,
            learningWords: null == learningWords
                ? _value.learningWords
                : learningWords // ignore: cast_nullable_to_non_nullable
                      as int,
            streakDays: null == streakDays
                ? _value.streakDays
                : streakDays // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StudyStatisticsImplCopyWith<$Res>
    implements $StudyStatisticsCopyWith<$Res> {
  factory _$$StudyStatisticsImplCopyWith(
    _$StudyStatisticsImpl value,
    $Res Function(_$StudyStatisticsImpl) then,
  ) = __$$StudyStatisticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalWordsStudied,
    int masteredWords,
    int learningWords,
    int streakDays,
  });
}

/// @nodoc
class __$$StudyStatisticsImplCopyWithImpl<$Res>
    extends _$StudyStatisticsCopyWithImpl<$Res, _$StudyStatisticsImpl>
    implements _$$StudyStatisticsImplCopyWith<$Res> {
  __$$StudyStatisticsImplCopyWithImpl(
    _$StudyStatisticsImpl _value,
    $Res Function(_$StudyStatisticsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StudyStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalWordsStudied = null,
    Object? masteredWords = null,
    Object? learningWords = null,
    Object? streakDays = null,
  }) {
    return _then(
      _$StudyStatisticsImpl(
        totalWordsStudied: null == totalWordsStudied
            ? _value.totalWordsStudied
            : totalWordsStudied // ignore: cast_nullable_to_non_nullable
                  as int,
        masteredWords: null == masteredWords
            ? _value.masteredWords
            : masteredWords // ignore: cast_nullable_to_non_nullable
                  as int,
        learningWords: null == learningWords
            ? _value.learningWords
            : learningWords // ignore: cast_nullable_to_non_nullable
                  as int,
        streakDays: null == streakDays
            ? _value.streakDays
            : streakDays // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StudyStatisticsImpl implements _StudyStatistics {
  const _$StudyStatisticsImpl({
    required this.totalWordsStudied,
    required this.masteredWords,
    required this.learningWords,
    required this.streakDays,
  });

  factory _$StudyStatisticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$StudyStatisticsImplFromJson(json);

  @override
  final int totalWordsStudied;
  @override
  final int masteredWords;
  @override
  final int learningWords;
  @override
  final int streakDays;

  @override
  String toString() {
    return 'StudyStatistics(totalWordsStudied: $totalWordsStudied, masteredWords: $masteredWords, learningWords: $learningWords, streakDays: $streakDays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StudyStatisticsImpl &&
            (identical(other.totalWordsStudied, totalWordsStudied) ||
                other.totalWordsStudied == totalWordsStudied) &&
            (identical(other.masteredWords, masteredWords) ||
                other.masteredWords == masteredWords) &&
            (identical(other.learningWords, learningWords) ||
                other.learningWords == learningWords) &&
            (identical(other.streakDays, streakDays) ||
                other.streakDays == streakDays));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalWordsStudied,
    masteredWords,
    learningWords,
    streakDays,
  );

  /// Create a copy of StudyStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StudyStatisticsImplCopyWith<_$StudyStatisticsImpl> get copyWith =>
      __$$StudyStatisticsImplCopyWithImpl<_$StudyStatisticsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$StudyStatisticsImplToJson(this);
  }
}

abstract class _StudyStatistics implements StudyStatistics {
  const factory _StudyStatistics({
    required final int totalWordsStudied,
    required final int masteredWords,
    required final int learningWords,
    required final int streakDays,
  }) = _$StudyStatisticsImpl;

  factory _StudyStatistics.fromJson(Map<String, dynamic> json) =
      _$StudyStatisticsImpl.fromJson;

  @override
  int get totalWordsStudied;
  @override
  int get masteredWords;
  @override
  int get learningWords;
  @override
  int get streakDays;

  /// Create a copy of StudyStatistics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StudyStatisticsImplCopyWith<_$StudyStatisticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
