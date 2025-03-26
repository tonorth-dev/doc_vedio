import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/video_record.dart';
import '../models/patient.dart';

part 'video_record_provider.g.dart';

@riverpod
class VideoRecords extends _$VideoRecords {
  @override
  Future<List<VideoRecord>> build() async {
    return [];
  }

  Future<void> addVideoRecord({
    required String videoPath,
    required Patient patient,
    String? description,
  }) async {
    final fileName = videoPath.split('/').last;
    final record = VideoRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      patientId: patient.id,
      filePath: videoPath,
      fileName: fileName,
      recordedAt: DateTime.now(),
      description: description,
    );

    state = AsyncData([...state.value ?? [], record]);
  }

  Future<void> deleteVideoRecord(String id) async {
    final records = state.value ?? [];
    final record = records.firstWhere((r) => r.id == id);
    
    // 删除文件
    final file = File(record.filePath);
    if (await file.exists()) {
      await file.delete();
    }

    state = AsyncData(records.where((r) => r.id != id).toList());
  }

  Future<String> getVideoDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final videoDir = Directory('${directory.path}/videos');
    if (!await videoDir.exists()) {
      await videoDir.create(recursive: true);
    }
    return videoDir.path;
  }
} 