import 'package:freezed_annotation/freezed_annotation.dart';

part 'patient.freezed.dart';
part 'patient.g.dart';

@freezed
abstract class Patient with _$Patient {
  const factory Patient({
    required String id,
    required String name,
    required String medicalRecordNumber,
    String? gender,
    int? age,
    String? phoneNumber,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _Patient;

  factory Patient.fromJson(Map<String, dynamic> json) => _$PatientFromJson(json);
} 