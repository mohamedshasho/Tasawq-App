import 'package:flutter/material.dart';

class BuildButton extends StatelessWidget {
  const BuildButton({
    required this.height,
    required this.width,
    required this.title,
    required this.onPress,
  });

  final double height;
  final double width;
  final String title;
  final Function()? onPress;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        child: Container(
          // width: width * 0.4,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headline3,
              ),
              SizedBox(width: 8),
              Container(
                height: height * 0.08,
                width: width * 0.08,
                decoration: BoxDecoration(
                  color: Theme.of(context).buttonColor,
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage('assets/images/iconbutton.jpg'),
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: onPress,
      ),
    );
  }
}
