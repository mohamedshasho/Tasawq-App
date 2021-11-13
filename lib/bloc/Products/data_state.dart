part of 'bloc_product.dart';

@immutable
abstract class DataState {}

class DataInitial extends DataState {}

class DataLoading extends DataState {}

class DataLoaded extends DataState {
  // final List<Product> products;
  final List<Person>? usersStore;
  // final UserStore? currentUser;
  DataLoaded({required this.usersStore});
}

class DataError extends DataState {
  final String msg;
  DataError(this.msg);
}

class ImageLoaded extends DataState {
  final String url;
  ImageLoaded(this.url);
}

class ImageLoading extends DataState {}

class ImageError extends DataState {
  final String msg;
  ImageError(this.msg);
}

class EditProductLoaded extends DataState {
  final Product product;
  EditProductLoaded(this.product);
}

class RemoveProductSuccess extends DataState {}

class RemoveProductError extends DataState {
  final String msg;
  RemoveProductError(this.msg);
}

class NoNetworkAvail extends DataState {}
