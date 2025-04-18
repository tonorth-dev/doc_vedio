import 'package:doctor_vedio/app/home/tab_bar/logic.dart';
import 'package:doctor_vedio/ex/ex_anim.dart';
import 'package:doctor_vedio/ex/ex_list.dart';
import 'package:doctor_vedio/theme/theme_util.dart';
import 'package:doctor_vedio/theme/ui_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class SidebarPage extends StatelessWidget {
  SidebarPage({Key? key}) : super(key: key);

  final logic = Get.put(SidebarLogic());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 50,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth:50, maxWidth: 50),
          child: _default(),
        ));
  }

  Widget _default() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        var item = SidebarLogic.treeList[index];
        return item.children.isNotEmpty ? _tree(item) : _text(item);
      },
      itemCount: SidebarLogic.treeList.length,
    );
  }

  static const double leftSpace = 12;

  Widget _text(SidebarTree item, {double left = leftSpace}) {
    return MouseRegion(
      // 鼠标悬停
      onEnter: (event) {
        logic.animName.value = item.name;
      },
      onExit: (event) {
        logic.animName.value = "";
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            if (item.children.isNotEmpty) {
              item.isExpanded.value = !item.isExpanded.value;
              SidebarLogic.selSidebarTree(item);
              return;
            }
            SidebarLogic.selectName.value = item.name;
            SidebarLogic.selSidebarTree(item);
            TabBarLogic.addPage(item);
          },
          child: Obx(() {
            var selected = SidebarLogic.selectName.value == item.name;
            return Container(
                width: double.infinity,
                decoration: ThemeUtil.boxDecoration(
                    color: selected ? UiTheme.primary() : null, radius: 12),
                height: 50,
                child: Row(
                  children: [
                    SizedBox(width: left),
                    Icon(
                      item.icon,
                      color: selected
                          ? UiTheme.getOnPrimary(selected)
                          : item.color,
                    ).toJump(logic.animName.value == item.name),
                    ThemeUtil.width(),
                    Text(
                      item.name,
                      style: TextStyle(color: UiTheme.getOnPrimary(selected)),
                    ),
                    const Spacer(),
                    // 下拉箭头
                    Visibility(
                      visible: item.children.isNotEmpty,
                      child: Icon(
                        Icons.arrow_drop_up,
                        color: UiTheme.getTextColor(selected),
                        size: 28,
                      ).toRotate(item.isExpanded.value),
                    ),
                    ThemeUtil.width(),
                  ],
                ));
          }),
        ),
      ),
    );
  }

  Widget _tree(SidebarTree item, {double left = leftSpace}) {
    return Column(
      children: [
        _text(item, left: left),
        Obx(() {
          return Visibility(
              visible: item.isExpanded.value,
              child: Column(
                children: item.children.toWidgets((e) {
                  if (e.children.isNotEmpty) {
                    return _tree(e, left: left + leftSpace);
                  }
                  return _text(e, left: left + leftSpace);
                }),
              ));
        })
      ],
    );
  }
}
