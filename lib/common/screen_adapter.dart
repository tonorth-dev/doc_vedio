import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScreenSize {
  final double width;
  final double height;
  final String name;

  const ScreenSize({
    required this.width,
    required this.height,
    required this.name,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScreenSize &&
          runtimeType == other.runtimeType &&
          width == other.width &&
          height == other.height &&
          name == other.name;

  @override
  int get hashCode => width.hashCode ^ height.hashCode ^ name.hashCode;
}

class ScreenAdapter {
  static final ScreenAdapter _instance = ScreenAdapter._internal();
  factory ScreenAdapter() => _instance;
  ScreenAdapter._internal();

  // 定义三种尺寸
  static const small = ScreenSize(
    width: 1280,
    height: 720,
    name: 'small',
  );

  static const medium = ScreenSize(
    width: 1600,
    height: 900,
    name: 'medium',
  );

  static const large = ScreenSize(
    width: 2048,
    height: 1152,
    name: 'large',
  );

  // 当前尺寸
  final Rx<ScreenSize> currentSize = medium.obs;

  // 获取合适的尺寸
  ScreenSize getSuitableSize(Size screenSize) {
    debugPrint("判断屏幕尺寸: ${screenSize.width}x${screenSize.height}");
    
    // 筛选出严格小于屏幕尺寸的选项
    final availableSizes = [small, medium, large]
        .where((size) => 
            size.width < screenSize.width && 
            size.height < screenSize.height)
        .toList();
    
    if (availableSizes.isEmpty) {
      debugPrint("没有合适的尺寸选项，使用最小尺寸: ${small.width}x${small.height}");
      return small;
    }
    
    // 在可用尺寸中选择最大的
    final selectedSize = availableSizes.reduce((a, b) => 
        a.width * a.height > b.width * b.height ? a : b);
    
    debugPrint("选择尺寸: ${selectedSize.width}x${selectedSize.height} (${selectedSize.name})");
    return selectedSize;
  }

  // 根据基准尺寸计算实际尺寸
  double getAdaptiveWidth(double width) {
    return width * currentSize.value.width / medium.width;
  }

  double getAdaptiveHeight(double height) {
    debugPrint("getAdaptiveHeight: $height, ${currentSize.value.height}, ${medium.height}");
    return height * currentSize.value.height / medium.height;
  }

  // 获取字体大小
  double getAdaptiveFontSize(double fontSize) {
    final ratio = currentSize.value.width / medium.width;
    return fontSize * ratio;
  }

  // 获取边距
  double getAdaptivePadding(double padding) {
    final ratio = currentSize.value.width / medium.width;
    return padding * ratio;
  }

  // 获取图标大小
  double getAdaptiveIconSize(double size) {
    final ratio = currentSize.value.width / medium.width;
    return size * ratio;
  }
} 