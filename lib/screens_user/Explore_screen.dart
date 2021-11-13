import 'package:delivery_app/bloc/Products/bloc_product.dart';
import 'package:delivery_app/bloc/controlApp/ControlAppBloc.dart';
import 'package:delivery_app/bloc/controlApp/controlAppEvent.dart';
import 'package:delivery_app/bloc/controlApp/controlAppState.dart';
import 'package:delivery_app/componants/grid_view_products.dart';
import 'package:delivery_app/componants/list_view_products.dart';
import 'package:delivery_app/componants/no_internet.dart';
import 'package:delivery_app/helper/Session.dart';
import 'package:delivery_app/helper/Strings.dart';

import 'package:delivery_app/models/product.dart';
import 'package:delivery_app/screens_user/search_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../componants/appbar_custom.dart';

class ExploreScreen extends StatelessWidget {
  static const String id = 'Explore';

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    bool isLand = MediaQuery.of(context).orientation == Orientation.portrait;
    String? category = ModalRoute.of(context)!.settings.arguments as String?;
    BlocProduct bloc = BlocProduct.get(context);
    ControlAppBloc appBloc = ControlAppBloc.get(context);
    if (category != null) {
      bloc.cat = category;
    }
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              BuildAppbar(
                onTap: () {
                  Navigator.pop(context);
                },
                title: getTranslated(context, 'Explore'),
              ),
              SizedBox(height: height * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, SearchProducts.id);
                    },
                    child: Container(
                      width: width * 0.75,
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(getTranslated(context, 'Search')),
                          const Icon(Icons.search),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      appBloc.add(ChangeGridToList());
                    },
                    icon: BlocBuilder<ControlAppBloc, ControlAppState>(
                      builder: (context, state) {
                        return Icon(
                          appBloc.changeViews == ChangeViews.Gird
                              ? Icons.grid_view
                              : Icons.view_list,
                        );
                      },
                    ),
                  ),
                ],
              ),
              Container(
                height: isLand ? height * 0.14 : height * 0.2,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoriesString.length,
                  itemBuilder: (ctx, index) {
                    return GestureDetector(
                      child: BlocBuilder<BlocProduct, DataState>(
                        builder: (context, state) {
                          return Card(
                            color: categoriesString[index] == bloc.cat
                                ? Theme.of(context).focusColor
                                : Theme.of(context).backgroundColor,
                            elevation: 3,
                            shadowColor: Colors.black54,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                width: width * 0.14,
                                child: SvgPicture.asset(
                                  categoriesImage[index],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      onTap: () {
                        bloc.add(GetProductFilter(categoriesString[index]));
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: height * 0.01),
              BlocConsumer<BlocProduct, DataState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is DataLoaded) {
                    List<Product> products = [];
                    state.usersStore!.forEach((v) {
                      if (v.value.category == bloc.cat)
                        products.addAll(v.value.storeData!.products!.toList());
                      else if (bloc.cat == ALL)
                        products.addAll(v.value.storeData!.products!.toList());
                    });
                    products.shuffle();
                    return BlocBuilder<ControlAppBloc, ControlAppState>(
                      builder: (context, state) {
                        if (appBloc.changeViews == ChangeViews.Gird)
                          return GridViewProducts(products: products);
                        else
                          return ListViewProduct(products: products);
                      },
                    );
                  }
                  if (state is DataError) {
                    return Text(state.msg);
                  }
                  if (state is NoNetworkAvail) {
                    return noInternet(context);
                  }
                  return Container(
                    height: height * 0.3,
                    child: getProgress(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
