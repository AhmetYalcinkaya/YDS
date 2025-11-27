// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'study_word.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StudyWord _$StudyWordFromJson(Map<String, dynamic> json) {
  return _StudyWord.fromJson(json);
}

/// @nodoc
mixin _$StudyWord {
  String get id => throw _privateConstructorUsedError;
  String get english => throw _privateConstructorUsedError;
  String get turkish => throw _privateConstructorUsedError;
  String get partOfSpeech => throw _privateConstructorUsedError;
  String get exampleSentence => throw _privateConstructorUsedError;
  int get masteryScore => throw _privateConstructorUsedError;
  bool get isUserWord => throw _privateConstructorUsedError;

  /// Serializes this StudyWord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StudyWord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StudyWordCopyWith<StudyWord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudyWordCopyWith<$Res> {
  factory $StudyWordCopyWith(StudyWord value, $Res Function(StudyWord) then) =
      _$StudyWordCopyWithImpl<$Res, StudyWord>;
  @useResult
  $Res call({
    String id,
    String english,
    String turkish,
    String partOfSpeech,
    String exampleSentence,
    int masteryScore,
    bool isUserWord,
  });
}

/// @nodoc
class _$StudyWordCopyWithImpl<$Res, $Val extends StudyWord>
    implements $StudyWordCopyWith<$Res> {
  _$StudyWordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StudyWord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? english = null,
    Object? turkish = null,
    Object? partOfSpeech = null,
    Object? exampleSentence = null,
    Object? masteryScore = null,
    Object? isUserWord = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            english: null == english
                ? _value.english
                : english // ignore: cast_nullable_to_non_nullable
                      as String,
            turkish: null == turkish
                ? _value.turkish
                : turkish // ignore: cast_nullable_to_non_nullable
                      as String,
            partOfSpeech: null == partOfSpeech
                ? _value.partOfSpeech
                : partOfSpeech // ignore: cast_nullable_to_non_nullable
                      as String,
            exampleSentence: null == exampleSentence
                ? _value.exampleSentence
                : exampleSentence // ignore: cast_nullable_to_non_nullable
                      as String,
            masteryScore: null == masteryScore
                ? _value.masteryScore
                : masteryScore // ignore: cast_nullable_to_non_nullable
                      as int,
            isUserWord: null == isUserWord
                ? _value.isUserWord
                : isUserWord // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StudyWordImplCopyWith<$Res>
    implements $StudyWordCopyWith<$Res> {
  factory _$$StudyWordImplCopyWith(
    _$StudyWordImpl value,
    $Res Function(_$StudyWordImpl) then,
  ) = __$$StudyWordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String english,
    String turkish,
    String partOfSpeech,
    String exampleSentence,
    int masteryScore,
    bool isUserWord,
  });
}

/// @nodoc
class __$$StudyWordImplCopyWithImpl<$Res>
    extends _$StudyWordCopyWithImpl<$Res, _$StudyWordImpl>
    implements _$$StudyWordImplCopyWith<$Res> {
  __$$StudyWordImplCopyWithImpl(
    _$StudyWordImpl _value,
    $Res Function(_$StudyWordImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StudyWord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? english = null,
    Object? turkish = null,
    Object? partOfSpeech = null,
    Object? exampleSentence = null,
    Object? masteryScore = null,
    Object? isUserWord = null,
  }) {
    return _then(
      _$StudyWordImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        english: null == english
            ? _value.english
            : english // ignore: cast_nullable_to_non_nullable
                  as String,
        turkish: null == turkish
            ? _value.turkish
            : turkish // ignore: cast_nullable_to_non_nullable
                  as String,
        partOfSpeech: null == partOfSpeech
            ? _value.partOfSpeech
            : partOfSpeech // ignore: cast_nullable_to_non_nullable
                  as String,
        exampleSentence: null == exampleSentence
            ? _value.exampleSentence
            : exampleSentence // ignore: cast_nullable_to_non_nullable
                  as String,
        masteryScore: null == masteryScore
            ? _value.masteryScore
            : masteryScore // ignore: cast_nullable_to_non_nullable
                  as int,
        isUserWord: null == isUserWord
            ? _value.isUserWord
            : isUserWord // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StudyWordImpl implements _StudyWord {
  const _$StudyWordImpl({
    required this.id,
    required this.english,
    required this.turkish,
    required this.partOfSpeech,
    required this.exampleSentence,
    this.masteryScore = 0,
    this.isUserWord = false,
  });

  factory _$StudyWordImpl.fromJson(Map<String, dynamic> json) =>
      _$$StudyWordImplFromJson(json);

  @override
  final String id;
  @override
  final String english;
  @override
  final String turkish;
  @override
  final String partOfSpeech;
  @override
  final String exampleSentence;
  @override
  @JsonKey()
  final int masteryScore;
  @override
  @JsonKey()
  final bool isUserWord;

  @override
  String toString() {
    return 'StudyWord(id: $id, english: $english, turkish: $turkish, partOfSpeech: $partOfSpeech, exampleSentence: $exampleSentence, masteryScore: $masteryScore, isUserWord: $isUserWord)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StudyWordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.english, english) || other.english == english) &&
            (identical(other.turkish, turkish) || other.turkish == turkish) &&
            (identical(other.partOfSpeech, partOfSpeech) ||
                other.partOfSpeech == partOfSpeech) &&
            (identical(other.exampleSentence, exampleSentence) ||
                other.exampleSentence == exampleSentence) &&
            (identical(other.masteryScore, masteryScore) ||
                other.masteryScore == masteryScore) &&
            (identical(other.isUserWord, isUserWord) ||
                other.isUserWord == isUserWord));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    english,
    turkish,
    partOfSpeech,
    exampleSentence,
    masteryScore,
    isUserWord,
  );

  /// Create a copy of StudyWord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StudyWordImplCopyWith<_$StudyWordImpl> get copyWith =>
      __$$StudyWordImplCopyWithImpl<_$StudyWordImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StudyWordImplToJson(this);
  }
}

abstract class _StudyWord implements StudyWord {
  const factory _StudyWord({
    required final String id,
    required final String english,
    required final String turkish,
    required final String partOfSpeech,
    required final String exampleSentence,
    final int masteryScore,
    final bool isUserWord,
  }) = _$StudyWordImpl;

  factory _StudyWord.fromJson(Map<String, dynamic> json) =
      _$StudyWordImpl.fromJson;

  @override
  String get id;
  @override
  String get english;
  @override
  String get turkish;
  @override
  String get partOfSpeech;
  @override
  String get exampleSentence;
  @override
  int get masteryScore;
  @override
  bool get isUserWord;

  /// Create a copy of StudyWord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StudyWordImplCopyWith<_$StudyWordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
