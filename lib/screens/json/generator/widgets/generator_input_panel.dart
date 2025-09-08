import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/config/global/constant.dart';
import 'package:json_to_dart/config/theme/app_style.dart';
import 'package:json_to_dart/model/domain/main/json_field.dart';
import 'package:json_to_dart/screens/json/generator/json_generator_logic.dart';
import 'package:json_to_dart/screens/json/widgets/title_text.dart';
import 'package:json_to_dart/screens/json/generator/widgets/field_type_dropdown.dart';

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
                return ListView.builder(
                  itemCount: controller.fields.length,
                  itemBuilder: (ctx, i) => _JsonFieldWidget(
                    field: controller.fields[i],
                    parent: null,
                    rootController: controller,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _JsonFieldWidget extends StatelessWidget {
  final JsonField field;
  final JsonField? parent;
  final JsonGeneratorLogic rootController;
  const _JsonFieldWidget({required this.field, required this.parent, required this.rootController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Padding(
        padding: EdgeInsets.only(left: field.level * 18.0),
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.only(bottom: 6),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (field.type.value == 'object')
                      IconButton(
                        icon: Icon(field.expanded.value ? Icons.expand_less : Icons.expand_more),
                        tooltip: field.expanded.value ? '折叠' : '展开',
                        onPressed: () => field.expanded.toggle(),
                      )
                    else
                      const SizedBox(width: 40),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: field.keyController,
                        decoration: InputDecoration(labelText: l10n.key, hintText: l10n.enterKey),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 120,
                      child: FieldTypeDropdown(
                        value: field.type.value,
                        items: [
                          DropdownMenuItem(value: 'string', child: Text(l10n.string)),
                          DropdownMenuItem(value: 'number', child: Text(l10n.number)),
                          DropdownMenuItem(value: 'bool', child: Text(l10n.boolean)),
                          DropdownMenuItem(value: 'array', child: Text(l10n.array)),
                          const DropdownMenuItem(value: 'object', child: Text('Object')),
                        ],
                        onChanged: (val) => field.updateType(val),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (field.type.value != 'object')
                      Expanded(
                        flex: 3,
                        child: field.type.value == 'bool'
                            ? Row(
                                children: [
                                  Checkbox(
                                    value: field.boolValue.value,
                                    onChanged: (v) {
                                      if (v != null) {
                                        field.boolValue.value = v;
                                        field.valueController.text = v.toString();
                                        field
                                            .valueController
                                            .selection = TextSelection.fromPosition(
                                          TextPosition(offset: field.valueController.text.length),
                                        );
                                      }
                                    },
                                  ),
                                  Text(field.boolValue.value ? 'true' : 'false'),
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
                      )
                    else
                      const SizedBox(),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        if (parent != null) {
                          rootController.removeChildField(parent!, parent!.children.indexOf(field));
                        } else {
                          final idx = rootController.fields.indexOf(field);
                          if (idx != -1) rootController.removeField(idx);
                        }
                      },
                      tooltip: l10n.delete,
                    ),
                    if (field.type.value == 'object')
                      IconButton(
                        icon: const Icon(Icons.add_box),
                        onPressed: () => rootController.addChildField(field),
                        tooltip: l10n.addField,
                      ),
                  ],
                ),
              ),
            ),
            if (field.type.value == 'object' && field.expanded.value)
              Obx(() {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: field.children.length,
                  itemBuilder: (c, i) => _JsonFieldWidget(
                    field: field.children[i],
                    parent: field,
                    rootController: rootController,
                  ),
                );
              }),
          ],
        ),
      );
    });
  }
}
