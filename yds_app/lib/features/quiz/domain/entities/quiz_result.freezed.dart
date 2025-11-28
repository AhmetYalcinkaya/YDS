// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

QuizResult _$QuizResultFromJson(Map<String, dynamic> json) {
  return _QuizResult.fromJson(json);
}

/// @nodoc
mixin _$QuizResult {
  int get totalQuestions => throw _privateConstructorUsedError;
  int get correctAnswers => throw _privateConstructorUsedError;
  int get wrongAnswers => throw _privateConstructorUsedError;
  Duration get timeTaken => throw _privateConstructorUsedError;
  List<QuizQuestion> get questions => throw _privateConstructorUsedError;
  List<int> get userAnswers => throw _privateConstructorUsedError;

  /// Serializes this QuizResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizResultCopyWith<QuizResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizResultCopyWith<$Res> {
  factory $QuizResultCopyWith(
    QuizResult value,
    $Res Function(QuizResult) then,
  ) = _$QuizResultCopyWithImpl<$Res, QuizResult>;
  @useResult
  $Res call({
    int totalQuestions,
    int correctAnswers,
    int wrongAnswers,
    Duration timeTaken,
    List<QuizQuestion> questions,
    List<int> userAnswers,
  });
}

/// @nodoc
class _$QuizResultCopyWithImpl<$Res, $Val extends QuizResult>
    implements $QuizResultCopyWith<$Res> {
  _$QuizResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalQuestions = null,
    Object? correctAnswers = null,
    Object? wrongAnswers = null,
    Object? timeTaken = null,
    Object? questions = null,
    Object? userAnswers = null,
  }) {
    return _then(
      _value.copyWith(
            totalQuestions: null == totalQuestions
                ? _value.totalQuestions
                : totalQuestions // ignore: cast_nullable_to_non_nullable
                      as int,
            correctAnswers: null == correctAnswers
                ? _value.correctAnswers
                : correctAnswers // ignore: cast_nullable_to_non_nullable
                      as int,
            wrongAnswers: null == wrongAnswers
                ? _value.wrongAnswers
                : wrongAnswers // ignore: cast_nullable_to_non_nullable
                      as int,
            timeTaken: null == timeTaken
                ? _value.timeTaken
                : timeTaken // ignore: cast_nullable_to_non_nullable
                      as Duration,
            questions: null == questions
                ? _value.questions
                : questions // ignore: cast_nullable_to_non_nullable
                      as List<QuizQuestion>,
            userAnswers: null == userAnswers
                ? _value.userAnswers
                : userAnswers // ignore: cast_nullable_to_non_nullable
                      as List<int>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuizResultImplCopyWith<$Res>
    implements $QuizResultCopyWith<$Res> {
  factory _$$QuizResultImplCopyWith(
    _$QuizResultImpl value,
    $Res Function(_$QuizResultImpl) then,
  ) = __$$QuizResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalQuestions,
    int correctAnswers,
    int wrongAnswers,
    Duration timeTaken,
    List<QuizQuestion> questions,
    List<int> userAnswers,
  });
}

/// @nodoc
class __$$QuizResultImplCopyWithImpl<$Res>
    extends _$QuizResultCopyWithImpl<$Res, _$QuizResultImpl>
    implements _$$QuizResultImplCopyWith<$Res> {
  __$$QuizResultImplCopyWithImpl(
    _$QuizResultImpl _value,
    $Res Function(_$QuizResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuizResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalQuestions = null,
    Object? correctAnswers = null,
    Object? wrongAnswers = null,
    Object? timeTaken = null,
    Object? questions = null,
    Object? userAnswers = null,
  }) {
    return _then(
      _$QuizResultImpl(
        totalQuestions: null == totalQuestions
            ? _value.totalQuestions
            : totalQuestions // ignore: cast_nullable_to_non_nullable
                  as int,
        correctAnswers: null == correctAnswers
            ? _value.correctAnswers
            : correctAnswers // ignore: cast_nullable_to_non_nullable
                  as int,
        wrongAnswers: null == wrongAnswers
            ? _value.wrongAnswers
            : wrongAnswers // ignore: cast_nullable_to_non_nullable
                  as int,
        timeTaken: null == timeTaken
            ? _value.timeTaken
            : timeTaken // ignore: cast_nullable_to_non_nullable
                  as Duration,
        questions: null == questions
            ? _value._questions
            : questions // ignore: cast_nullable_to_non_nullable
                  as List<QuizQuestion>,
        userAnswers: null == userAnswers
            ? _value._userAnswers
            : userAnswers // ignore: cast_nullable_to_non_nullable
                  as List<int>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizResultImpl implements _QuizResult {
  const _$QuizResultImpl({
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.timeTaken,
    required final List<QuizQuestion> questions,
    required final List<int> userAnswers,
  }) : _questions = questions,
       _userAnswers = userAnswers;

  factory _$QuizResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizResultImplFromJson(json);

  @override
  final int totalQuestions;
  @override
  final int correctAnswers;
  @override
  final int wrongAnswers;
  @override
  final Duration timeTaken;
  final List<QuizQuestion> _questions;
  @override
  List<QuizQuestion> get questions {
    if (_questions is EqualUnmodifiableListView) return _questions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questions);
  }

  final List<int> _userAnswers;
  @override
  List<int> get userAnswers {
    if (_userAnswers is EqualUnmodifiableListView) return _userAnswers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_userAnswers);
  }

  @override
  String toString() {
    return 'QuizResult(totalQuestions: $totalQuestions, correctAnswers: $correctAnswers, wrongAnswers: $wrongAnswers, timeTaken: $timeTaken, questions: $questions, userAnswers: $userAnswers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizResultImpl &&
            (identical(other.totalQuestions, totalQuestions) ||
                other.totalQuestions == totalQuestions) &&
            (identical(other.correctAnswers, correctAnswers) ||
                other.correctAnswers == correctAnswers) &&
            (identical(other.wrongAnswers, wrongAnswers) ||
                other.wrongAnswers == wrongAnswers) &&
            (identical(other.timeTaken, timeTaken) ||
                other.timeTaken == timeTaken) &&
            const DeepCollectionEquality().equals(
              other._questions,
              _questions,
            ) &&
            const DeepCollectionEquality().equals(
              other._userAnswers,
              _userAnswers,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalQuestions,
    correctAnswers,
    wrongAnswers,
    timeTaken,
    const DeepCollectionEquality().hash(_questions),
    const DeepCollectionEquality().hash(_userAnswers),
  );

  /// Create a copy of QuizResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizResultImplCopyWith<_$QuizResultImpl> get copyWith =>
      __$$QuizResultImplCopyWithImpl<_$QuizResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizResultImplToJson(this);
  }
}

abstract class _QuizResult implements QuizResult {
  const factory _QuizResult({
    required final int totalQuestions,
    required final int correctAnswers,
    required final int wrongAnswers,
    required final Duration timeTaken,
    required final List<QuizQuestion> questions,
    required final List<int> userAnswers,
  }) = _$QuizResultImpl;

  factory _QuizResult.fromJson(Map<String, dynamic> json) =
      _$QuizResultImpl.fromJson;

  @override
  int get totalQuestions;
  @override
  int get correctAnswers;
  @override
  int get wrongAnswers;
  @override
  Duration get timeTaken;
  @override
  List<QuizQuestion> get questions;
  @override
  List<int> get userAnswers;

  /// Create a copy of QuizResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizResultImplCopyWith<_$QuizResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
