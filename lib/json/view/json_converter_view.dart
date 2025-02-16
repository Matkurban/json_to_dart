// lib/views/json_converter_view.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/json/logic/json_converter_logic.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_highlight/themes/vs.dart';

class JsonConverterView extends GetView<JsonConverterLogic> {
  const JsonConverterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildDesktopLayout(context),
      endDrawer: _buildHistoryDrawer(context),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // 输入输出分栏
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildInputPanel(context), // 左侧输入区
                const SizedBox(width: 16),
                _buildOutputPanel(context), // 右侧输出区
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildControlPanel(context), // 底部控制区
        ],
      ),
    );
  }

  Widget _buildInputPanel(BuildContext context) {
    return Expanded(
      flex: 5, // 输入区占比5份
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildInputLabel(context, 'JSON输入'),
              const SizedBox(height: 12),
              Expanded(
                child: TextField(
                  controller: controller.jsonController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    hintText: '在此输入或粘贴JSON内容...',
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
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
              const SizedBox(height: 12),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Obx(() {
                    if (controller.dartCode.isEmpty) {
                      return const Center(child: Text('点击生成按钮获取Dart类代码'));
                    }
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(12),
                      child: HighlightView(
                        controller.dartCode.value,
                        language: 'dart',
                        theme: Theme.of(context).brightness == Brightness.light ? githubTheme : vsTheme,
                        padding: const EdgeInsets.all(12),
                        textStyle: const TextStyle(fontFamily: 'FiraCode', fontSize: 13),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlPanel(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        child: Column(children: [_buildOptionsRow(context), const SizedBox(height: 16), _buildActionButtons(context)]),
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
        FilledButton.tonalIcon(
          icon: const Icon(Icons.auto_awesome, size: 20),
          label: const Text('格式化JSON'),
          onPressed: controller.formatJson,
        ),
        FilledButton.icon(
          icon: const Icon(Icons.downloading, size: 20),
          label: const Text('生成Dart类'),
          onPressed: controller.generateDartClass,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
        ),
      ],
    );
  }

  Widget _buildClassNameField(BuildContext context) {
    return Row(
      children: [
        Text('主类名：', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: controller.classNameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputLabel(BuildContext context, String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
      ),
    );
  }

  void _copyDartCode(BuildContext context) {
    if (controller.dartCode.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: controller.dartCode.value));
      Get.snackbar(
        '成功',
        '代码已复制到剪贴板',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.green,
      );
    }
  }

  Widget _buildHistoryDrawer(BuildContext context) {
    return Drawer(width: 300, child: _buildHistoryPanel(context));
  }

  Widget _buildHistoryPanel(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          ListTile(
            title: Text('历史记录 (${controller.history.length})'),
            trailing: IconButton(icon: const Icon(Icons.delete), onPressed: controller.clearHistory),
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
                          background: Container(color: Colors.red),
                          onDismissed: (_) => controller.history.removeAt(index),
                          child: ListTile(
                            title: Text(item.title),
                            subtitle: Text('${item.subtitle} ${formatTimeHHmm(item.timestamp)}'),
                            onTap: () => controller.loadHistory(),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  // 定义时间格式化方法
  String formatTimeHHmm(DateTime time) {
    // 获取小时并确保两位数格式
    final hour = time.hour.toString().padLeft(2, '0');
    // 获取分钟并确保两位数格式
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('高级JSON转换工具'),
      actions: [
        Builder(
          builder:
              (innerContext) => IconButton(
                icon: const Icon(Icons.history),
                onPressed: () {
                  // 使用 innerContext 而非外部的 context
                  if (Scaffold.of(innerContext).hasEndDrawer) {
                    Scaffold.of(innerContext).openEndDrawer();
                  }
                },
                tooltip: '历史记录',
              ),
        ),
      ],
    );
  }

}
