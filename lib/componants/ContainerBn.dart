import 'package:flutter/material.dart';

import '../constants.dart';

class ContainerBn extends StatelessWidget {
  ContainerBn({required this.title, this.onPress, this.color = kTextColorH6});
  final String title;
  final Function()? onPress;
  final Color color;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    bool isInPortraitMode =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return InkWell(
      onTap: onPress,
      child: Container(
        height: isInPortraitMode ? height * 0.06 : height * 0.12,
        width: width * 0.45,
        alignment: Alignment.center,
        child: Text(
          title,
          style: Theme.of(context).textTheme.headline4,
          overflow: TextOverflow.visible,
          textAlign: TextAlign.center,
        ),
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: color.withOpacity(0.5),
                  spreadRadius: 1.5,
                  offset: Offset(1, 0.8)),
              // BoxShadow(color: Colors.yellowAccent)
            ]),
      ),
    );
  }
}
