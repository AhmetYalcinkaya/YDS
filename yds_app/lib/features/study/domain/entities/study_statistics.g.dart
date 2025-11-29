// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StudyStatisticsImpl _$$StudyStatisticsImplFromJson(
  Map<String, dynamic> json,
) => _$StudyStatisticsImpl(
  totalWordsStudied: (json['totalWordsStudied'] as num).toInt(),
  masteredWords: (json['masteredWords'] as num).toInt(),
  learningWords: (json['learningWords'] as num).toInt(),
  streakDays: (json['streakDays'] as num).toInt(),
  favoriteCount: (json['favoriteCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$StudyStatisticsImplToJson(
  _$StudyStatisticsImpl instance,
) => <String, dynamic>{
  'totalWordsStudied': instance.totalWordsStudied,
  'masteredWords': instance.masteredWords,
  'learningWords': instance.learningWords,
  'streakDays': instance.streakDays,
  'favoriteCount': instance.favoriteCount,
};
