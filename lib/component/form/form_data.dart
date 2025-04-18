import 'package:doctor_vedio/component/ui_edit.dart';
import 'package:flutter/material.dart';

import 'enum.dart';

class FormDto {
  /// 字段列表
  final List<FormColumnDto> columns;

  /// 标签宽度
  final double labelWidth;

  /// 标签对齐方式
  final Alignment labelAlignment;

  /// 字段数据
  Map<String, dynamic> data = {};

  String title = "表单";

  FormDto({
    required this.columns,
    this.labelWidth = 55,
    this.labelAlignment = Alignment.centerLeft,
  });
}

extension FormDtoEx on FormDto {
  void edit({Function(Map<String, dynamic>)? submit, bool reset = false, String title = "编辑"}) {
    this.title = title;
    if (reset) {
      data = {};
    }
    UiEdit.requestForm(this, submit: submit);
  }

  void add({Function(Map<String, dynamic>)? submit, bool reset = true, String title = "添加"}) {
    edit(submit: submit, reset: reset, title: title);
  }
}

class FormColumnDto {
  /// 标签
  final String label;

  /// 字段
  final String key;

  /// 渲染函数
  final Widget Function(FormDto, String)? render;

  /// 标签渲染函数
  final Widget Function(FormDto, String)? labelRender;

  /// 限制输入类型
  final FormColumnEnum type;

  /// 限制长度
  final int? maxLength;

  /// 占位文字
  final String? placeholder;

  /// 选项列表
  final List<Map<String, String>>? options;

  FormColumnDto({
    required this.label,
    required this.key,
    this.render,
    this.labelRender,
    this.type = FormColumnEnum.text,
    this.placeholder,
    this.maxLength,
    this.options,
  });
}
   