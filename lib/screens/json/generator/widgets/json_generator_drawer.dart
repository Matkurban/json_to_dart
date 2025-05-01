import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:json_to_dart/screens/json/generator/json_generator_logic.dart';
import 'package:json_to_dart/screens/json/widgets/custom_drawer_header.dart';

class JsonGeneratorDrawer extends GetWidget<JsonGeneratorLogic> {
  const JsonGeneratorDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const CustomDrawerHeader(),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: controller.histories.length,
                itemBuilder: (context, index) {
                  final history = controller.histories[index];
                  return ListTile(
                    title: Text(history.name),
                    subtitle: Text(
                      '${history.createTime.year}-${history.createTime.month}-${history.createTime.day} ${history.createTime.hour}:${history.createTime.minute}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => controller.deleteHistory(history),
                    ),
                    onTap: () {
                      controller.loadFromHistory(history);
                      Navigator.pop(context);
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
