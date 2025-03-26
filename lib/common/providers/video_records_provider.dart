import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:developer' as developer;
import '../models/video_record.dart';

part 'video_records_provider.g.dart';

@riverpod
class VideoRecordsNotifier extends _$VideoRecordsNotifier {
  Future<Directory> _getVideoDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final videoDir = Directory(path.join(appDir.path, 'videos'));
    if (!await videoDir.exists()) {
      await videoDir.create(recursive: true);
    }
    return videoDir;
  }

  @override
  FutureOr<List<VideoRecord>> build() async {
    try {
      developer.log('开始加载视频记录');
      final videoDir = await _getVideoDirectory();
      developer.log('视频目录: ${videoDir.path}');
      
      final files = videoDir.listSync()
        .whereType<File>()
        .where((file) => file.path.endsWith('.mp4'))
        .map((file) {
          final name = file.path.split('/').last;
          return VideoRecord(
            fileName: name,
            filePath: file.path,
            recordedAt: file.lastModifiedSync(),
          );
        })
        .toList();
      
      developer.log('找到 ${files.length} 个视频文件');
      return files;
    } catch (e, stack) {
      developer.log('加载视频记录失败: $e');
      developer.log('错误堆栈: $stack');
      rethrow;
    }
  }

  Future<String> moveVideoToStorage(String tempPath) async {
    try {
      developer.log('开始移动视频文件');
      developer.log('临时文件路径: $tempPath');
      
      final videoDir = await _getVideoDirectory();
      final fileName = path.basename(tempPath);
      final newPath = path.join(videoDir.path, fileName);
      
      developer.log('目标文件路径: $newPath');
      
      final tempFile = File(tempPath);
      if (!await tempFile.exists()) {
        developer.log('临时文件不存在，路径: $tempPath');
        throw Exception('临时文件不存在: $tempPath');
      }
      
      developer.log('临时文件大小: ${await tempFile.length()} bytes');
      
      // 如果目标文件已存在，先删除它
      final newFile = File(newPath);
      if (await newFile.exists()) {
        await newFile.delete();
        developer.log('已删除已存在的目标文件');
      }
      
      // 复制文件
      final copiedFile = await tempFile.copy(newPath);
      developer.log('文件复制完成，新文件大小: ${await copiedFile.length()} bytes');
      
      // 验证复制是否成功
      if (!await copiedFile.exists()) {
        throw Exception('文件复制失败：目标文件不存在');
      }
      
      // 删除临时文件
      try {
        await tempFile.delete();
        developer.log('临时文件删除成功');
      } catch (e) {
        developer.log('临时文件删除失败: $e');
        // 继续执行，因为文件已经成功复制
      }
      
      developer.log('视频文件移动成功');
      return copiedFile.path;
    } catch (e, stack) {
      developer.log('移动视频文件失败: $e');
      developer.log('错误堆栈: $stack');
      rethrow;
    }
  }

  Future<void> addRecord(VideoRecord record) async {
    state = const AsyncValue.loading();
    try {
      final currentRecords = await future;
      state = AsyncValue.data([record, ...currentRecords]);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  Future<void> removeRecord(String filePath) async {
    state = const AsyncValue.loading();
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
      
      final currentRecords = await future;
      state = AsyncValue.data(
        currentRecords.where((record) => record.filePath != filePath).toList(),
      );
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }
} 