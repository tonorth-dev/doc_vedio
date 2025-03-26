import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../common/providers/camera_provider.dart';
import '../../../../common/widgets/camera_preview_widget.dart';

class CameraPage extends ConsumerStatefulWidget {
  const CameraPage({super.key});

  @override
  ConsumerState<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends ConsumerState<CameraPage> {
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      await ref.read(cameraControllerNotifierProvider.notifier).initializeCamera();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('需要相机权限才能使用此功能'),
          ),
        );
      }
    }
  }

  Future<void> _toggleRecording() async {
    final notifier = ref.read(cameraControllerNotifierProvider.notifier);
    
    if (!_isRecording) {
      final videoPath = await notifier.startRecording();
      if (videoPath != null) {
        setState(() => _isRecording = true);
      }
    } else {
      final videoPath = await notifier.stopRecording();
      if (videoPath != null) {
        setState(() => _isRecording = false);
        // TODO: 处理录制完成的视频
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            const CameraPreviewWidget(),
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.flip_camera_ios),
                    color: Colors.white,
                    onPressed: () {
                      ref.read(cameraControllerNotifierProvider.notifier).switchCamera();
                    },
                  ),
                  GestureDetector(
                    onTap: _toggleRecording,
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 4,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isRecording ? Colors.red : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.flash_off),
                    color: Colors.white,
                    onPressed: () {
                      ref.read(cameraControllerNotifierProvider.notifier).toggleTorch();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 