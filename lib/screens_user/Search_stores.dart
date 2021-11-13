import 'package:delivery_app/bloc/Products/bloc_product.dart';
import 'package:delivery_app/componants/appbar_custom.dart';
import 'package:delivery_app/componants/gird_view_stores.dart';
import 'package:delivery_app/helper/Session.dart';
import 'package:delivery_app/models/store.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class SearchStore extends StatefulWidget {
  static const String id = 'searchStore';
  @override
  _SearchStoreState createState() => _SearchStoreState();
}

class _SearchStoreState extends State<SearchStore> {
  TextEditingController textEditingController = TextEditingController();
  List<Person>? stores;
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
                    stores = bloc.searchStore(val);
                  });
                  print(stores!.length);
                },
              ),
              stores != null
                  ? Expanded(child: GridViewStores(stores: stores!))
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
