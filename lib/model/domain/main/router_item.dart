class RouterItem {
  final String name;
  final String router;

  RouterItem({required this.name, required this.router});

  factory RouterItem.fromJson(Map<String, dynamic> json) {
    return RouterItem(
      name: json['name'] as String,
      router: json['router'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'name': name, 'router': router};
}
