import 'package:flutter/material.dart';

class BuildCircleAvatar extends StatelessWidget {
  final IconData _iconData;
  const BuildCircleAvatar(this._iconData);
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      foregroundColor: Colors.blueAccent,
      child: Icon(_iconData),
    );
  }
}
