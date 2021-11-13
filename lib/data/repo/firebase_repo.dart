import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart';

import 'package:delivery_app/bloc/Products/bloc_product.dart';
import 'package:delivery_app/data/repo/post_repo.dart';
import 'package:delivery_app/helper/Strings.dart';
import 'package:delivery_app/helper/location.dart';
import 'package:delivery_app/models/categories.dart';
import 'package:delivery_app/models/product.dart';
import 'package:delivery_app/models/store.dart';
import 'package:delivery_app/models/user_model.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class FirebaseRepo implements Repo {
  static List<Person> usersStore = [];
  static Person? _userStore;
  static List<UserModel> _allUsers = [];
  Person? get currentUser => _userStore;
  List<UserModel> get allUsers => _allUsers;
  static var childChangedListener;

  static Future? initial(BuildContext context) {
    DatabaseReference db = FirebaseDatabase.instance.reference().child(PERSON);
    BlocProduct bloc = BlocProduct.get(context);
    childChangedListener = db.onChildChanged.listen((event) {
      User? user = FirebaseAuth.instance.currentUser;
      Person? person = usersStore
          .firstWhereOrNull((val) => val.id == event.snapshot.key.toString());
      Map<String, dynamic> data =
          Map<String, dynamic>.from(event.snapshot.value);
      Store userModel = Store.fromJson(data);
      if (person != null) person.value = userModel;

      ///todo hire add allUsers update also
      if (user != null && user.uid == event.snapshot.key) {
        _userStore!.value = userModel;
      }
      var correctUserIndex =
          _allUsers.indexWhere((element) => element.id == event.snapshot.key);
      _allUsers[correctUserIndex] =
          UserModel.fromJson(data, event.snapshot.key.toString());
      bloc.add(ChildChangedEvent());
    });
  }

  static Future? cancel() async {
    await childChangedListener.cancel();
  }

  @override
  Future<List<Person>> fetchAllData() async {
    usersStore.clear();
    try {
      User? user = FirebaseAuth.instance.currentUser;
      var response = await http
          .get(Uri.parse(URLPerson))
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          data.forEach((key, value) {
            _allUsers
                .add(UserModel.fromJson(value.cast<String, dynamic>(), key));
            if (user != null && key == user.uid) {
              _userStore = Person(id: key, value: Store.fromJson(value));
            }
            if (value[TYPE_PERSON] == DELIVERY) {
              usersStore.add(Person(id: key, value: Store.fromJson(value)));
            }
          });
        }
        return usersStore;
      }
    } on TimeoutException catch (e) {
      throw 'Timeout';
    } on Error catch (e) {
      print(e.toString());
      throw 'Error: $e';
    }
    throw 'Can\'t load Data';
  }

  @override
  Future<List<Person>> refreshData() async {
    try {
      var response = await http
          .get(Uri.parse(URLPerson))
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        data.forEach((key, value) {
          _allUsers.add(UserModel.fromJson(value.cast<String, dynamic>(), key));
          if (value[TYPE_PERSON] == DELIVERY) {
            var found = usersStore.firstWhereOrNull((e) => e.id == key);
            if (found == null)
              usersStore.add(Person(id: key, value: Store.fromJson(value)));
          }
        });
        return usersStore;
      }
    } on TimeoutException catch (e) {
      throw 'Timeout';
    } on Error catch (e) {
      throw 'Error: $e';
    }
    throw 'Can\'t load Data';
  }

  @override
  Future<void> addCategory(Category category) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference db = FirebaseDatabase.instance
          .reference()
          .child(PERSON)
          .child(user.uid)
          .child(DATA)
          .child(CATEGORIES)
          .push();
      await db.set({
        NAME: category.name,
        IMAGE: category.image,
      });
    }
  }

  @override
  Future<void> addProduct(Product product) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference db = FirebaseDatabase.instance
          .reference()
          .child(PERSON)
          .child(user.uid)
          .child(DATA)
          .child(PRODUCTS)
          .push();
      await db.set({
        NAME: product.name,
        DESCRIPTION: product.description,
        PRICE: product.price,
        IMAGE: product.image,
        CATEGORY_NAME: product.categoryName,
      });
    }
  }

  @override
  Future<String> addImage(File file) async {
    if (_userStore != null) {
      String fileID = Uuid().v4();
      try {
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('delivery_images')
            .child(fileID);
        await ref.putFile(file);
        final url = await ref.getDownloadURL();
        return url;
      } catch (e) {
        throw 'error when upload image';
      }
    }
    throw 'User not found.!';
  }

  @override
  Future<void> addProfileImage(File file) async {
    String url = await addImage(file);
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference db = FirebaseDatabase.instance
          .reference()
          .child(PERSON)
          .child(user.uid)
          .child(IMAGE);
      await db.set({IMAGE: url});
    }
  }

  @override
  Future<void> editProduct(Product product) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference db = FirebaseDatabase.instance
          .reference()
          .child(PERSON)
          .child(user.uid)
          .child(DATA)
          .child(PRODUCTS)
          .child(product.id!);
      await db.set({
        NAME: product.name,
        DESCRIPTION: product.description,
        PRICE: product.price,
        IMAGE: product.image,
        CATEGORY_NAME: product.categoryName,
      });
    } else
      throw 'Please SingIN First!';
  }

  @override
  Future<void> removeProduct(String id) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference db = FirebaseDatabase.instance
          .reference()
          .child(PERSON)
          .child(user.uid)
          .child(DATA)
          .child(PRODUCTS)
          .child(id);
      await db.remove();
    } else {
      throw 'Please SingIN First!';
    }
  }

  @override
  Future<void> removeCategory(String id) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference db = FirebaseDatabase.instance
          .reference()
          .child(PERSON)
          .child(user.uid)
          .child(DATA)
          .child(CATEGORIES)
          .child(id);
      await db.remove();
    } else {
      throw 'Please SingIN First!';
    }
  }

  @override
  Future<void> editCategory(Category category) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference db = FirebaseDatabase.instance
          .reference()
          .child(PERSON)
          .child(user.uid)
          .child(DATA)
          .child(CATEGORIES)
          .child(category.id!);
      await db.set({
        NAME: category.name,
        IMAGE: category.image,
      });
    } else {
      throw 'Please SingIN First!';
    }
  }

  @override
  Future<void> removeImage(String url) async {
    await firebase_storage.FirebaseStorage.instance.refFromURL(url).delete();
  }

  @override
  Future<List<Person>> addToFavorite(Product product) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference db = FirebaseDatabase.instance
          .reference()
          .child(PERSON)
          .child(user.uid)
          .child(FAVORITE)
          .push();
      await db.set(product.id).whenComplete(() {
        product.favorite!.id = db.key;
        product.favorite!.val = true;
      });
      return usersStore;
    } else {
      print('no found user');
      return usersStore;
    }
  }

  @override
  Future<List<Person>> removeToFavorite(Product product) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference db = FirebaseDatabase.instance
          .reference()
          .child(PERSON)
          .child(user.uid)
          .child(FAVORITE);
      await db.child(product.favorite!.id!).remove().whenComplete(() {
        product.favorite!.val = false;
        product.favorite!.id = null;
      });
      return usersStore;
    } else
      return usersStore;
  }

  @override
  Future<bool> setLocation() async {
    final location = LocationHelper();
    LocationData? locationData = await location.getLocation();
    User? user = FirebaseAuth.instance.currentUser;
    print(locationData);
    if (locationData != null && user != null && locationData.latitude != 0.0) {
      DatabaseReference db = FirebaseDatabase.instance
          .reference()
          .child(PERSON)
          .child(user.uid)
          .child(LOCATION);
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      String languageCode = _prefs.getString(LANGUAGE_CODE) ?? "ar";
      List<Placemark> placemarks = await placemarkFromCoordinates(
        locationData.latitude!,
        locationData.longitude!,
        localeIdentifier: languageCode,
      );
      String? locality = placemarks[0].locality;
      print(placemarks[0]);
      print(placemarks[1]);
      String? sublocality = placemarks[0].subLocality;
      print(locality);
      print('sublocality: ' + sublocality.toString());
      await db.set({
        LAT: locationData.latitude,
        LONG: locationData.longitude,
        LOCALITY: locality,
        SUB_LOCALITY: sublocality,
      });
      //اضيف واصفة اخزنها اذا اضاف الموقع لا يتم اعادة استخدام الميثود
      return true;
    }
    return false;
  }

  @override
  Future<void> setLatLong(double lat, double long) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference db = FirebaseDatabase.instance
          .reference()
          .child(PERSON)
          .child(user.uid)
          .child(LOCATION);
      await db.child(LAT).set(lat);
      await db.child(LONG).set(long);
    }
  }

  @override
  Future<void> ratingStore(Person userStore, double rate) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference db = FirebaseDatabase.instance
          .reference()
          .child(PERSON)
          .child(userStore.id)
          .child(DATA)
          .child(RATING)
          .child(user.uid);
      await db.set(rate);
    }
  }

  @override
  Future<void> followStore(Person store) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference db = FirebaseDatabase.instance
          .reference()
          .child(PERSON)
          .child(store.id)
          .child(DATA)
          .child(FOLLOWERS)
          .push();
      await db.set(user.uid).whenComplete(() {
        store.value.storeData!.isFollow.id = db.key;
        store.value.storeData!.isFollow.val = true;
      });
      await FirebaseDatabase.instance
          .reference()
          .child(PERSON)
          .child(user.uid)
          .child(FOLLOWING)
          .child(store.id)
          .set(store.id);
      // /اساوي بيانات لل فولوينغ
    }
  }

  @override
  Future<void> unFollowStore(Person store) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference db = FirebaseDatabase.instance
          .reference()
          .child(PERSON)
          .child(store.id)
          .child(DATA)
          .child(FOLLOWERS)
          .child(store.value.storeData!.isFollow.id!);
      await db.remove().whenComplete(() {
        store.value.storeData!.isFollow.id = null;
        store.value.storeData!.isFollow.val = false;
      });
      await FirebaseDatabase.instance
          .reference()
          .child(PERSON)
          .child(user.uid)
          .child(FOLLOWING)
          .child(store.id)
          .remove();
    }
  }

  @override
  Future<void> editUsername(String username) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference db = FirebaseDatabase.instance
          .reference()
          .child(PERSON)
          .child(user.uid)
          .child(USERNAME);
      await db.set(username);
    }
  }

  @override
  Future<void> editAddress(String locality, String subLocality) async {
    print(locality);
    print(subLocality);
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference db = FirebaseDatabase.instance
          .reference()
          .child(PERSON)
          .child(user.uid)
          .child(LOCATION);
      await db.child(LOCALITY).set(locality);
      await db.child(SUB_LOCALITY).set(subLocality);
    }
  }

  @override
  Future<void> setToken(String token) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseDatabase.instance
          .reference()
          .child(PERSON)
          .child(user.uid)
          .child(TOKEN)
          .set(token);
    }
  }
}
