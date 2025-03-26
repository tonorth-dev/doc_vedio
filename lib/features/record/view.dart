import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import '../../common/models/video_record.dart';
import '../../common/providers/video_records_provider.dart';
import 'camera_preview_page.dart';
import 'package:go_router/go_router.dart';

class VideoRecordListPage extends HookConsumerWidget {
  const VideoRecordListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoRecordsAsync = ref.watch(videoRecordsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('录制列表'),
      ),
      body: videoRecordsAsync.when(
        data: (records) {
          if (records.isEmpty) {
            return const Center(
              child: Text('暂无录制记录'),
            );
          }
          return ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              return VideoRecordCard(record: record);
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text('加载失败: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/record');
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.videocam),
      ),
    );
  }
}

class VideoRecordCard extends StatefulWidget {
  final VideoRecord record;

  const VideoRecordCard({
    super.key,
    required this.record,
  });

  @override
  State<VideoRecordCard> createState() => _VideoRecordCardState();
}

class _VideoRecordCardState extends State<VideoRecordCard> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.record.filePath))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_controller.value.isInitialized)
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  VideoPlayer(_controller),
                  IconButton.filled(
                    icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                    onPressed: () {
                      setState(() {
                        _isPlaying = !_isPlaying;
                        _isPlaying ? _controller.play() : _controller.pause();
                      });
                    },
                  ),
                ],
              ),
            )
          else
            const AspectRatio(
              aspectRatio: 16 / 9,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('文件名: ${widget.record.fileName}'),
                Text('录制时间: ${widget.record.recordedAt}'),
                if (widget.record.description != null)
                  Text('描述: ${widget.record.description}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 