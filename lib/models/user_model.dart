import 'package:delivery_app/helper/Strings.dart';

class UserModel {
  String id;
  String username;
  String? image;
  String? token;

  UserModel({required this.id, required this.username, this.image, this.token});

  factory UserModel.fromJson(Map<String, dynamic> json, String id) {
    return UserModel(
      id: id,
      username: json[USERNAME],
      image: json[IMAGE] == null ? null : json[IMAGE][IMAGE],
      token: json[TOKEN],
    );
  }
}
