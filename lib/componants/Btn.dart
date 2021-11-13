import 'package:flutter/material.dart';

class Btn extends StatelessWidget {
  const Btn({
    required this.title,
    required this.onPressed,
    required this.color,
  });

  final String title;
  final Function()? onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    bool isInPortraitMode =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: isInPortraitMode ? height * 0.09 : height * 0.15,
        width: width * 0.45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          title,
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
    );
  }
}

class IconBn extends StatelessWidget {
  const IconBn({required this.iconData, required this.onPress});
  final IconData iconData;
  final Function() onPress;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPress,
      icon: Icon(iconData),
    );
  }
}
