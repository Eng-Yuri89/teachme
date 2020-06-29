class Category {
  final String name;

  Category({this.name});

  factory Category.fromMap(Map<String, dynamic> data) {
    return Category(
      name: data["name"] ?? "",
    );
  }
}
