import 'package:delivery_app/bloc/Auth/auth_bloc.dart';
import 'package:delivery_app/bloc/Products/bloc_product.dart';
import 'package:delivery_app/componants/ContainerBn.dart';
import 'package:delivery_app/componants/grid_view_products.dart';
import 'package:delivery_app/helper/Maps_service.dart';
import 'package:delivery_app/helper/Session.dart';
import 'package:delivery_app/models/store.dart';
import 'package:delivery_app/screens/chat.dart';
import 'package:delivery_app/wedgets/Dialog_rating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../constants.dart';

class StoreDetails extends StatelessWidget {
  static const String id = 'storeDetails';
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    Person store = ModalRoute.of(context)!.settings.arguments as Person;
    BlocProduct bloc = BlocProduct.get(context);
    AuthBloc authBloc = AuthBloc.get(context);
    bool isPortraitMode =
        MediaQuery.of(context).orientation == Orientation.portrait;
    Set<Marker> mark = Set<Marker>();
    if (GoogleMapService.foundMarker(store.id))
      mark.add(GoogleMapService.getMyMarker(store.id));
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            Directionality(
              textDirection: TextDirection.ltr,
              child: SliverAppBar(
                expandedHeight: isPortraitMode ? height * 0.4 : height * 0.6,
                title: Text(
                  ' ${store.value.username}',
                  style: Theme.of(context).textTheme.headline4,
                ),
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 2,
                    color: secondaryColor,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(4),
                      onTap: () => Navigator.pop(context),
                      child:
                          Icon(Icons.keyboard_arrow_left, color: Colors.black),
                    ),
                  ),
                ),
                backgroundColor: kColorBtmBarIcon,
                flexibleSpace: FlexibleSpaceBar(
                  background: InteractiveViewer(
                    child: store.value.image != null
                        ? Hero(
                            tag: store.id,
                            child: FadeInImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                store.value.image!,
                              ),
                              placeholder:
                                  AssetImage('assets/images/store.png'),
                            ),
                          )
                        : Image.asset(
                            'assets/images/store.png',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  ListTile(
                    title: Text(
                      getTranslated(context, store.value.category!),
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    leading: Text(
                      '${getTranslated(context, 'Category')}:',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                  !authBloc.isUserSignIn() || store.id != bloc.userStore!.id
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            BlocBuilder<BlocProduct, DataState>(
                              builder: (context, state) {
                                return ContainerBn(
                                  title: store.value.storeData!.isFollow.val
                                      ? getTranslated(context, 'Following')
                                      : getTranslated(context, 'Follow'),
                                  color: !store.value.storeData!.isFollow.val
                                      ? kItemColor
                                      : primary,
                                  onPress: () {
                                    if (!checkUserNull(context)) {
                                      if (!store.value.storeData!.isFollow.val)
                                        bloc.add(FollowStore(store));
                                      else
                                        bloc.add(UnFollowStore(store));
                                    }
                                  },
                                );
                              },
                            ),
                            ContainerBn(
                              title: getTranslated(context, 'Message'),
                              onPress: () {
                                if (!checkUserNull(context))
                                  Navigator.pushNamed(context, SendChat.id,
                                      arguments: bloc.getUser(store.id));
                              },
                            ),
                          ],
                        )
                      : const SizedBox(),
                  ListTile(
                    leading: !authBloc.isUserSignIn() ||
                            store.id != bloc.userStore!.id
                        ? InkWell(
                            child: Text(
                              getTranslated(context, 'Rating'),
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            onTap: () {
                              if (!checkUserNull(context))
                                showDialog(
                                    context: context,
                                    builder: (ctx) {
                                      return RatingDialog(store);
                                    });
                            },
                          )
                        : null,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${store.value.storeData!.rate}',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  ListTile(
                    leading: Text(
                      getTranslated(context, 'Address'),
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    title: store.value.locationUser != null &&
                            store.value.locationUser!.locality != null
                        ? Text(
                            store.value.locationUser!.locality! +
                                ', ' +
                                store.value.locationUser!.subLocality!,
                            style: Theme.of(context).textTheme.headline5,
                          )
                        : const SizedBox(),
                    trailing: const Icon(Icons.location_on_rounded),
                  ),
                  GoogleMapService.foundMarker(store.id)
                      ? Container(
                          height: isPortraitMode ? height * 0.25 : height * 0.4,
                          child: GoogleMap(
                            initialCameraPosition: GoogleMapService()
                                .getMyPosition(store.value.locationUser!.lat!,
                                    store.value.locationUser!.long!),
                            zoomControlsEnabled: false,
                            markers: mark,
                          ),
                        )
                      : const SizedBox(),
                  Text(
                    '${store.value.storeData!.categories!.length} ${getTranslated(context, 'Categories')}',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Container(
                    height: isPortraitMode ? height * 0.3 : height * 0.45,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,
                      ),
                      scrollDirection: Axis.horizontal,
                      itemCount: store.value.storeData!.categories!.length,
                      itemBuilder: (_, index) {
                        return Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Image.network(
                                  store.value.storeData!.categories![index]
                                      .image,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Text(
                                store.value.storeData!.categories![index].name,
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Text(
                    '${store.value.storeData!.products!.length} ${getTranslated(context, 'Products')}',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  GridViewProducts(
                    products: store.value.storeData!.products!,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
