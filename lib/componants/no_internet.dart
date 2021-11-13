import 'package:delivery_app/helper/Session.dart';
import 'package:flutter/material.dart';

Widget noInternet(BuildContext context) {
  return Center(
    child: SingleChildScrollView(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        noIntImage(),
        noIntText(context),
        noIntDec(context),
        // AppBtn(
        //   title: getTranslated(context, 'TRY_AGAIN'),
        //   btnAnim: buttonSqueezeanimation,
        //   btnCntrl: buttonController,
        //   onBtnSelected: () async {
        //     _playAnimation();
        //
        //     Future.delayed(Duration(seconds: 2)).then((_) async {
        //       _isNetworkAvail = await isNetworkAvailable();
        //       if (_isNetworkAvail) {
        //
        //       } else {
        //         await buttonController.reverse();
        //         if (mounted) setState(() {});
        //       }
        //     });
        //   },
        // )
      ]),
    ),
  );
}
