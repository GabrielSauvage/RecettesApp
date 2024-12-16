class Category {
  final String name;
  final String type; // Peut être "diet" ou "health"

  Category({required this.name, required this.type});

  factory Category.fromJson(Map<String, dynamic> json, String type) {
    return Category(
      name: json as String,
      type: type,
    );
  }
}
