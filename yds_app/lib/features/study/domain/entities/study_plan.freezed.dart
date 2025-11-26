// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'study_plan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StudyPlan _$StudyPlanFromJson(Map<String, dynamic> json) {
  return _StudyPlan.fromJson(json);
}

/// @nodoc
mixin _$StudyPlan {
  List<StudyWord> get dueWords => throw _privateConstructorUsedError;
  int get dailyTarget => throw _privateConstructorUsedError;
  int get completedToday => throw _privateConstructorUsedError;

  /// Serializes this StudyPlan to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StudyPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StudyPlanCopyWith<StudyPlan> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudyPlanCopyWith<$Res> {
  factory $StudyPlanCopyWith(StudyPlan value, $Res Function(StudyPlan) then) =
      _$StudyPlanCopyWithImpl<$Res, StudyPlan>;
  @useResult
  $Res call({List<StudyWord> dueWords, int dailyTarget, int completedToday});
}

/// @nodoc
class _$StudyPlanCopyWithImpl<$Res, $Val extends StudyPlan>
    implements $StudyPlanCopyWith<$Res> {
  _$StudyPlanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StudyPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dueWords = null,
    Object? dailyTarget = null,
    Object? completedToday = null,
  }) {
    return _then(
      _value.copyWith(
            dueWords: null == dueWords
                ? _value.dueWords
                : dueWords // ignore: cast_nullable_to_non_nullable
                      as List<StudyWord>,
            dailyTarget: null == dailyTarget
                ? _value.dailyTarget
                : dailyTarget // ignore: cast_nullable_to_non_nullable
                      as int,
            completedToday: null == completedToday
                ? _value.completedToday
                : completedToday // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StudyPlanImplCopyWith<$Res>
    implements $StudyPlanCopyWith<$Res> {
  factory _$$StudyPlanImplCopyWith(
    _$StudyPlanImpl value,
    $Res Function(_$StudyPlanImpl) then,
  ) = __$$StudyPlanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<StudyWord> dueWords, int dailyTarget, int completedToday});
}

/// @nodoc
class __$$StudyPlanImplCopyWithImpl<$Res>
    extends _$StudyPlanCopyWithImpl<$Res, _$StudyPlanImpl>
    implements _$$StudyPlanImplCopyWith<$Res> {
  __$$StudyPlanImplCopyWithImpl(
    _$StudyPlanImpl _value,
    $Res Function(_$StudyPlanImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StudyPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dueWords = null,
    Object? dailyTarget = null,
    Object? completedToday = null,
  }) {
    return _then(
      _$StudyPlanImpl(
        dueWords: null == dueWords
            ? _value._dueWords
            : dueWords // ignore: cast_nullable_to_non_nullable
                  as List<StudyWord>,
        dailyTarget: null == dailyTarget
            ? _value.dailyTarget
            : dailyTarget // ignore: cast_nullable_to_non_nullable
                  as int,
        completedToday: null == completedToday
            ? _value.completedToday
            : completedToday // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StudyPlanImpl implements _StudyPlan {
  const _$StudyPlanImpl({
    required final List<StudyWord> dueWords,
    required this.dailyTarget,
    required this.completedToday,
  }) : _dueWords = dueWords;

  factory _$StudyPlanImpl.fromJson(Map<String, dynamic> json) =>
      _$$StudyPlanImplFromJson(json);

  final List<StudyWord> _dueWords;
  @override
  List<StudyWord> get dueWords {
    if (_dueWords is EqualUnmodifiableListView) return _dueWords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dueWords);
  }

  @override
  final int dailyTarget;
  @override
  final int completedToday;

  @override
  String toString() {
    return 'StudyPlan(dueWords: $dueWords, dailyTarget: $dailyTarget, completedToday: $completedToday)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StudyPlanImpl &&
            const DeepCollectionEquality().equals(other._dueWords, _dueWords) &&
            (identical(other.dailyTarget, dailyTarget) ||
                other.dailyTarget == dailyTarget) &&
            (identical(other.completedToday, completedToday) ||
                other.completedToday == completedToday));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_dueWords),
    dailyTarget,
    completedToday,
  );

  /// Create a copy of StudyPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StudyPlanImplCopyWith<_$StudyPlanImpl> get copyWith =>
      __$$StudyPlanImplCopyWithImpl<_$StudyPlanImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StudyPlanImplToJson(this);
  }
}

abstract class _StudyPlan implements StudyPlan {
  const factory _StudyPlan({
    required final List<StudyWord> dueWords,
    required final int dailyTarget,
    required final int completedToday,
  }) = _$StudyPlanImpl;

  factory _StudyPlan.fromJson(Map<String, dynamic> json) =
      _$StudyPlanImpl.fromJson;

  @override
  List<StudyWord> get dueWords;
  @override
  int get dailyTarget;
  @override
  int get completedToday;

  /// Create a copy of StudyPlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StudyPlanImplCopyWith<_$StudyPlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
