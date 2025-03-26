// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PatientImpl _$$PatientImplFromJson(Map<String, dynamic> json) =>
    _$PatientImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      medicalRecordNumber: json['medicalRecordNumber'] as String,
      gender: json['gender'] as String?,
      age: (json['age'] as num?)?.toInt(),
      phoneNumber: json['phoneNumber'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$PatientImplToJson(_$PatientImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'medicalRecordNumber': instance.medicalRecordNumber,
      'gender': instance.gender,
      'age': instance.age,
      'phoneNumber': instance.phoneNumber,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
