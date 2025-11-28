// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuizQuestionImpl _$$QuizQuestionImplFromJson(
  Map<String, dynamic> json,
) => _$QuizQuestionImpl(
  correctWord: StudyWord.fromJson(json['correctWord'] as Map<String, dynamic>),
  options: (json['options'] as List<dynamic>).map((e) => e as String).toList(),
  correctIndex: (json['correctIndex'] as num).toInt(),
);

Map<String, dynamic> _$$QuizQuestionImplToJson(_$QuizQuestionImpl instance) =>
    <String, dynamic>{
      'correctWord': instance.correctWord,
      'options': instance.options,
      'correctIndex': instance.correctIndex,
    };
