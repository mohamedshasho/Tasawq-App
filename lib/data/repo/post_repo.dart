import 'dart:io';

import 'package:delivery_app/models/categories.dart';
import 'package:delivery_app/models/product.dart';
import 'package:delivery_app/models/store.dart';
import 'package:delivery_app/models/user_model.dart';

abstract class Repo {
  Person? get currentUser;
  List<UserModel> get allUsers;
  Future<List<Person>> fetchAllData();
  Future<List<Person>> refreshData();
  Future<void> addProduct(Product product);
  Future<void> editProduct(Product product);
  Future<void> editCategory(Category category);
  Future<void> removeProduct(String id);
  Future<void> removeCategory(String id);
  Future<void> addCategory(Category category);
  Future<String> addImage(File file);
  Future<void> addProfileImage(File file);
  Future<void> removeImage(String url);
  Future<List<Person>> addToFavorite(Product product);
  Future<List<Person>> removeToFavorite(Product product);
  Future<bool> setLocation();
  Future<void> ratingStore(Person userStore, double rate);
  Future<void> followStore(Person store);
  Future<void> unFollowStore(Person store);
  Future<void> editUsername(String username);
  Future<void> editAddress(String locality, String subLocality);
  Future<void> setToken(String token);
  Future<void> setLatLong(double lat, double long);
}
