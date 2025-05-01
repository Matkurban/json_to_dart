import 'package:get/get.dart';
import 'package:flutter/material.dart' show TextEditingController;

class PermutationLogic extends GetxController {
  final List<TextEditingController> inputControllers = List.generate(5, (_) {
    return TextEditingController();
  });

  // 0~9
  final List<List<int>> numberOptions = List.generate(5, (_) {
    return List.generate(10, (i) => i);
  });
  final List<RxInt> selectedNumbers = List.generate(5, (i) => 0.obs);

  final inputNumbers = <int>[].obs;

  final permutations = <List<int>>[].obs;

  // 多列筛选相关
  final List<RxnInt> filterValues = List.generate(5, (_) => RxnInt());

  List<List<int>> get filteredPermutations {
    // 多列筛选：所有设置了筛选值的列都要匹配
    return permutations.where((perm) {
      for (int i = 0; i < 5; i++) {
        final filterVal = filterValues[i].value;
        if (filterVal != null && perm[i] != filterVal) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    for (int i = 0; i < 5; i++) {
      inputControllers[i].text = selectedNumbers[i].value.toString();
      inputControllers[i].addListener(() {
        final v = int.tryParse(inputControllers[i].text);
        if (v != null && numberOptions[i].contains(v)) {
          selectedNumbers[i].value = v;
          _syncAndGenerate();
        }
      });
      ever(selectedNumbers[i], (val) {
        if (inputControllers[i].text != val.toString()) {
          inputControllers[i].text = val.toString();
        }
        _syncAndGenerate();
      });
    }
    _syncAndGenerate();
  }

  void _syncAndGenerate() {
    final numberList = selectedNumbers.map((rx) => rx.value).toList();
    // 修复：允许有重复数字也能生成排列
    if (numberList.length == 5) {
      setNumbers(numberList.cast<int>());
    } else {
      permutations.clear();
      permutations.refresh();
    }
  }

  void setNumbers(List<int> numbers) {
    if (numbers.length == 5) {
      inputNumbers.value = numbers;
      generatePermutations();
    } else {
      permutations.clear();
      permutations.refresh();
    }
  }

  void generatePermutations() {
    permutations.clear();
    _permute(List<int>.from(inputNumbers), 0);
    permutations.refresh();
  }

  void _permute(List<int> nums, int start) {
    if (start == nums.length - 1) {
      permutations.add(List<int>.from(nums));
      return;
    }
    for (int i = start; i < nums.length; i++) {
      _swap(nums, start, i);
      _permute(nums, start + 1);
      _swap(nums, start, i);
    }
  }

  void _swap(List<int> nums, int i, int j) {
    int tmp = nums[i];
    nums[i] = nums[j];
    nums[j] = tmp;
  }

  int get permutationCount => permutations.length;
  int get filteredCount => filteredPermutations.length;

  // 设置某列的筛选值
  void setFilterValue(int column, int? value) {
    filterValues[column].value = value;
  }

  // 清除某列的筛选值
  void clearFilterValue(int column) {
    filterValues[column].value = null;
  }

  @override
  void onClose() {
    for (final c in inputControllers) {
      c.dispose();
    }
    super.onClose();
  }
}
