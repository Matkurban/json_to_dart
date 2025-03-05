// 历史记录模型类
class HistoryItem {
  final String title;
  final String subtitle;
  final String json;
  final String code;
  final DateTime timestamp;

  HistoryItem({
    required this.title,
    required this.subtitle,
    required this.json,
    required this.code,
    required this.timestamp,
  });

  // 将对象转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'json': json,
      'code': code,
      'timestamp': timestamp.millisecondsSinceEpoch, // 将 DateTime 转换为时间戳
    };
  }

  // 从 JSON 创建对象
  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      json: json['json'] as String,
      code: json['code'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int), // 从时间戳恢复 DateTime
    );
  }
}
