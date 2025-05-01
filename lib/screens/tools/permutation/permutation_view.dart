import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:json_to_dart/screens/tools/permutation/permutation_logic.dart';
import 'package:json_to_dart/screens/tools/permutation/widgets/circle_container.dart';

class PermutationView extends GetView<PermutationLogic> {
  const PermutationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('数字全排列生成器')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 10,
          children: [
            Row(
              children: List.generate(5, (i) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Obx(() {
                      return Column(
                        children: [
                          DropdownButtonFormField<int>(
                            value: controller.selectedNumbers[i].value,
                            items: List.generate(10, (item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Text('$item'),
                              );
                            }),
                            onChanged: (val) {
                              if (val != null) {
                                controller.selectedNumbers[i].value = val;
                                controller.inputControllers[i].text =
                                    val.toString();
                              }
                            },
                            decoration: InputDecoration(
                              labelText: '选择数字${i + 1}',
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                );
              }),
            ),
            // 五个筛选按钮，对应五列
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (col) {
                return Obx(() {
                  // 获取当前排列的该列所有可能值
                  final values =
                      controller.permutations
                          .map((perm) => perm.length > col ? perm[col] : null)
                          .whereType<int>()
                          .toSet()
                          .toList()
                        ..sort();
                  return Row(
                    children: [
                      Text('筛选${col + 1}列:'),
                      DropdownButton<int>(
                        value: controller.filterValues[col].value,
                        items:
                            values.map((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text('$value'),
                              );
                            }).toList(),
                        onChanged: (val) {
                          controller.setFilterValue(col, val);
                        },
                        hint: const Text('全部'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.clear),
                        tooltip: '清除筛选',
                        onPressed: () {
                          controller.clearFilterValue(col);
                        },
                        iconSize: 18,
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  );
                });
              }),
            ),
            Expanded(
              child: Obx(() {
                final perms = controller.filteredPermutations;
                return ListView.builder(
                  itemCount: perms.length,
                  itemBuilder: (context, idx) {
                    final perm = perms[idx];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            perm.map((item) {
                              return CircleContainer(item: item);
                            }).toList(),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.grey.shade200,
        child: Row(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() {
              return Text(
                '总排列数：${controller.permutationCount}，筛选后：${controller.filteredCount}',
              );
            }),
            ElevatedButton(
              onPressed: () {
                final numberList =
                    controller.inputControllers
                        .map((c) => int.tryParse(c.text.trim()))
                        .toList();
                if (numberList.length == 5 &&
                    numberList.every((e) => e != null)) {
                  controller.setNumbers(numberList.cast<int>());
                } else {
                  Get.snackbar('输入错误', '请确保输入5个有效数字');
                }
              },
              child: const Text('生成所有排列'),
            ),
          ],
        ),
      ),
    );
  }
}
