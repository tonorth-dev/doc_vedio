import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as developer;
import '../providers/camera_provider.dart';

class CameraPreviewWidget extends ConsumerWidget {
  const CameraPreviewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraController = ref.watch(cameraControllerNotifierProvider);
    final screenSize = MediaQuery.of(context).size;
    
    return cameraController.when(
      data: (controller) {
        developer.log('相机控制器状态: ${controller?.value.toString()}');
        
        if (controller == null) {
          developer.log('相机控制器为空');
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        if (!controller.value.isInitialized) {
          developer.log('相机控制器未初始化');
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        developer.log('预览尺寸: ${controller.value.previewSize?.width}x${controller.value.previewSize?.height}');
        developer.log('设备方向: ${controller.value.deviceOrientation}');
        developer.log('是否录制中: ${controller.value.isRecordingVideo}');
        developer.log('屏幕尺寸: ${screenSize.width}x${screenSize.height}');

        // 计算预览尺寸
        final previewSize = controller.value.previewSize!;
        final screenAspectRatio = screenSize.width / screenSize.height;
        final previewAspectRatio = previewSize.width / previewSize.height;
        
        // 计算缩放比例
        var scale = screenAspectRatio < previewAspectRatio
            ? screenSize.width / (previewSize.height * screenAspectRatio)
            : screenSize.height / (previewSize.width / previewAspectRatio);
            
        developer.log('计算的缩放比例: $scale');

        return Container(
          color: Colors.black,
          child: ClipRect(
            child: OverflowBox(
              alignment: Alignment.center,
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: screenSize.width,
                  height: screenSize.height,
                  child: AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: CameraPreview(controller),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      loading: () {
        developer.log('相机控制器加载中');
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      error: (error, stack) {
        developer.log('相机预览错误: $error');
        developer.log('错误堆栈: $stack');
        return Center(
          child: SelectableText.rich(
            TextSpan(
              text: '相机预览错误: ',
              style: const TextStyle(color: Colors.red),
              children: [
                TextSpan(text: error.toString()),
              ],
            ),
          ),
        );
      },
    );
  }
} 