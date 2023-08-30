import 'package:delivery_app/bloc/Products/bloc_product.dart';
import 'package:delivery_app/componants/Btn.dart';
import 'package:delivery_app/componants/appbar_custom.dart';
import 'package:delivery_app/componants/categories_view.dart';
import 'package:delivery_app/componants/no_internet.dart';
import 'package:delivery_app/componants/snack_bar.dart';
import 'package:delivery_app/helper/Session.dart';
import 'package:delivery_app/screens_delivery/new_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Categories extends StatelessWidget {
  static const String id = 'categories';
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    BlocProduct bloc = BlocProduct.get(context);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            BuildAppbar(
              title: getTranslated(context, 'Categories'),
              onTap: () => Navigator.pop(context),
            ),
            BlocBuilder<BlocProduct, DataState>(
              builder: (context, state) {
                if (state is NoNetworkAvail) {
                  return Expanded(child: noInternet(context));
                }
                if (state is DataLoading) {
                  return Expanded(child: getProgress());
                }
                if (state is DataLoaded) {
                  return CategoriesView(
                      height: height * 0.7,
                      categories: bloc.userStore!.value.storeData!.categories!,
                      axis: Axis.vertical);
                }
                if (state is DataError) {
                  SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
                    setSnackbar(state.msg, context);
                  });
                }
                return Expanded(child: getProgress());
              },
            ),
            const Spacer(),
            Btn(
              title: getTranslated(context, 'Add Category'),
              onPressed: () {
                Navigator.pushNamed(context, NewCategory.id);
              },
              color: Theme.of(context).colorScheme.surface,
            ),
          ],
        ),
      ),
    );
  }
}
