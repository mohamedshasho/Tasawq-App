import 'dart:async';
import 'dart:io';
import 'package:collection/collection.dart';

import 'package:bloc/bloc.dart';
import 'package:delivery_app/data/repo/post_repo.dart';
import 'package:delivery_app/helper/Maps_service.dart';
import 'package:delivery_app/helper/Session.dart';
import 'package:delivery_app/helper/Strings.dart';
import 'package:delivery_app/helper/location.dart';
import 'package:delivery_app/models/categories.dart';
import 'package:delivery_app/models/product.dart';
import 'package:delivery_app/models/store.dart';
import 'package:delivery_app/models/user_model.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:meta/meta.dart';
part 'data_event.dart';
part 'data_state.dart';

class BlocProduct extends Bloc<DataEvent, DataState> {
  final Repo repo;
  BlocProduct({required this.repo}) : super(DataInitial());

  static BlocProduct get(context) => BlocProvider.of(context);
  List<Person>? usersStore;
  Person? userStore;
  String? cat = ALL;
  static List<String> _locations = [];
  List<UserModel>? allUsers;
  List<String> get locations => _locations;

  Person? getStoreOwner(String id) {
    for (Person store in usersStore!) {
      for (Product p in store.value.storeData!.products!) {
        if (p.id == id) return store;
      }
    }
    return null;
  }

  UserModel? getUser(String id) {
    if (allUsers != null) {
      return allUsers!.firstWhereOrNull((element) => element.id == id);
    } else {
      return null;
    }
  }

  List<Product> searchProduct(String name) {
    List<Product> pro = [];
    if (name.isEmpty) return pro;
    for (Person store in usersStore!) {
      for (Product p in store.value.storeData!.products!) {
        if (p.name.contains(name)) {
          pro.add(p);
        }
      }
    }
    return pro;
  }

  List<Person> searchStore(String name) {
    List<Person> pro = [];
    if (name.isEmpty) return pro;
    for (Person store in usersStore!) {
      if (store.value.username!.contains(name)) {
        pro.add(store);
      }
    }
    return pro;
  }

  void _setup() {
    _locations.clear();
    GoogleMapService.clearMarker();
    if (usersStore != null) {
      usersStore!.forEach((v) {
        if (userStore != null && v.value.storeData!.followers != null) {
          v.value.storeData!.followers!.forEach((key, value) {
            if (userStore!.id == value) {
              ///todo list String for user to save id store because use count following and show it is
              v.value.storeData!.isFollow.id = key;
              v.value.storeData!.isFollow.val = true;
            }
          });
        }
        if (v.value.locationUser != null &&
            v.value.locationUser!.locality != null) {
          if (!locations.contains(v.value.locationUser!.locality!))
            locations.add(v.value.locationUser!.locality!);
          // if (v.id != userStore!.id)
          GoogleMapService.addMarker(
              v.value.locationUser!.lat!,
              v.value.locationUser!.long!,
              v.value.username!,
              v.id,
              v.value.image);
        }
        if (userStore != null && userStore!.value.favorite != null) {
          v.value.storeData!.products!.forEach((element) {
            userStore!.value.favorite!.forEach((id, idFavoriteProduct) {
              if (element.id == idFavoriteProduct) {
                element.favorite!.val = true;
                element.favorite!.id = id;
              }
            });
          });
        }
      });
    }
  }

  Future<Set<Marker>> filterMarker(String category) async {
    if (category == ALL) {
      return GoogleMapService.marker;
    }

    Set<Marker> markers = Set<Marker>();
    markers.clear();
    for (var store in usersStore!) {
      if (store.value.locationUser != null) {
        if (category == store.value.category) {
          Marker? marker = GoogleMapService.marker
              .firstWhereOrNull((element) => element.mapsId.value == store.id);
          if (marker != null) markers.add(marker);
        }
      }
    }
    return markers;
  }

  void filterStores({String? category, String? locality, double? rate}) {
    List<Person> filterStore;
    filterStore = usersStore!.where((e) {
      if (category != null && locality != null && category != ALL) {
        if (category == e.value.category &&
            locality == e.value.locationUser!.locality &&
            e.value.storeData!.rate! >= rate!)
          return true;
        else
          return false;
      } else if (category != null &&
          category != ALL &&
          e.value.storeData!.rate! >= rate!) {
        if (category == e.value.category)
          return true;
        else
          return false;
      } else if (locality != null && e.value.locationUser!.locality != null) {
        if (locality == e.value.locationUser!.locality &&
            e.value.storeData!.rate! >= rate!)
          return true;
        else
          return false;
      } else if (locality == null &&
          category == ALL &&
          e.value.storeData!.rate! >= rate!)
        return true;
      else if (category == null &&
          locality == null &&
          e.value.storeData!.rate! >= rate!) return true;
      return false;
    }).toList();
    emit(DataLoaded(usersStore: filterStore));
  }

  List<String> getAllToken() {
    List<String> tokens = [];
    if (userStore!.value.storeData != null &&
        userStore!.value.storeData!.followers != null) {
      userStore!.value.storeData!.followers!.forEach((key, val) {
        for (var user in allUsers!) {
          if (user.id == val && user.token != null) {
            tokens.add(user.token!);
            break;
          }
        }
      });
    }
    return tokens;
  }

  @override
  Stream<DataState> mapEventToState(
    DataEvent event,
  ) async* {
    try {
      if (event is AddProduct) {
        yield DataLoading();
        await repo.addProduct(event.product);
      }
      if (event is FetchProducts) {
        if (!await isNetworkAvailable()) {
          yield NoNetworkAvail();
          return;
        }
        yield DataLoading();
        usersStore = await repo.fetchAllData();
        if (repo.currentUser != null) userStore = repo.currentUser;
        allUsers = repo.allUsers;
        _setup();
        yield DataLoaded(usersStore: usersStore);
        bool s = await getPreferenceBool(LOCATION);
        if (!s) {
          bool saveAddress = await repo.setLocation();
          await setPreferenceBool(LOCATION, saveAddress);
        }
        LocationHelper().getLocation();
        yield DataLoaded(usersStore: usersStore);
      }
      if (event is RefreshProducts) {
        if (!await isNetworkAvailable()) {
          yield NoNetworkAvail();
          return;
        }
        yield DataLoading();
        usersStore = await repo.refreshData();
        yield DataLoaded(usersStore: usersStore);
      }
      if (event is AddImage) {
        if (!await isNetworkAvailable()) {
          yield NoNetworkAvail();
          return;
        }
        try {
          yield ImageLoading();

          String url = await repo.addImage(event.file);
          yield ImageLoaded(url);
        } catch (e) {
          yield ImageError(e.toString());
        }
      }
      if (event is EditImage) {
        if (!await isNetworkAvailable()) {
          yield NoNetworkAvail();
          return;
        }
        try {
          yield ImageLoading();
          await repo.removeImage(event.product.image);
          String imageUrl = await repo.addImage(event.newFile);
          event.product.image = imageUrl;
          await repo.editProduct(event.product);
        } catch (e) {
          yield ImageError(e.toString());
        }
      }
      if (event is EditProduct) {
        if (!await isNetworkAvailable()) {
          yield NoNetworkAvail();
          return;
        }
        yield DataLoading();
        await repo.editProduct(event.product);
      }
      if (event is DeleteImage) {
        if (!await isNetworkAvailable()) {
          yield NoNetworkAvail();
          return;
        }
        yield ImageLoading();
        await repo.removeImage(event.url);
      }
      try {
        if (event is RemoveProduct) {
          if (!await isNetworkAvailable()) {
            yield NoNetworkAvail();
            return;
          }
          yield DataLoading();
          await repo.removeProduct(event.product.id!);
          await repo.removeImage(event.product.image);
        }
      } catch (e) {
        yield RemoveProductError(e.toString());
        await Future.delayed(Duration(milliseconds: 100));
        yield DataLoaded(usersStore: usersStore);
      }
      if (event is AddToFavorite) {
        if (!await isNetworkAvailable()) {
          yield NoNetworkAvail();
          return;
        }

        ///ToDo اذا اشخاص كثيرة ضافت الى المفضلة مارح يكربج التطبيق؟ و يغير الحالة كثيرا
        usersStore = await repo.addToFavorite(event.product);
      }
      if (event is DeleteToFavorite) {
        if (!await isNetworkAvailable()) {
          yield NoNetworkAvail();
          return;
        }
        usersStore = await repo.removeToFavorite(event.product);
      }
      if (event is GetProductFilter) {
        cat = event.category;
        if (!await isNetworkAvailable()) {
          yield NoNetworkAvail();
          return;
        }
        yield DataLoaded(usersStore: usersStore);
      }
      if (event is AddProfileImage) {
        if (!await isNetworkAvailable()) {
          yield NoNetworkAvail();
          return;
        }
        await repo.addProfileImage(event.file);
      }
      if (event is RatingStoreEvent) {
        if (!await isNetworkAvailable()) {
          yield NoNetworkAvail();
          return;
        }
        await repo.ratingStore(event.userStore, event.rate);
      }
      if (event is EditCategory) {
        if (!await isNetworkAvailable()) {
          yield NoNetworkAvail();
          return;
        }
        try {
          yield DataLoading();
          await repo.editCategory(event.category);
        } catch (e) {
          yield DataError(e.toString());
          await Future.delayed(Duration(milliseconds: 100));
          yield DataLoaded(usersStore: usersStore);
        }
      }
      if (event is RemoveCategory) {
        if (!await isNetworkAvailable()) {
          yield NoNetworkAvail();
          return;
        }
        try {
          yield DataLoading();
          await repo.removeCategory(event.category.id!);
          await repo.removeImage(event.category.image);
        } catch (e) {
          yield DataError(e.toString());
          await Future.delayed(Duration(milliseconds: 100));
          yield DataLoaded(usersStore: usersStore);
        }
      }
      if (event is AddCategory) {
        if (!await isNetworkAvailable()) {
          yield NoNetworkAvail();
          return;
        }
        yield DataLoading();
        await repo.addCategory(event.category);
      }
      if (event is ChildChangedEvent) {
        _setup();
        yield DataLoaded(usersStore: usersStore);
      }
      if (event is FollowStore) {
        if (!await isNetworkAvailable()) {
          yield NoNetworkAvail();
          return;
        }
        await repo.followStore(event.store);
      }
      if (event is UnFollowStore) {
        if (!await isNetworkAvailable()) {
          yield NoNetworkAvail();
          return;
        }
        await repo.unFollowStore(event.store);
      }
      if (event is EditUsername) {
        if (!await isNetworkAvailable()) {
          yield NoNetworkAvail();
          return;
        }
        await repo.editUsername(event.username);
      }
      if (event is EditAddress) {
        if (!await isNetworkAvailable()) {
          yield NoNetworkAvail();
          return;
        }
        await repo.editAddress(event.locality, event.subLocality);
      }
      if (event is SetToken) {
        if (!await isNetworkAvailable()) {
          yield NoNetworkAvail();
          return;
        }
        await repo.setToken(event.token);
      }
      if (event is SetLatLong) {
        if (!await isNetworkAvailable()) {
          yield NoNetworkAvail();
          return;
        }
        await repo.setLatLong(event.latLng.latitude, event.latLng.longitude);
      }
    } catch (e) {
      yield DataError(e.toString());
    }
  }
}
