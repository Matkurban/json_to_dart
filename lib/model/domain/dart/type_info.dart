class TypeInfo {
  final String type;
  final String baseType;
  final String? listType;
  final bool isDynamic;
  final bool isCustomType;
  final bool isList;
  final bool isListOfCustomType;
  final bool isBasicListType;
  final bool nullable;
  final String? defaultValue;

  TypeInfo({
    required this.type,
    required this.baseType,
    this.listType,
    this.isDynamic = false,
    this.isCustomType = false,
    this.isList = false,
    this.isListOfCustomType = false,
    this.isBasicListType = false,
    this.nullable = true,
    this.defaultValue,
  });
}
