import 'package:delivery_app/bloc/Products/bloc_product.dart';
import 'package:delivery_app/componants/appbar_custom.dart';
import 'package:delivery_app/componants/list_view_products.dart';
import 'package:delivery_app/constants.dart';
import 'package:delivery_app/helper/Session.dart';
import 'package:delivery_app/models/product.dart';
import 'package:flutter/material.dart';

class SearchProducts extends StatefulWidget {
  static const String id = 'searchProduct';

  @override
  _SearchProductsState createState() => _SearchProductsState();
}

class _SearchProductsState extends State<SearchProducts> {
  TextEditingController textEditingController = TextEditingController();
  List<Product>? products;
  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BlocProduct bloc = BlocProduct.get(context);

    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                BuildAppbar(
                    title: getTranslated(context, 'Search'),
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      Navigator.pop(context);
                    }),
                const SizedBox(height: 10),
                TextField(
                  controller: textEditingController,
                  decoration: kTextFieldDecoration.copyWith(
                      labelText: getTranslated(context, 'Search something'),
                      labelStyle: Theme.of(context).textTheme.headline5),
                  autofocus: true,
                  onChanged: (val) {
                    setState(() {
                      products = bloc.searchProduct(val);
                    });
                  },
                ),
                products != null
                    ? ListViewProduct(products: products!)
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
