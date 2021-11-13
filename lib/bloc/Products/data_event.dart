part of 'bloc_product.dart';

@immutable
abstract class DataEvent {}

class AddProduct extends DataEvent {
  final Product product;
  AddProduct(this.product);
}

class AddImage extends DataEvent {
  final File file;
  AddImage(this.file);
}

class EditImage extends DataEvent {
  final File newFile;
  final Product product;
  EditImage({required this.newFile, required this.product});
}

class EditImageCategory extends DataEvent {
  final File newFile;
  final Category category;
  EditImageCategory({required this.newFile, required this.category});
}

class DeleteImage extends DataEvent {
  final String url;
  DeleteImage(this.url);
}

class FetchProducts extends DataEvent {}

class RefreshProducts extends DataEvent {}

class EditProduct extends DataEvent {
  final Product product;
  EditProduct(this.product);
}

class RemoveProduct extends DataEvent {
  final Product product;
  RemoveProduct(this.product);
}

class AddToFavorite extends DataEvent {
  final Product product;
  AddToFavorite(this.product);
}

class DeleteToFavorite extends DataEvent {
  final Product product;
  DeleteToFavorite(this.product);
}

class GetProductFilter extends DataEvent {
  final String category;
  GetProductFilter(this.category);
}

class AddProfileImage extends DataEvent {
  final File file;
  AddProfileImage(this.file);
}

class RatingStoreEvent extends DataEvent {
  final Person userStore;
  final double rate;
  RatingStoreEvent(this.userStore, this.rate);
}

class EditCategory extends DataEvent {
  final Category category;
  EditCategory(this.category);
}

class RemoveCategory extends DataEvent {
  final Category category;
  RemoveCategory(this.category);
}

class AddCategory extends DataEvent {
  final Category category;
  AddCategory(this.category);
}

class ChildChangedEvent extends DataEvent {}

class FollowStore extends DataEvent {
  final Person store;
  FollowStore(this.store);
}

class UnFollowStore extends DataEvent {
  final Person store;
  UnFollowStore(this.store);
}

class EditUsername extends DataEvent {
  final String username;
  EditUsername(this.username);
}

class EditAddress extends DataEvent {
  final String locality;
  final String subLocality;
  EditAddress({required this.locality, required this.subLocality});
}

class SetToken extends DataEvent {
  final String token;
  SetToken(this.token);
}

class SetLatLong extends DataEvent {
  final LatLng latLng;
  SetLatLong(this.latLng);
}
