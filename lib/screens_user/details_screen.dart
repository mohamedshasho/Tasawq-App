import 'package:delivery_app/bloc/Products/bloc_product.dart';
import 'package:delivery_app/componants/Btn.dart';
import 'package:delivery_app/componants/appbar_custom.dart';
import 'package:delivery_app/helper/Session.dart';
import 'package:delivery_app/models/product.dart';
import 'package:delivery_app/models/store.dart';
import 'package:delivery_app/screens_delivery/store_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailsScreen extends StatelessWidget {
  static const String id = 'details';
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    Product? product = ModalRoute.of(context)!.settings.arguments as Product?;
    Person? store = BlocProduct.get(context).getStoreOwner(product!.id!);
    bool isPortraitMode =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding:
              const EdgeInsets.only(top: 8, left: 12, right: 12, bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BuildAppbar(
                title: getTranslated(context, 'Details'),
                onTap: () => Navigator.pop(context),
              ),
              Container(
                // width: double.infinity,
                height: isPortraitMode ? height * 0.6 : height * 0.8,
                decoration: BoxDecoration(
                  color: Theme.of(context).focusColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      child: Text(
                        product.name,
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                              color: Colors.lightGreenAccent.shade700,
                            ),
                      ),
                      top: 0,
                      left: 10,
                    ),
                    BlocConsumer<BlocProduct, DataState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        return Positioned(
                          child: IconButton(
                            icon: Icon(
                              product.favorite!.val
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.redAccent,
                            ),
                            onPressed: () {
                              if (!checkUserNull(context)) {
                                if (!product.favorite!.val)
                                  BlocProduct.get(context)
                                      .add(AddToFavorite(product));
                                else
                                  BlocProduct.get(context)
                                      .add(DeleteToFavorite(product));
                              }
                            },
                          ),
                          top: 10,
                          right: 10,
                        );
                      },
                    ),
                    Positioned(
                      child: Container(
                        height: isPortraitMode ? height * 0.15 : height * 0.25,
                        margin: EdgeInsets.only(
                          left: width * 0.19,
                          right: width * 0.19,
                        ),
                        clipBehavior: Clip.none,
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.bottomCenter,
                        decoration: BoxDecoration(
                          color: Theme.of(context).shadowColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 8),
                                  child: Text(
                                    '\$${product.price}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3
                                        ?.copyWith(color: Colors.white),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline2!
                                        .color,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      bottom: 0,
                      left: 0,
                      right: 0,
                    ),
                    Positioned(
                      top: isPortraitMode ? height * 0.15 : height * 0.28,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Container(
                              transform:
                                  Matrix4.translationValues(0.0, -40.0, 0.0),
                              child: Hero(
                                tag: product.id!,
                                child: InteractiveViewer(
                                  child: Image.network(
                                    product.image,
                                    fit: BoxFit.fill,
                                    height: height * 0.4,
                                    width: width,
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text(getTranslated(context, 'Category Type')),
                subtitle: Text(product.categoryName),
                leading: const Icon(Icons.store),
                trailing: Text(
                    '${getTranslated(context, 'Store')}\n${store!.value.username}'),
              ),
              product.location != null
                  ? ListTile(
                      leading: Icon(Icons.location_on_rounded),
                      title: Text(product.location!),
                    )
                  : const SizedBox(),
              Text(
                '${getTranslated(context, 'Description')}:',
                style: Theme.of(context).textTheme.headline3,
              ),
              Text(
                product.description,
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      height: 1.5,
                    ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Center(
                child: Btn(
                  color: Theme.of(context).colorScheme.surface,
                  title: getTranslated(context, 'Show Store'),
                  onPressed: () {
                    Navigator.pushNamed(context, StoreDetails.id,
                        arguments: store);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
