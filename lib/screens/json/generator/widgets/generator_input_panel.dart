import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/config/global/constant.dart';
import 'package:json_to_dart/config/theme/app_style.dart';
import 'package:json_to_dart/model/domain/main/json_field.dart';
import 'package:json_to_dart/screens/json/generator/json_generator_logic.dart';
import 'package:json_to_dart/screens/json/widgets/title_text.dart';

class GeneratorInputPanel extends GetWidget<JsonGeneratorLogic> {
  const GeneratorInputPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: AppStyle.smallPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                TitleText(text: l10n.jsonFields),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: controller.addField,
                  tooltip: l10n.addField,
                ),
                IconButton(
                  icon: const Icon(Icons.clear_all),
                  onPressed: controller.clearFields,
                  tooltip: l10n.clearFields,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                return ListView(children: [..._buildFieldList(controller.fields, context)]);
              }),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFieldList(
    List<JsonField> fields,
    BuildContext context, {
    int level = 0,
    JsonField? parent,
  }) {
    List<Widget> widgets = [];
    for (int index = 0; index < fields.length; index++) {
      final field = fields[index];
      widgets.add(
        Padding(
          padding: EdgeInsets.only(left: level * 24.0),
          child: Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: field.keyController,
                      decoration: InputDecoration(labelText: l10n.key, hintText: l10n.enterKey),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // 类型选择下拉框
                  SizedBox(
                    width: 130,
                    child: Obx(() {
                      return DropdownButtonFormField<String>(
                        value: field.type.value,
                        decoration: InputDecoration(
                          labelText: "类型",
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        ),
                        items: [
                          DropdownMenuItem(value: 'string', child: Text(l10n.string)),
                          DropdownMenuItem(value: 'number', child: Text(l10n.number)),
                          DropdownMenuItem(value: 'bool', child: Text(l10n.boolean)),
                          DropdownMenuItem(value: 'array', child: Text(l10n.array)),
                          DropdownMenuItem(value: 'object', child: Text('Object')),
                        ],
                        onChanged: (val) {
                          if (val != null && val != field.type.value) {
                            field.updateType(val);
                          }
                        },
                      );
                    }),
                  ),
                  const SizedBox(width: 8),
                  // 依赖类型的输入区域，放入 Obx，避免整行重建
                  Obx(() {
                    if (field.type.value == 'object') {
                      return const SizedBox.shrink();
                    }
                    return Expanded(
                      flex: 3,
                      child: field.type.value == 'bool'
                          ? Row(
                              children: [
                                Obx(() {
                                  return Checkbox(
                                    value: field.boolValue.value,
                                    onChanged: (bool? value) {
                                      if (value != null) {
                                        field.boolValue.value = value;
                                        field.valueController.text = value.toString();
                                        field
                                            .valueController
                                            .selection = TextSelection.fromPosition(
                                          TextPosition(offset: field.valueController.text.length),
                                        );
                                      }
                                    },
                                  );
                                }),
                                Obx(() {
                                  return Text(
                                    field.boolValue.value ? 'true' : 'false',
                                    style: Get.textTheme.bodyLarge,
                                  );
                                }),
                              ],
                            )
                          : TextField(
                              controller: field.valueController,
                              keyboardType: field.type.value == 'number'
                                  ? const TextInputType.numberWithOptions(
                                      decimal: true,
                                      signed: true,
                                    )
                                  : TextInputType.text,
                              inputFormatters: field.type.value == 'number'
                                  ? [FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*$'))]
                                  : null,
                              decoration: InputDecoration(
                                labelText: l10n.value,
                                hintText: field.type.value == 'number' ? '输入数字' : l10n.enterValue,
                              ),
                            ),
                    );
                  }),
                  // 删除按钮
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      if (parent != null) {
                        controller.removeChildField(parent, index);
                      } else {
                        controller.removeField(index);
                      }
                    },
                    tooltip: l10n.delete,
                  ),
                  // 仅当为 object 时展示添加子字段按钮
                  Obx(() {
                    if (field.type.value != 'object') {
                      return const SizedBox.shrink();
                    }
                    return Row(
                      children: [
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.add_box),
                          onPressed: () => controller.addChildField(field),
                          tooltip: l10n.addField,
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      );
      // 递归渲染所有object类型的子字段（响应式）
      widgets.add(
        Obx(() {
          if (field.type.value == 'object' && field.children.isNotEmpty) {
            return Column(
              children: _buildFieldList(field.children, context, level: level + 1, parent: field),
            );
          }
          return const SizedBox.shrink();
        }),
      );
    }
    return widgets;
  }
}
