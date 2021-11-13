import 'package:delivery_app/helper/Strings.dart';

import 'package:delivery_app/models/product.dart';

import 'categories.dart';

class Store {
  String? username;
  String? email;
  String? password;
  String? image;
  String? type;
  String? category;
  Map<String, String>? favorite;
  Map<String, String>? following;
  LocationUser? locationUser;
  StoreData? storeData;
  Store({
    this.email,
    this.password,
    this.username,
    this.image,
    this.favorite,
    this.category,
    this.following,
    this.type,
    this.locationUser,
    this.storeData,
  });
  factory Store.fromJson(Map<String, dynamic> json) {
    if (json[TYPE_PERSON] == USER) {
      return Store(
        username: json[USERNAME],
        image: json[IMAGE] == null ? null : json[IMAGE][IMAGE],
        type: json[TYPE_PERSON],
        favorite: json[FAVORITE] != null
            ? json[FAVORITE].cast<String, String>()
            : null,
        locationUser: json[LOCATION] != null
            ? LocationUser.fromJson(json[LOCATION].cast<String, dynamic>())
            : null,
        following: json[FOLLOWING] != null
            ? json[FOLLOWING].cast<String, String>()
            : null,
      );
    } else {
      return Store(
        username: json[USERNAME],
        image: json[IMAGE] == null ? null : json[IMAGE][IMAGE],
        type: json[TYPE_PERSON],
        favorite: json[FAVORITE] != null
            ? json[FAVORITE].cast<String, String>()
            : null,
        category: json[CATEGORY],
        locationUser: json[LOCATION] != null
            ? LocationUser.fromJson(json[LOCATION].cast<String, dynamic>())
            : null,
        storeData: StoreData.fromJson(json.cast<String, dynamic>()),
        following: json[FOLLOWING] != null
            ? json[FOLLOWING].cast<String, String>()
            : null,
      );
    }
  }
}

class Person {
  String id;
  Store value;
  Person({required this.id, required this.value});
}

class StoreData {
  double? rate;
  //todo add list<String> rating it's add person id rating the store
  List<Product>? products;
  List<Category>? categories;
  Map<String, String>? followers;
  Map<String, dynamic>? rating;
  IsFollow isFollow = IsFollow();
  StoreData(
      {this.rate, this.products, this.categories, this.followers, this.rating});

  factory StoreData.fromJson(Map<String, dynamic> json) {
    if (json[DATA] == null) {
      return StoreData(rate: 0, products: [], categories: []);
    }

    return StoreData(
      rate: json[DATA][RATING] != null
          ? getRate(json[DATA][RATING].cast<String, dynamic>())
          : 0,
      products: json[DATA][PRODUCTS] != null
          ? getProducts(json.cast<String, dynamic>())
          : [],
      categories: json[DATA][CATEGORIES] != null
          ? getCategories(json[DATA][CATEGORIES].cast<String, dynamic>())
          : [],
      followers: json[DATA][FOLLOWERS] != null
          ? json[DATA][FOLLOWERS].cast<String, String>()
          : null,
      rating: json[DATA][RATING] != null
          ? json[DATA][RATING].cast<String, dynamic>()
          : null,
    );
  }
  static double getRate(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return 0;
    }
    double rating;
    double r = 0;
    int i = 0;
    json.forEach((key, value) {
      r += value;
      i++;
    });
    rating = r / i;
    return double.parse(rating.toStringAsFixed(1));
  }

  static List<Product> getProducts(Map<String, dynamic> json) {
    List<Product>? products = [];
    if (json[DATA][PRODUCTS] == null) {
      return products;
    }

    json[DATA][PRODUCTS].forEach((key, value) {
      Favorite fav = Favorite();
      products.add(Product(
          id: key,
          name: value[NAME],
          image: value[IMAGE],
          price: value[PRICE],
          favorite: fav,
          categoryName: value[CATEGORY_NAME],
          description: value[DESCRIPTION],
          location: json[LOCATION] != null ? json[LOCATION][LOCALITY] : null));
    });
    return products;
  }

  static List<Category> getCategories(Map<String, dynamic> json) {
    List<Category>? categories = [];
    if (json.isEmpty) {
      return categories;
    }
    json.forEach((key, value) {
      categories.add(Category(id: key, name: value[NAME], image: value[IMAGE]));
    });
    return categories;
  }
}

class LocationUser {
  String? locality;
  String? subLocality;
  double? lat;
  double? long;
  LocationUser({this.locality, this.subLocality, this.lat, this.long});

  factory LocationUser.fromJson(Map<String, dynamic> json) {
    return LocationUser(
      locality: json.isEmpty ? null : json[LOCALITY],
      subLocality: json.isEmpty ? null : json[SUB_LOCALITY],
      lat: json.isEmpty ? null : json[LAT],
      long: json.isEmpty ? null : json[LONG],
    );
  }
}

class IsFollow {
  String? id;
  bool val = false;
}
