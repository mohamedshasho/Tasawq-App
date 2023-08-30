import 'dart:ui';

import 'package:delivery_app/helper/Session.dart';

import '../componants/ContainerBn.dart';
import '../bloc/Products/bloc_product.dart';
import '../helper/Strings.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ShowBottomSheet extends StatefulWidget {
  @override
  _ShowBottomSheetState createState() => _ShowBottomSheetState();
}

class _ShowBottomSheetState extends State<ShowBottomSheet> {
  double rate = 0.0;
  String? selectLocations;
  String? category;
  @override
  Widget build(BuildContext context) {
    bool isInPortraitMode =
        MediaQuery.of(context).orientation == Orientation.portrait;
    var height = MediaQuery.of(context).size.height -
        MediaQueryData.fromWindow(window).padding.top;
    BlocProduct bloc = BlocProduct.get(context);
    return Container(
      color: Theme.of(context).backgroundColor,
      height: height,
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${getTranslated(context, 'Locations')}:'),
            SizedBox(height: height * 0.01),
            Container(
              height: isInPortraitMode ? height * 0.1 : height * 0.2,
              child: ListView.builder(
                  itemCount: bloc.locations.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectLocations = bloc.locations[index];
                        });
                      },
                      child: Card(
                        elevation: 2,
                        color: selectLocations != null &&
                                selectLocations == bloc.locations[index]
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.background,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              bloc.locations[index],
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            SizedBox(height: height * 0.01),
            Text('${getTranslated(context, 'Categories')}:'),
            SizedBox(height: height * 0.01),
            Container(
              height: isInPortraitMode ? height * 0.1 : height * 0.2,
              child: ListView.builder(
                  itemCount: categoriesString.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          category = categoriesString[index];
                        });
                      },
                      child: Card(
                        color: category != null &&
                                category == categoriesString[index]
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.background,
                        child: SvgPicture.asset(
                          categoriesImage[index],
                          height:
                              isInPortraitMode ? height * 0.1 : height * 0.2,
                          fit: BoxFit.fill,
                          // width: 10,
                        ),
                      ),
                    );
                  }),
            ),
            SizedBox(height: height * 0.01),
            ListTile(
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  Text('${getTranslated(context, 'Rating')}:'),
                ],
              ),
              trailing: Text(
                '$rate - 5.0',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Slider(
              min: 0,
              max: 5,
              value: rate,
              divisions: 10,
              onChanged: (val) {
                setState(() {
                  rate = val;
                });
              },
            ),
            SizedBox(height: height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ContainerBn(
                  title: getTranslated(context, 'Apply'),
                  color: Theme.of(context).colorScheme.surface,
                  onPress: () {
                    bloc.filterStores(
                        category: category,
                        rate: rate,
                        locality: selectLocations);
                    Navigator.pop(context);
                  },
                ),
                ContainerBn(
                  title: getTranslated(context, 'Cancel'),
                  color: Theme.of(context).colorScheme.surface,
                  onPress: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
