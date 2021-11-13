import 'package:delivery_app/bloc/Products/bloc_product.dart';
import 'package:delivery_app/componants/Btn.dart';
import 'package:delivery_app/componants/appbar_custom.dart';
import 'package:delivery_app/componants/gird_view_stores.dart';
import 'package:delivery_app/componants/no_internet.dart';
import 'package:delivery_app/constants.dart';
import 'package:delivery_app/helper/Session.dart';

import 'package:delivery_app/screens_user/Search_stores.dart';
import 'package:delivery_app/screens_user/Stores_maps.dart';
import 'package:delivery_app/wedgets/show_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoresViews extends StatelessWidget {
  static const String id = 'storesViews';
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    BlocProduct bloc = BlocProduct.get(context);
    return SafeArea(
        child: Scaffold(
      body: RefreshIndicator(
        backgroundColor: Theme.of(context).backgroundColor.withOpacity(0.5),
        color: secondaryColor,
        onRefresh: () async {
          bloc.add(RefreshProducts());
        },
        child: Column(
          children: [
            BuildAppbar(
              title: getTranslated(context, 'Stores'),
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, SearchStore.id);
                  },
                  child: Container(
                    width: width * 0.6,
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
                        const Icon(
                          Icons.search,
                        ),
                      ],
                    ),
                  ),
                ),
                IconBn(
                  iconData: Icons.filter_list,
                  onPress: () {
                    _showBottomSheet(context, height);
                  },
                ),
                IconBn(
                  iconData: Icons.map,
                  onPress: () {
                    if (!checkUserNull(context))
                      Navigator.pushNamed(context, MapStores.id);
                  },
                ),
              ],
            ),
            BlocBuilder<BlocProduct, DataState>(
              builder: (context, state) {
                if (state is DataLoaded) {
                  state.usersStore!.shuffle();
                  return Expanded(
                    child: GridViewStores(
                      stores: state.usersStore!,
                    ),
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
                  child: Center(
                    child: getProgress(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ));
  }
}

void _showBottomSheet(BuildContext context, double height) {
  showModalBottomSheet<void>(
    context: context,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
      topLeft: Radius.circular(15),
      topRight: Radius.circular(15),
    )),
    backgroundColor: Theme.of(context).backgroundColor,
    elevation: 5,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return ShowBottomSheet();
    },
  );
}
