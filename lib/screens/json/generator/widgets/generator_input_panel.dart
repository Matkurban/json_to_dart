import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:json_to_dart/config/global/constant.dart';
import 'package:json_to_dart/config/theme/app_style.dart';
import 'package:json_to_dart/model/domain/main/json_field.dart';
import 'package:json_to_dart/screens/json/widgets/title_text.dart';
import 'package:json_to_dart/screens/json/generator/json_generator_logic.dart';

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
                return ListView(
                  children: [..._buildFieldList(controller.fields, context)],
                );
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
                      decoration: InputDecoration(
                        labelText: l10n.key,
                        hintText: l10n.enterKey,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // 类型选择下拉框
                  SizedBox(
                    width: 130,
                    child: DropdownButtonFormField<String>(
                      value: field.type,
                      decoration: InputDecoration(
                        labelText: "类型",
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'string',
                          child: Text(l10n.string),
                        ),
                        DropdownMenuItem(
                          value: 'number',
                          child: Text(l10n.number),
                        ),
                        DropdownMenuItem(
                          value: 'bool',
                          child: Text(l10n.boolean),
                        ),
                        DropdownMenuItem(
                          value: 'array',
                          child: Text(l10n.array),
                        ),
                        DropdownMenuItem(
                          value: 'object',
                          child: Text('Object'),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null && val != field.type) {
                          final list = parent?.children ?? controller.fields;
                          controller.updateFieldType(
                            index,
                            val,
                            targetList: list,
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (field.type != 'object')
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: field.valueController,
                        decoration: InputDecoration(
                          labelText: l10n.value,
                          hintText: l10n.enterValue,
                        ),
                      ),
                    ),
                  if (field.type == 'object') const SizedBox(width: 8),
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
                  if (field.type == 'object')
                    IconButton(
                      icon: const Icon(Icons.add_box),
                      onPressed: () => controller.addChildField(field),
                      tooltip: l10n.addField,
                    ),
                ],
              ),
            ),
          ),
        ),
      );
      // 递归渲染所有object类型的子字段
      if (field.type == 'object' && field.children.isNotEmpty) {
        widgets.addAll(
          _buildFieldList(
            field.children,
            context,
            level: level + 1,
            parent: field,
          ),
        );
      }
    }
    return widgets;
  }
}
