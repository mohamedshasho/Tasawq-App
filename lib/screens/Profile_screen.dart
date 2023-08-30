import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery_app/bloc/Products/bloc_product.dart';
import 'package:delivery_app/componants/ContainerBn.dart';
import 'package:delivery_app/constants.dart';
import 'package:delivery_app/helper/Session.dart';
import 'package:delivery_app/wedgets/select_image_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

//ignore: must_be_immutable
class ProfileScreen extends StatelessWidget {
  static const String id = 'profileScreen';
  PickedFile? _pickedFile;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    bool isInPortraitMode =
        MediaQuery.of(context).orientation == Orientation.portrait;
    BlocProduct bloc = BlocProduct.get(context);
    return SafeArea(
      child: Scaffold(
        body: CustomPaint(
          painter: BackgroundCustomColor(context),
          child: Column(
            children: [
              Center(
                child: Container(
                  height: isInPortraitMode ? height * 0.15 : height * 0.25,
                  width: isInPortraitMode ? width * 0.25 : width * 0.15,
                  child: LayoutBuilder(
                    builder: (ctx, size) {
                      final rad = (size.maxHeight / 4 + size.maxWidth / 4);
                      return Stack(
                        alignment: Alignment.topRight,
                        children: [
                          BlocBuilder<BlocProduct, DataState>(
                            builder: (context, state) {
                              if (state is DataLoaded) {
                                if (bloc.userStore != null &&
                                    bloc.userStore!.value.image != null)
                                  return CircleAvatar(
                                    radius: rad,
                                    foregroundColor: Colors.transparent,
                                    backgroundColor:
                                        Theme.of(context).shadowColor,
                                    child: CachedNetworkImage(
                                      imageUrl: bloc.userStore!.value.image!,
                                      placeholder: (context, url) =>
                                          CupertinoActivityIndicator(),
                                      imageBuilder: (context, image) =>
                                          CircleAvatar(
                                        backgroundImage: image,
                                        radius: rad * 0.9,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          CircleAvatar(
                                        backgroundImage: AssetImage(
                                            'assets/images/user.png'),
                                        radius: rad,
                                      ),
                                    ),
                                  );
                              }
                              return CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/images/user.png'),
                                radius: rad,
                              );
                            },
                          ),
                          GestureDetector(
                            onTap: () async {
                              await showGeneralDialog(
                                  context: context,
                                  transitionDuration:
                                      Duration(milliseconds: 300),
                                  barrierDismissible: true,
                                  barrierLabel:
                                      MaterialLocalizations.of(context)
                                          .modalBarrierDismissLabel,
                                  pageBuilder: (ctx, a1, a2) {
                                    return SelectImageDialog();
                                  }).then((value) {
                                if (value != null) {
                                  _pickedFile = value as PickedFile?;
                                  BlocProduct.get(context).add(
                                      AddProfileImage(File(_pickedFile!.path)));
                                }
                              });
                            },
                            child: Transform.rotate(
                                angle: 180 * pi / 120,
                                child: Card(
                                  child: Icon(
                                    Icons.edit,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                )),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              BlocBuilder<BlocProduct, DataState>(
                builder: (context, state) {
                  if (state is DataLoaded) {
                    return Text(bloc.userStore!.value.username!,
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                              color: Colors.green[800],
                            ));
                  }
                  return Text(getTranslated(context, 'User'));
                },
              ),
              SizedBox(height: height * 0.05),
              BlocBuilder<BlocProduct, DataState>(
                builder: (context, state) {
                  if (state is DataLoaded) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            bloc.userStore!.value.storeData != null &&
                                    bloc.userStore!.value.storeData!
                                            .followers !=
                                        null
                                ? Text(
                                    '${bloc.userStore!.value.storeData!.followers!.length}')
                                : Text('0'),
                            SizedBox(height: height * 0.01),
                            ContainerBn(
                              title: getTranslated(context, 'Followers'),
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            bloc.userStore!.value.following != null
                                ? Text(
                                    '${bloc.userStore!.value.following!.length}')
                                : Text('0'),
                            SizedBox(height: height * 0.01),
                            ContainerBn(
                              title: getTranslated(context, 'Stores Following'),
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ],
                        ),
                      ],
                    );
                  } //todo مؤقتا لبين ما ضيف داتا بيس داخيلة
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
