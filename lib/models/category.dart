class Category {
  final String name;
  final String id;

  Category({this.name, this.id});

  factory Category.fromMap(Map<String, dynamic> data, String documentId) {
    return Category(
      name: data["name"] ?? "",
      id: documentId ?? "",
    );
  }
}
