import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_record.freezed.dart';
part 'video_record.g.dart';

@freezed
class VideoRecord with _$VideoRecord {
  const factory VideoRecord({
    required String filePath,
    required String fileName,
    required DateTime recordedAt,
    String? description,
    String? patientName,
    String? patientId,
  }) = _VideoRecord;

  factory VideoRecord.fromJson(Map<String, dynamic> json) =>
      _$VideoRecordFromJson(json);
} 