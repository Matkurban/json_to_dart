class FieldInfo {
  final String jsonKey;
  final String name;
  final String type;
  final String baseType;
  final String? listType;
  final bool isDynamic;
  final bool isCustomType;
  final bool isList;
  final bool isListOfCustomType;
  final bool isBasicListType;
  final String? defaultValue;

  FieldInfo({
    required this.jsonKey,
    required this.name,
    required this.type,
    required this.baseType,
    this.listType,
    this.isDynamic = false,
    this.isCustomType = false,
    this.isList = false,
    this.isListOfCustomType = false,
    this.isBasicListType = false,
    this.defaultValue,
  });
}