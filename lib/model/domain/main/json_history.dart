class JsonHistory {
  final String id;
  final String name;
  final String jsonContent;
  final DateTime createTime;

  JsonHistory({
    required this.id,
    required this.name,
    required this.jsonContent,
    required this.createTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'jsonContent': jsonContent,
      'createTime': createTime.toIso8601String(),
    };
  }

  factory JsonHistory.fromJson(Map<String, dynamic> json) {
    return JsonHistory(
      id: json['id'],
      name: json['name'],
      jsonContent: json['jsonContent'],
      createTime: DateTime.parse(json['createTime']),
    );
  }
}
