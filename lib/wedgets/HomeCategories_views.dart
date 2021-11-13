import 'package:delivery_app/bloc/controlApp/ControlAppBloc.dart';
import 'package:delivery_app/helper/Session.dart';
import 'package:delivery_app/helper/Strings.dart';
import 'package:delivery_app/screens_user/Explore_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants.dart';

class HomeCategoriesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Directionality(
      textDirection: ControlAppBloc.get(context).direction == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        body: CustomPaint(
          painter: BackgroundCustomColor(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ' ' + getTranslated(context, 'Welcome'),
                style: Theme.of(context).textTheme.headline2!.copyWith(
                      color: Colors.green[800],
                    ),
              ),
              SizedBox(height: height * 0.01),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '${getTranslated(context, 'All Categories')}:',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              Expanded(
                child: GridView.builder(
                    itemCount: categoriesString.length,
                    padding: EdgeInsets.all(10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: width > 400 ? 3 : 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 5,
                    ),
                    itemBuilder: (ctx, index) {
                      return GestureDetector(
                        child: Column(
                          children: [
                            Flexible(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                    categoriesImage[index],
                                  ),
                                ),
                                color: Theme.of(context).backgroundColor,
                              ),
                            ),
                            Text(
                              getTranslated(context, categoriesString[index]),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, ExploreScreen.id,
                              arguments: categoriesString[index]);
                        },
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
