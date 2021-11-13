import 'package:flutter/material.dart';

import '../constants.dart';

class BuildAppbar extends StatelessWidget {
  const BuildAppbar({
    required this.title,
    required this.onTap,
  });

  final String title;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        child: Row(
          children: [
            Card(
              elevation: 2,
              color: secondaryColor,
              child: InkWell(
                borderRadius: BorderRadius.circular(4),
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
                ),
              ),
            ),
            SizedBox(width: width * 0.05),
            Text(
              title,
              style: Theme.of(context).textTheme.headline5,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 8.0, top: 2),
              child: Image.asset(
                'assets/images/appIcon.png',
                height: 30,
                width: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
