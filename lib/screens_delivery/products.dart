import 'package:delivery_app/bloc/Products/bloc_product.dart';
import 'package:delivery_app/componants/Btn.dart';
import 'package:delivery_app/componants/appbar_custom.dart';
import 'package:delivery_app/componants/no_internet.dart';
import 'package:delivery_app/componants/snack_bar.dart';
import 'package:delivery_app/helper/Session.dart';

import 'package:delivery_app/screens_delivery/new_product.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//ignore: must_be_immutable
class Products extends StatelessWidget {
  static const String id = 'products';
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    BlocProduct bloc = BlocProduct.get(context);
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildAppbar(
              title: getTranslated(context, 'Products'),
              onTap: () => Navigator.pop(context),
            ),
            BlocBuilder<BlocProduct, DataState>(
              builder: (context, state) {
                if (state is DataLoaded) {
                  return Text(
                    ' ${getTranslated(context, 'You Have')} ${bloc.userStore!.value.storeData!.products!.length} ${getTranslated(context, 'Products')}',
                    style: Theme.of(context).textTheme.headline3,
                  );
                }

                return const SizedBox();
              },
            ),
            SizedBox(height: height * 0.01),
            BlocBuilder<BlocProduct, DataState>(
              builder: (context, state) {
                if (state is NoNetworkAvail) {
                  return Expanded(child: noInternet(context));
                }
                if (state is DataLoading) {
                  return Expanded(child: getProgress());
                } else if (state is DataLoaded) {
                  return Expanded(
                    child: GridView.builder(
                      itemCount:
                          bloc.userStore!.value.storeData!.products!.length,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: width > 400 ? 3 : 2,
                        // crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                      ),
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.only(
                              left: 30, right: 30, top: 30),
                          child: LayoutBuilder(
                            builder: (_, constraints) => Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).shadowColor,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                      )),
                                ),
                                Positioned(
                                  child: Hero(
                                    child: FadeInImage(
                                      placeholder:
                                          AssetImage('assets/images/item.png'),
                                      image: NetworkImage(bloc.userStore!.value
                                          .storeData!.products![index].image),
                                      fit: BoxFit.fill,
                                      width: constraints.maxWidth,
                                      height: constraints.maxHeight * 0.62,
                                    ),
                                    tag: bloc.userStore!.value.storeData!
                                        .products![index].id!,
                                  ),
                                  top: -25,
                                  left: 0,
                                  right: 0,
                                ),
                                Positioned(
                                  child: Column(
                                    children: [
                                      Text(
                                        bloc.userStore!.value.storeData!
                                            .products![index].name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                      ),
                                      Text(
                                        '\$${bloc.userStore!.value.storeData!.products![index].price}',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      OutlinedButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, NewProduct.id,
                                              arguments: bloc.userStore!.value
                                                  .storeData!.products![index]);
                                        },
                                        child: Text(
                                          getTranslated(context, 'Edit'),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5,
                                        ),
                                        style: ButtonStyle(
                                          side: MaterialStateProperty.all<
                                              BorderSide>(
                                            BorderSide(
                                              color: Colors.black,
                                              width: 1.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else if (state is RemoveProductError) {
                  setSnackbar(state.msg, context);
                }
                return Expanded(child: getProgress());
              },
            ),
            Center(
              child: Btn(
                title: getTranslated(context, 'Add Product'),
                onPressed: () {
                  Navigator.pushNamed(context, NewProduct.id);
                },
                color: Theme.of(context).buttonColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
