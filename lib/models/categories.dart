class Category {
  final String? id;
  String name;
  String image;

  Category({this.id, required this.name, required this.image});
  factory Category.fromJson(String key, Map<String, dynamic> data) {
    return Category(name: data['name'], id: key, image: data['image']);
  }
}
