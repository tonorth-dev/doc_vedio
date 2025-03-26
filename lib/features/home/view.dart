import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../common/providers/camera_provider.dart';

Future<bool> _checkPermissions() async {
  try {
    final camera = await Permission.camera.status;
    final microphone = await Permission.microphone.status;
    
    // 只检查相机和麦克风权限
    if (camera.isGranted && microphone.isGranted) {
      return true;
    }
    
    // 如果权限被永久拒绝，引导用户去设置页面
    if (camera.isPermanentlyDenied || microphone.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }
    
    // 如果权限未授予，请求权限
    if (!camera.isGranted) {
      final result = await Permission.camera.request();
      if (!result.isGranted) return false;
    }
    
    if (!microphone.isGranted) {
      final result = await Permission.microphone.request();
      if (!result.isGranted) return false;
    }
    
    return true;
  } catch (e) {
    debugPrint('权限检查错误: $e');
    return false;
  }
}

class PatientInfoDialog extends HookConsumerWidget {
  final String videoPath;
  
  const PatientInfoDialog({
    super.key,
    required this.videoPath,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final ageController = useTextEditingController();
    final notesController = useTextEditingController();
    
    return AlertDialog(
      title: const Text('病人信息'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: '姓名',
                hintText: '请输入病人姓名',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(
                labelText: '年龄',
                hintText: '请输入病人年龄',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: '备注',
                hintText: '请输入备注信息',
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: () {
            // TODO: 保存病人信息和视频路径到数据库
            Navigator.of(context).pop({
              'name': nameController.text,
              'age': ageController.text,
              'notes': notesController.text,
              'videoPath': videoPath,
            });
          },
          child: const Text('保存'),
        ),
      ],
    );
  }
}

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('医疗肠镜系统'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () => context.push('/records'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '欢迎使用医疗肠镜系统',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => context.push('/record'),
              icon: const Icon(Icons.videocam),
              label: const Text('开始录制'),
            ),
          ],
        ),
      ),
    );
  }
} 