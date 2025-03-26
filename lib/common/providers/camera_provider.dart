import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:developer' as developer;
import 'video_records_provider.dart';
import '../models/video_record.dart';
import 'dart:io';

part 'camera_provider.g.dart';

@riverpod
class CameraControllerNotifier extends _$CameraControllerNotifier {
  CameraController? _controller;
  bool _isInitialized = false;
  String? _videoPath;
  bool _isDisposed = false;
  Size? _previewSize;
  bool _isPreviewReady = false;

  @override
  FutureOr<CameraController?> build() {
    ref.onDispose(() {
      _cleanupCamera();
    });
    return null;
  }

  void _cleanupCamera() {
    developer.log('Cleaning up camera resources');
    _isDisposed = true;
    if (_controller != null) {
      if (_controller!.value.isRecordingVideo) {
        _controller!.stopVideoRecording().catchError((e) {
          developer.log('Error stopping recording during cleanup: $e');
        });
      }
      _controller!.dispose();
      _controller = null;
    }
    _isInitialized = false;
    _isPreviewReady = false;
    _videoPath = null;
  }

  Future<void> initializeCamera() async {
    try {
      developer.log('开始初始化相机');
      state = const AsyncValue.loading();
      
      final cameras = await availableCameras();
      developer.log('可用相机数量: ${cameras.length}');
      
      if (cameras.isEmpty) {
        throw Exception('没有可用的相机');
      }

      final camera = cameras.first;
      developer.log('使用相机: ${camera.name}, 朝向: ${camera.lensDirection}');
      
      _controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: true,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      developer.log('开始初始化相机控制器');
      await _controller!.initialize();
      developer.log('相机控制器初始化完成');
      
      _isInitialized = true;
      _previewSize = _controller!.value.previewSize;
      developer.log('预览尺寸: ${_previewSize?.width}x${_previewSize?.height}');
      
      _isPreviewReady = true;
      state = AsyncValue.data(_controller);
      developer.log('相机初始化完成');
    } catch (error, stack) {
      developer.log('相机初始化失败: $error');
      developer.log('错误堆栈: $stack');
      _isInitialized = false;
      _isPreviewReady = false;
      state = AsyncValue.error(error, stack);
    }
  }

  Future<String?> startRecording() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      throw CameraException('未初始化', '相机未初始化');
    }

    if (_controller!.value.isRecordingVideo) {
      return null;
    }

    try {
      final directory = await getTemporaryDirectory();
      _videoPath = path.join(
        directory.path,
        'video_${DateTime.now().millisecondsSinceEpoch}.mp4',
      );

      developer.log('开始录制视频到: $_videoPath');
      await _controller!.startVideoRecording();
      return _videoPath;
    } catch (e) {
      developer.log('开始录制失败: $e');
      rethrow;
    }
  }

  Future<String?> stopRecording() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      throw CameraException('未初始化', '相机未初始化');
    }

    if (!_controller!.value.isRecordingVideo) {
      return null;
    }

    XFile? recordedFile;
    String? permanentPath;
    
    try {
      // 1. 停止录制
      developer.log('停止录制视频');
      recordedFile = await _controller!.stopVideoRecording();
      developer.log('视频已保存到临时文件: ${recordedFile.path}');
      
      // 2. 将视频移动到永久存储
      developer.log('将视频移动到永久存储');
      final videoRecordsNotifier = ref.read(videoRecordsNotifierProvider.notifier);
      permanentPath = await videoRecordsNotifier.moveVideoToStorage(recordedFile.path);
      developer.log('视频已移动到永久存储: $permanentPath');
      
      // 3. 添加视频记录
      await videoRecordsNotifier.addRecord(
        VideoRecord(
          fileName: path.basename(permanentPath),
          filePath: permanentPath,
          recordedAt: DateTime.now(),
        ),
      );

      developer.log('视频记录已添加到列表');
      return permanentPath;
    } catch (e, stack) {
      developer.log('停止录制失败: $e');
      developer.log('错误堆栈: $stack');
      
      // 清理临时文件
      if (recordedFile != null) {
        try {
          final tempFile = File(recordedFile.path);
          if (await tempFile.exists()) {
            await tempFile.delete();
            developer.log('已删除临时文件: ${recordedFile.path}');
          }
        } catch (cleanupError) {
          developer.log('清理临时文件失败: $cleanupError');
        }
      }
      
      // 如果永久存储文件创建了但出错，也需要清理
      if (permanentPath != null) {
        try {
          final permanentFile = File(permanentPath);
          if (await permanentFile.exists()) {
            await permanentFile.delete();
            developer.log('已删除永久存储文件: $permanentPath');
          }
        } catch (cleanupError) {
          developer.log('清理永久存储文件失败: $cleanupError');
        }
      }
      
      rethrow;
    }
  }

  Future<void> toggleTorch() async {
    if (!_isInitialized || _isDisposed) {
      developer.log('Cannot toggle torch: Camera not ready');
      return;
    }
    
    try {
      final currentFlashMode = _controller!.value.flashMode;
      final newFlashMode = currentFlashMode == FlashMode.torch
          ? FlashMode.off
          : FlashMode.torch;
      await _controller!.setFlashMode(newFlashMode);
      developer.log('Toggled torch mode to: $newFlashMode');
    } on CameraException catch (e, stackTrace) {
      developer.log('Camera Exception toggling torch: ${e.code} - ${e.description}');
      state = AsyncError('闪光灯控制错误: ${e.description}', stackTrace);
    } catch (e, stackTrace) {
      developer.log('Error toggling torch: $e');
      state = AsyncError('闪光灯控制失败: $e', stackTrace);
    }
  }

  // 获取预览尺寸
  Size? get previewSize => _previewSize;
  
  // 检查预览是否就绪
  bool get isPreviewReady => _isPreviewReady;

  // 获取相机控制器
  CameraController? get controller => _controller;

  // 获取相机状态
  CameraValue? get cameraValue => _controller?.value;

  // 切换前后摄像头
  Future<void> switchCamera() async {
    if (!_isInitialized || _isDisposed) {
      developer.log('Cannot switch camera: Camera not ready');
      return;
    }

    try {
      final cameras = await availableCameras();
      if (cameras.length < 2) {
        throw Exception('没有可用的前置摄像头');
      }

      final currentCamera = _controller!.description;
      final newCamera = cameras.firstWhere(
        (camera) => camera.lensDirection != currentCamera.lensDirection,
        orElse: () => cameras.first,
      );

      await _controller!.dispose();
      _controller = CameraController(
        newCamera,
        ResolutionPreset.high,
        enableAudio: true,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _controller!.initialize();
      _previewSize = _controller!.value.previewSize;
      state = AsyncValue.data(_controller);
    } catch (e, stack) {
      developer.log('Error switching camera: $e');
      state = AsyncValue.error('切换摄像头失败: $e', stack);
    }
  }
}