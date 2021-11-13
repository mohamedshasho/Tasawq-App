import 'package:delivery_app/bloc/Products/bloc_product.dart';
import 'package:delivery_app/componants/snack_bar.dart';
import 'package:delivery_app/helper/Session.dart';
import 'package:delivery_app/models/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

//ignore: must_be_immutable
class RatingDialog extends StatelessWidget {
  final Person userStore;
  RatingDialog(this.userStore);

  double? _rate;
  @override
  Widget build(BuildContext context) {
    BlocProduct user = BlocProduct.get(context);
    if (userStore.value.storeData!.rating != null) {
      for (var s in userStore.value.storeData!.rating!.entries) {
        if (user.userStore!.id == s.key) {
          _rate = double.parse(s.value.toString());
          break;
        }
      }
    }
    return AlertDialog(
      title: Text(_rate == null
          ? getTranslated(context, 'Rate')
          : getTranslated(context, 'your rating')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Divider(),
          RatingBar.builder(
            initialRating: _rate != null ? _rate! : 0.0,
            minRating: 1,
            ignoreGestures: _rate != null ? true : false,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              _rate = rating;
            },
          ),
          const SizedBox(height: 8),
          InkWell(
            child: Text(_rate != null
                ? getTranslated(context, 'Cancel')
                : getTranslated(context, 'OK')),
            onTap: () {
              if (_rate != null) {
                BlocProduct.get(context)
                    .add(RatingStoreEvent(userStore, _rate!));
                setSnackbar(
                    getTranslated(context, 'Thanks for rating.'), context);
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
