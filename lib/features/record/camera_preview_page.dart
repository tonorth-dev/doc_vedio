import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';
import '../../common/providers/camera_provider.dart';
import '../../common/providers/video_records_provider.dart';
import '../../common/models/video_record.dart';

class CameraPreviewPage extends HookConsumerWidget {
  const CameraPreviewPage({super.key});

  Future<bool> _checkPermissions() async {
    try {
      final camera = await Permission.camera.status;
      final microphone = await Permission.microphone.status;
      final storage = await Permission.storage.status;
      
      return camera.isGranted && microphone.isGranted && storage.isGranted;
    } catch (e) {
      debugPrint('权限检查错误: $e');
      return false;
    }
  }

  Future<bool> _requestPermissions() async {
    try {
      final camera = await Permission.camera.request();
      final microphone = await Permission.microphone.request();
      final storage = await Permission.storage.request();
      
      if (!camera.isGranted || !microphone.isGranted || !storage.isGranted) {
        await openAppSettings();
        return false;
      }
      
      return true;
    } catch (e) {
      debugPrint('权限请求错误: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraAsync = ref.watch(cameraControllerNotifierProvider);
    final cameraNotifier = ref.watch(cameraControllerNotifierProvider.notifier);
    final isRecording = useState(false);
    final hasPermissions = useState(false);
    final isProcessing = useState(false);
    final permissionError = useState<String?>(null);

    // 在页面加载时检查权限并初始化相机
    useEffect(() {
      _checkPermissions().then((granted) {
        hasPermissions.value = granted;
        if (granted) {
          cameraNotifier.initializeCamera();
        }
      });
      return () {
        // 页面销毁时确保相机资源被释放
        if (isRecording.value) {
          cameraNotifier.stopRecording();
        }
      };
    }, []);

    if (!hasPermissions.value) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('录制视频'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.camera_alt,
                  size: 64,
                  color: Colors.blue,
                ),
                const SizedBox(height: 16),
                const Text(
                  '需要相机和存储权限才能录制视频',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                if (permissionError.value != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    permissionError.value!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () async {
                    isProcessing.value = true;
                    permissionError.value = null;
                    try {
                      final granted = await _requestPermissions();
                      hasPermissions.value = granted;
                      if (granted) {
                        await cameraNotifier.initializeCamera();
                      }
                    } catch (e) {
                      permissionError.value = '权限请求失败: $e';
                    } finally {
                      isProcessing.value = false;
                    }
                  },
                  icon: isProcessing.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.check_circle),
                  label: Text(isProcessing.value ? '请求中...' : '授予权限'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text('取消'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        if (isRecording.value) {
          final shouldPop = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('确认退出'),
              content: const Text('正在录制视频，确定要退出吗？'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('取消'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('确定'),
                ),
              ],
            ),
          );
          if (shouldPop ?? false) {
            await cameraNotifier.stopRecording();
          }
          return shouldPop ?? false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('录制视频'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              if (isRecording.value) {
                final shouldPop = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('确认退出'),
                    content: const Text('正在录制视频，确定要退出吗？'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('取消'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('确定'),
                      ),
                    ],
                  ),
                );
                if (shouldPop ?? false) {
                  await cameraNotifier.stopRecording();
                  if (context.mounted) {
                    context.pop();
                  }
                }
              } else {
                context.pop();
              }
            },
          ),
        ),
        body: cameraAsync.when(
          data: (controller) {
            if (controller == null) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('正在初始化相机...'),
                  ],
                ),
              );
            }
            return Stack(
              children: [
                // 使用 RepaintBoundary 优化相机预览性能
                RepaintBoundary(
                  child: CameraPreview(controller),
                ),
                if (isRecording.value)
                  const Positioned(
                    top: 20,
                    right: 20,
                    child: _RecordingIndicator(),
                  ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.flash_on),
                        onPressed: isProcessing.value
                            ? null
                            : () => cameraNotifier.toggleTorch(),
                        color: Colors.white,
                      ),
                      FloatingActionButton(
                        onPressed: isProcessing.value || !hasPermissions.value
                            ? null
                            : () async {
                                try {
                                  if (isRecording.value) {
                                    isProcessing.value = true;
                                    final videoPath =
                                        await cameraNotifier.stopRecording();
                                    isRecording.value = false;
                                    isProcessing.value = false;
                                    if (videoPath != null && videoPath.isNotEmpty && context.mounted) {
                                      final videoRecordsNotifier = ref.read(videoRecordsNotifierProvider.notifier);
                                      await videoRecordsNotifier.addRecord(
                                        VideoRecord(
                                          filePath: videoPath,
                                          fileName: videoPath.split('/').last,
                                          recordedAt: DateTime.now(),
                                        ),
                                      );
                                      context.push('/patient', extra: videoPath);
                                    }
                                  } else {
                                    isProcessing.value = true;
                                    await cameraNotifier.startRecording();
                                    isRecording.value = true;
                                    isProcessing.value = false;
                                  }
                                } catch (e) {
                                  isRecording.value = false;
                                  isProcessing.value = false;
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('录制失败: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                        backgroundColor: isProcessing.value
                            ? Colors.grey
                            : isRecording.value
                                ? Colors.red
                                : Colors.blue,
                        child: Icon(
                          isRecording.value ? Icons.stop : Icons.videocam,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('正在初始化相机...'),
              ],
            ),
          ),
          error: (error, stack) => Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  SelectableText.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: '相机初始化失败\n'),
                        TextSpan(
                          text: error.toString(),
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => cameraNotifier.initializeCamera(),
                    child: const Text('重试'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RecordingIndicator extends StatelessWidget {
  const _RecordingIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.7),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          const Text(
            '录制中',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}