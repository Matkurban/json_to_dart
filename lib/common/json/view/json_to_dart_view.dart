// lib/views/json_converter_view.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/common/json/logic/json_to_dart_logic.dart';
import 'package:json_to_dart/config/theme/app_style.dart';
import 'package:json_to_dart/widgets/dialog/preview_dialog.dart';
import 'package:json_to_dart/widgets/highlight/highlight_text.dart';

class JsonToDartView extends GetView<JsonToDartLogic> {
  const JsonToDartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JSON转Dart工具'),
        centerTitle: true,
        actions: [
          Builder(
            builder:
                (context) => IconButton(
                  icon: const Icon(Icons.history),
                  onPressed: () {
                    if (Scaffold.of(context).hasEndDrawer) {
                      Scaffold.of(context).openEndDrawer();
                    }
                  },
                  tooltip: '历史记录',
                ),
          ),
        ],
      ),
      body: _buildBody(context),
      endDrawer: _buildHistoryDrawer(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        spacing: 10,
        children: [
          // 输入输出分栏
          Expanded(
            child: Row(
              spacing: 10,
              children: [
                _buildInputPanel(context), // 左侧输入区
                _buildOutputPanel(context), // 右侧输出区
              ],
            ),
          ),
          _buildControlPanel(context), // 底部控制区
        ],
      ),
    );
  }

  Widget _buildInputPanel(BuildContext context) {
    return Expanded(
      flex: 5, // 输入区占比5份
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 10,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInputLabel(context, 'JSON输入'),
                  IconButton(
                    onPressed: () => controller.jsonController.clear(),
                    icon: Icon(Icons.clear),
                    tooltip: '清空输入框',
                  ),
                ],
              ),
              Expanded(
                child: TextField(
                  controller: controller.jsonController,
                  minLines: 6,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  style: AppStyle.codeTextStyle,
                  decoration: InputDecoration(hintText: '在此输入或粘贴JSON内容...'),
                ),
              ),
              _buildClassNameField(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOutputPanel(BuildContext context) {
    return Expanded(
      flex: 5, // 输出区占比5份
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 10,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInputLabel(context, 'Dart输出'),
                  IconButton(
                    icon: const Icon(Icons.copy_all),
                    onPressed: () => _copyDartCode(context),
                    tooltip: '复制代码',
                  ),
                ],
              ),
              Expanded(
                child: Obx(() {
                  if (controller.dartCode.isEmpty) {
                    return const Center(child: Text('点击生成按钮获取Dart类代码'));
                  }
                  return SingleChildScrollView(
                    child: SizedBox(
                      width: double.infinity,
                      child: HighlightText(
                        codeText: controller.dartCode.value,
                        highlighter: controller.highlighter,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlPanel(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          child: Column(
            spacing: 10,
            children: [_buildOptionsRow(context), _buildActionButtons(context)],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionsRow(BuildContext context) {
    return Obx(
      () => Wrap(
        spacing: 20,
        children: [
          _buildCheckbox(
            context,
            value: controller.nonNullable.value,
            label: '非空字段',
            onChanged: (v) => controller.nonNullable.value = v!,
          ),
          _buildCheckbox(
            context,
            value: controller.generateToJson.value,
            label: '生成toJson',
            onChanged: (v) => controller.generateToJson.value = v!,
          ),
          _buildCheckbox(
            context,
            value: controller.generateFromJson.value,
            label: '生成fromJson',
            onChanged: (v) => controller.generateFromJson.value = v!,
          ),
        ],
      ),
    );
  }

  Widget _buildCheckbox(
    BuildContext context, {
    required bool value,
    required String label,
    required ValueChanged<bool?> onChanged,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(value: value, onChanged: onChanged),
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        FilledButton.icon(
          icon: const Icon(Icons.auto_awesome),
          label: const Text('格式化JSON'),
          onPressed: controller.formatJson,
          style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary),
        ),
        FilledButton.icon(
          icon: const Icon(Icons.downloading),
          label: const Text('生成Dart类'),
          onPressed: controller.generateDartClass,
          style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.secondary),
        ),
      ],
    );
  }

  Widget _buildClassNameField(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Text('主类名：', style: Theme.of(context).textTheme.bodyLarge),
        Expanded(
          child: TextField(
            controller: controller.classNameController,
            style: AppStyle.codeTextStyle,
            decoration: InputDecoration(hintText: '请输入主类名'),
          ),
        ),
        IconButton(
          onPressed: () => controller.classNameController.clear(),
          icon: Icon(Icons.clear),
          tooltip: '清空类名',
        ),
      ],
    );
  }

  Widget _buildInputLabel(BuildContext context, String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  void _copyDartCode(BuildContext context) {
    if (controller.dartCode.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: controller.dartCode.value));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('代码已复制到剪贴板')));
    }
  }

  Widget _buildHistoryDrawer(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width * 0.3;
    return Drawer(width: width, child: _buildHistoryPanel(context));
  }

  Widget _buildHistoryPanel(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Obx(() {
      return Column(
        children: [
          ListTile(
            title: Text('历史记录 (${controller.history.length})'),
            trailing: IconButton(
              icon: Icon(Icons.delete_forever_outlined, color: colorScheme.error),
              onPressed: controller.clearHistory,
              tooltip: '清空历史记录',
            ),
          ),
          Expanded(
            child:
                controller.history.isEmpty
                    ? Center(child: Text('暂无历史记录', style: Theme.of(context).textTheme.bodyLarge))
                    : ListView.builder(
                      itemCount: controller.history.length,
                      itemBuilder: (context, index) {
                        final item = controller.history[index];
                        return Dismissible(
                          key: ValueKey(item.timestamp),
                          onDismissed: (_) => controller.history.removeAt(index),
                          child: ListTile(
                            title: Text(item.title),
                            subtitle: Text('${item.subtitle} ${formatTimeHHmm(item.timestamp)}'),
                            onTap: () => PreviewDialog.showPreviewDialog(context, item),
                            trailing: IconButton(
                              onPressed: () => PreviewDialog.showPreviewDialog(context, item),
                              icon: Icon(Icons.preview_outlined, color: colorScheme.primary),
                              tooltip: '预览',
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      );
    });
  }

  // 定义时间格式化方法
  String formatTimeHHmm(DateTime time) {
    // 获取小时并确保两位数格式
    final hour = time.hour.toString().padLeft(2, '0');
    // 获取分钟并确保两位数格式
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
