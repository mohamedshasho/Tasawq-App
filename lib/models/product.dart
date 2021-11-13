class Product {
  String? id;
  String name;
  String price;
  String description;
  String image;
  String? location;
  String categoryName;
  Favorite? favorite;
  Product(
      {this.id,
      required this.price,
      required this.name,
      this.location,
      this.favorite,
      required this.description,
      required this.image,
      required this.categoryName});
  factory Product.fromJson(String key, Map<String, dynamic> data) {
    return Product(
      id: key,
      name: data['name'],
      price: data['price'],
      description: data['description'],
      image: data['image'],
      categoryName: data['categoryName'],
    );
  }
}

class Favorite {
  String? id;
  bool val = false;
}
