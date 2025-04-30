import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:json_to_dart/config/global/constant.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:json_to_dart/widgets/dialog/preview_dialog.dart';
import 'package:json_to_dart/screens/json/logic/json_to_dart_logic.dart';
import 'package:json_to_dart/screens/json/view/widgets/custom_drawer_header.dart';

class JsonToDartDrawer extends GetWidget<JsonToDartLogic> {
  const JsonToDartDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Drawer(
      child: Column(
        children: [
          const CustomDrawerHeader(),
          Expanded(
            child: ListView.builder(
              itemCount: controller.history.length,
              itemBuilder: (context, index) {
                final item = controller.history[index];
                return Dismissible(
                  key: ValueKey(item.timestamp),
                  onDismissed: (_) => controller.history.removeAt(index),
                  child: ListTile(
                    title: Text(item.title),
                    subtitle: Text(
                      '${item.subtitle} ${formatTimeHHmm(item.timestamp)}',
                    ),
                    onTap: () => PreviewDialog.showPreviewDialog(context, item),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            PreviewDialog.showPreviewDialog(context, item);
                          },
                          icon: Icon(
                            CupertinoIcons.eye,
                            color: colorScheme.primary,
                          ),
                          tooltip: l10n.preview,
                        ),
                        IconButton(
                          onPressed: () => controller.deleteOne(item),
                          icon: Icon(
                            Icons.delete_forever_outlined,
                            color: colorScheme.error,
                          ),
                          tooltip: l10n.delete,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
