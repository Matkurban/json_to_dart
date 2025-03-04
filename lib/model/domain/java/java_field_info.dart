class JavaFieldInfo {
  final String name;
  final String type;
  final String jsonKey;
  final bool isOptional;
  final bool isCustomType;

  JavaFieldInfo({
    required this.name,
    required this.type,
    required this.jsonKey,
    required this.isOptional,
    required this.isCustomType,
  });
}