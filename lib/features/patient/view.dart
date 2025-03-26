import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class PatientFormPage extends HookConsumerWidget {
  final String videoPath;

  const PatientFormPage({
    super.key,
    required this.videoPath,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    final diagnosisController = TextEditingController();
    final videoController = VideoPlayerController.file(File(videoPath));

    useEffect(() {
      videoController.initialize().then((_) {
        videoController.play();
        videoController.setLooping(true);
      });
      return () => videoController.dispose();
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('病人信息'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: VideoPlayer(videoController),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: '姓名',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(
                labelText: '年龄',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: diagnosisController,
              decoration: const InputDecoration(
                labelText: '诊断结果',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // TODO: 保存病人信息和视频
                context.go('/');
              },
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
  }
} 