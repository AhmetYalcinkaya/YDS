// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_word.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StudyWordImpl _$$StudyWordImplFromJson(Map<String, dynamic> json) =>
    _$StudyWordImpl(
      id: json['id'] as String,
      english: json['english'] as String,
      turkish: json['turkish'] as String,
      exampleSentence: json['exampleSentence'] as String,
      masteryScore: (json['masteryScore'] as num?)?.toInt() ?? 0,
      isUserWord: json['isUserWord'] as bool? ?? false,
      category: json['category'] as String? ?? 'noun',
      difficultyLevel: json['difficultyLevel'] as String? ?? 'B1',
    );

Map<String, dynamic> _$$StudyWordImplToJson(_$StudyWordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'english': instance.english,
      'turkish': instance.turkish,
      'exampleSentence': instance.exampleSentence,
      'masteryScore': instance.masteryScore,
      'isUserWord': instance.isUserWord,
      'category': instance.category,
      'difficultyLevel': instance.difficultyLevel,
    };
