import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'features/home/view.dart';
import 'features/record/view.dart';
import 'features/patient/view.dart';
import 'features/camera/presentation/pages/camera_page.dart';
import 'common/providers/camera_provider.dart';

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

Future<void> _requestPermissions() async {
  try {
    await Permission.camera.request();
    await Permission.microphone.request();
    await Permission.storage.request();
  } catch (e) {
    debugPrint('权限请求错误: $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final hasPermissions = await _checkPermissions();
  if (!hasPermissions) {
    await _requestPermissions();
  }
  
  runApp(const ProviderScope(child: MyApp()));
}

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/records',
      builder: (context, state) => const VideoRecordListPage(),
    ),
    GoRoute(
      path: '/record',
      builder: (context, state) => const CameraPage(),
    ),
    GoRoute(
      path: '/patient',
      builder: (context, state) => PatientFormPage(
        videoPath: state.extra as String,
      ),
    ),
  ],
);

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: '医疗肠镜系统',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
