import 'package:delivery_app/bloc/Products/bloc_product.dart';
import 'package:delivery_app/componants/appbar_custom.dart';
import 'package:delivery_app/componants/categories_view.dart';
import 'package:delivery_app/constants.dart';
import 'package:delivery_app/helper/Session.dart';
import 'package:delivery_app/models/store.dart';
import 'package:delivery_app/screens_delivery/categories.dart';
import 'package:delivery_app/screens_delivery/products.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeDelivery extends StatelessWidget {
  static const String id = 'HomeDelivery';

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    bool isInPortraitMode =
        MediaQuery.of(context).orientation == Orientation.portrait;
    BlocProduct bloc = BlocProduct.get(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BuildAppbar(
                title: getTranslated(context, 'DashBoard'),
                onTap: () => Navigator.pop(context),
              ),
              SizedBox(height: height * 0.01),
              SizedBox(height: height * 0.02),
              Row(
                children: [
                  Container(
                    width: width * 0.01,
                    height: height * 0.03,
                    color: Colors.green,
                  ),
                  Text(
                    getTranslated(context, 'Products'),
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, Products.id);
                    },
                    child: Text(
                      getTranslated(context, 'Show All'),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.01),
              Container(
                height: isInPortraitMode ? height * 0.2 : height * 0.3,
                width: width,
                color: Theme.of(context).backgroundColor,
                child: BlocBuilder<BlocProduct, DataState>(
                  builder: (context, state) {
                    if (state is DataLoading)
                      return SpinKitFadingCube(
                        color: secondaryColor,
                      );
                    else if (state is DataLoaded) {
                      Person userStore = state.usersStore!.firstWhere((v) =>
                          FirebaseAuth.instance.currentUser!.uid == v.id);
                      return LayoutBuilder(
                        builder: (ctx, cons) => Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                                '${userStore.value.storeData!.products!.length} ${getTranslated(context, 'Product')}'),
                          ],
                        ),
                      );
                    } else if (state is DataError) return Text(state.msg);
                    return SpinKitFadingCube(
                      color: secondaryColor,
                    );
                  },
                ),
              ),
              SizedBox(height: height * 0.01),
              Row(
                children: [
                  Container(
                    width: width * 0.01,
                    height: height * 0.03,
                    color: Colors.green,
                  ),
                  Text(
                    getTranslated(context, 'Categories'),
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, Categories.id);
                    },
                    child: Text(
                      getTranslated(context, 'Show All'),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ],
              ),
              BlocBuilder<BlocProduct, DataState>(
                builder: (context, state) {
                  if (state is DataLoading) {
                    return getProgress();
                  }
                  if (state is DataLoaded) {
                    return CategoriesView(
                        height: isInPortraitMode ? height * 0.3 : height * 0.6,
                        categories:
                            bloc.userStore!.value.storeData!.categories!,
                        axis: Axis.horizontal);
                  }
                  return getProgress();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
