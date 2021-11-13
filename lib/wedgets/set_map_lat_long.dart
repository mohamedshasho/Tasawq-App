import 'package:delivery_app/bloc/Products/bloc_product.dart';
import 'package:delivery_app/componants/Btn.dart';
import 'package:delivery_app/helper/Maps_service.dart';
import 'package:delivery_app/helper/Session.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SetMapLatLong extends StatefulWidget {
  @override
  _SetMapLatLongState createState() => _SetMapLatLongState();
}

class _SetMapLatLongState extends State<SetMapLatLong> {
  String? lat;
  String? long;
  late BlocProduct bloc;
  Set<Marker> mark = Set<Marker>();
  LatLng? _latLng;

  @override
  void didChangeDependencies() {
    bloc = BlocProduct.get(context);
    super.didChangeDependencies();

    if (GoogleMapService.foundMarker(bloc.userStore!.id))
      mark.add(GoogleMapService.getMyMarker(bloc.userStore!.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: GoogleMapService().getMyPosition(
                bloc.userStore!.value.locationUser!.lat!,
                bloc.userStore!.value.locationUser!.long!),
            markers: mark,
            zoomControlsEnabled: false,
            onTap: (latLong) {
              _latLng = latLong;
              mark.clear();
              mark.add(Marker(
                markerId: MarkerId(bloc.userStore!.id),
                icon: BitmapDescriptor.defaultMarker,
                position: latLong,
              ));
              setState(() {});
            },
          ),
          _latLng != null
              ? Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Btn(
                    title: getTranslated(context, 'Save'),
                    color: Theme.of(context).buttonColor,
                    onPressed: () {
                      bloc.add(SetLatLong(_latLng!));
                      Navigator.pop(context);
                    },
                  ))
              : const SizedBox(),
        ],
      ),
    );
  }
}
