// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StudyPlanImpl _$$StudyPlanImplFromJson(Map<String, dynamic> json) =>
    _$StudyPlanImpl(
      dueWords: (json['dueWords'] as List<dynamic>)
          .map((e) => StudyWord.fromJson(e as Map<String, dynamic>))
          .toList(),
      dailyTarget: (json['dailyTarget'] as num).toInt(),
      completedToday: (json['completedToday'] as num).toInt(),
    );

Map<String, dynamic> _$$StudyPlanImplToJson(_$StudyPlanImpl instance) =>
    <String, dynamic>{
      'dueWords': instance.dueWords,
      'dailyTarget': instance.dailyTarget,
      'completedToday': instance.completedToday,
    };
