import 'dart:async';
import 'dart:ui';

import 'package:delivery_app/bloc/Products/bloc_product.dart';
import 'package:delivery_app/helper/Maps_service.dart';
import 'package:delivery_app/helper/Strings.dart';
import 'package:delivery_app/helper/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../constants.dart';

class MapStores extends StatefulWidget {
  static const String id = 'mapStores';
  @override
  State<MapStores> createState() => MapStoresState();
}

class MapStoresState extends State<MapStores> {
  String? category = 'All';
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapService _googleMapService = GoogleMapService();
  late Set<Marker> marker;

  LocationData? _locationData;
  late BlocProduct bloc;

  @override
  void initState() {
    super.initState();
    marker = GoogleMapService.marker;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _locationData = LocationHelper.getLocationData();

    bloc = BlocProduct.get(context);
  }

  @override
  Widget build(BuildContext context) {
    bool isInPortraitMode =
        MediaQuery.of(context).orientation == Orientation.portrait;
    var height = MediaQuery.of(context).size.height -
        MediaQueryData.fromWindow(window).padding.top;

    final CameraPosition _myPosition = CameraPosition(
      target: LatLng(_locationData!.latitude!, _locationData!.longitude!),
      zoom: 14.151926040649414,
    );

    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final GoogleMapController controller = await _controller.future;
            controller
                .animateCamera(CameraUpdate.newCameraPosition(_myPosition));
          },
          child: Icon(
            Icons.location_searching,
            color: Theme.of(context).colorScheme.secondary,
          ),
          elevation: 5,
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
        body: StatefulBuilder(
          builder: (ctx, newSetState) {
            return Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: _googleMapService.getMyPosition(
                      _locationData!.latitude!, _locationData!.longitude!),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  markers: marker,
                  circles: _googleMapService.addCircle(
                      _locationData!.latitude!, _locationData!.longitude!),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                ),
                Positioned(
                  top: 10,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: isInPortraitMode ? height * 0.1 : height * 0.2,
                    child: ListView.builder(
                        itemCount: categoriesString.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, index) {
                          return GestureDetector(
                            onTap: () async {
                              category = categoriesString[index];
                              marker = await bloc.filterMarker(category!);
                              newSetState(() {});
                            },
                            child: Card(
                              color: category != null &&
                                      category == categoriesString[index]
                                  ? secondaryColor
                                  : Colors.white,
                              child: SvgPicture.asset(
                                categoriesImage[index],
                                height: isInPortraitMode
                                    ? height * 0.1
                                    : height * 0.2,
                                fit: BoxFit.fill,
                                // width: 10,
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
