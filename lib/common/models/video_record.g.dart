// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VideoRecordImpl _$$VideoRecordImplFromJson(Map<String, dynamic> json) =>
    _$VideoRecordImpl(
      filePath: json['filePath'] as String,
      fileName: json['fileName'] as String,
      recordedAt: DateTime.parse(json['recordedAt'] as String),
      description: json['description'] as String?,
      patientName: json['patientName'] as String?,
      patientId: json['patientId'] as String?,
    );

Map<String, dynamic> _$$VideoRecordImplToJson(_$VideoRecordImpl instance) =>
    <String, dynamic>{
      'filePath': instance.filePath,
      'fileName': instance.fileName,
      'recordedAt': instance.recordedAt.toIso8601String(),
      'description': instance.description,
      'patientName': instance.patientName,
      'patientId': instance.patientId,
    };
