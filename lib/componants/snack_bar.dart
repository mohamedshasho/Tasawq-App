import 'package:flutter/material.dart';

setSnackbar(String msg, BuildContext context,
    [GlobalKey<ScaffoldState>? _scaffoldKey]) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: new Text(
      msg,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.black),
    ),
    backgroundColor: Colors.grey.shade100,
    elevation: 2.0,
  ));
}
