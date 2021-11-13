import 'dart:io';

import 'package:delivery_app/bloc/Products/bloc_product.dart';
import 'package:delivery_app/bloc/controlApp/ControlAppBloc.dart';
import 'package:delivery_app/bloc/controlApp/controlAppEvent.dart';
import 'package:delivery_app/bloc/controlApp/controlAppState.dart';
import 'package:delivery_app/componants/Btn.dart';
import 'package:delivery_app/componants/appbar_custom.dart';
import 'package:delivery_app/componants/snack_bar.dart';
import 'package:delivery_app/constants.dart';
import 'package:delivery_app/helper/Session.dart';
import 'package:delivery_app/models/categories.dart';
import 'package:delivery_app/models/product.dart';
import 'package:delivery_app/wedgets/select_image_dialog.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

//ignore: must_be_immutable
class NewProduct extends StatelessWidget {
  static const String id = 'newProduct';
  String _name = '', _price = '', _description = '';
  String? _image;
  PickedFile? pickedFile;
  String? categoryName;
  var foundCategory;
  @override
  Widget build(BuildContext context) {
    Product? product = ModalRoute.of(context)!.settings.arguments as Product?;
    var height = MediaQuery.of(context).size.height;
    BlocProduct blocProduct = BlocProduct.get(context);
    List<Category> categories =
        blocProduct.userStore!.value.storeData!.categories!;
    ControlAppBloc bloc = ControlAppBloc.get(context);
    // selectCategory = categories[0].name;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BuildAppbar(
                title: getTranslated(context, 'Add Product'),
                onTap: () => Navigator.pop(context),
              ),
              product != null
                  ? Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Hero(
                          tag: product.id!,
                          child: Image.network(
                            product.image,
                            fit: BoxFit.fill,
                            width: double.infinity,
                            height: height * 0.4,
                          ),
                        ),
                        IconButton(
                            onPressed: () async {
                              pickedFile = await showGeneralDialog(
                                  transitionDuration:
                                      Duration(milliseconds: 300),
                                  barrierDismissible: true,
                                  barrierLabel:
                                      MaterialLocalizations.of(context)
                                          .modalBarrierDismissLabel,
                                  context: context,
                                  pageBuilder: (ctx, ani1, ani2) {
                                    return SelectImageDialog();
                                  });
                              if (pickedFile != null) {
                                BlocProduct.get(context).add(EditImage(
                                    newFile: File(pickedFile!.path),
                                    product: product));
                                Navigator.pop(context);
                              }
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Theme.of(context).accentColor,
                            )),
                      ],
                    )
                  : BlocBuilder<BlocProduct, DataState>(
                      builder: (context, state) {
                        if (state is ImageLoading) {
                          return getProgress();
                        }
                        if (state is ImageLoaded) {
                          _image = state.url;
                          return Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Image.network(
                                state.url,
                                width: double.infinity,
                                height: height * 0.4,
                                fit: BoxFit.fill,
                              ),
                              IconButton(
                                onPressed: () async {
                                  pickedFile = await showGeneralDialog(
                                      context: context,
                                      transitionDuration:
                                          Duration(milliseconds: 300),
                                      barrierDismissible: true,
                                      barrierLabel:
                                          MaterialLocalizations.of(context)
                                              .modalBarrierDismissLabel,
                                      pageBuilder: (ctx, a1, a2) {
                                        return SelectImageDialog();
                                      });
                                  if (pickedFile != null) {
                                    BlocProduct.get(context)
                                        .add(DeleteImage(_image!));
                                    BlocProduct.get(context)
                                        .add(AddImage(File(pickedFile!.path)));
                                  }
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                            ],
                          );
                        }
                        if (state is ImageError)
                          setSnackbar(state.msg, context);

                        return Center(
                          child: InkWell(
                            child: SvgPicture.asset('assets/images/camera.svg'),
                            onTap: () async {
                              pickedFile = await showGeneralDialog(
                                  transitionDuration:
                                      Duration(milliseconds: 300),
                                  barrierDismissible: true,
                                  barrierLabel:
                                      MaterialLocalizations.of(context)
                                          .modalBarrierDismissLabel,
                                  context: context,
                                  pageBuilder: (ctx, a1, a2) =>
                                      SelectImageDialog());
                              if (pickedFile != null) {
                                BlocProduct.get(context)
                                    .add(AddImage(File(pickedFile!.path)));
                              }
                            },
                          ),
                        );
                      },
                    ),
              Text(
                ' ${getTranslated(context, 'Name')}:',
                style: Theme.of(context).textTheme.headline5,
              ),
              TextFormField(
                style: Theme.of(context).textTheme.headline5,
                initialValue: product != null ? product.name : null,
                decoration: kTextFieldDecoration,
                onChanged: (val) {
                  product != null ? product.name = val : _name = val;
                },
              ),
              SizedBox(height: height * 0.01),
              Text(
                ' ${getTranslated(context, 'Price')} \$: ',
                style: Theme.of(context).textTheme.headline5,
              ),
              TextFormField(
                style: Theme.of(context).textTheme.headline5,
                initialValue: product != null ? product.price : null,
                decoration: kTextFieldDecoration,
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  product != null ? product.price = val : _price = val;
                },
              ),
              SizedBox(height: height * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getTranslated(context, 'Category Type') + ":",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  BlocBuilder<ControlAppBloc, ControlAppState>(
                      builder: (context, state) {
                    if (product != null) {
                      // when user delete category and search on categories in crash
                      // عندما يحزف عنصر ونجي ليبحث عن عنصر في ليستة لا يجدها يضرب برنامج
                      foundCategory = categories.firstWhereOrNull(
                          (element) => element.name == product.categoryName);
                    }
                    return DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: product != null && foundCategory != null
                            ? product.categoryName
                            : categoryName,
                        items: categories
                            .map((e) => DropdownMenuItem(
                                value: e.name, child: Text(e.name)))
                            .toList(),
                        onChanged: (val) {
                          categoryName = val.toString();
                          if (product != null) {
                            product.categoryName = val.toString();
                          }
                          bloc.add(ChangeCategory(val.toString()));
                        },
                      ),
                    );
                  }),
                ],
              ),
              SizedBox(height: height * 0.01),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Theme.of(context).accentColor,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${blocProduct.userStore!.value.locationUser!.locality}, ${blocProduct.userStore!.value.locationUser!.subLocality}',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
              SizedBox(height: height * 0.01),
              Text(
                ' ${getTranslated(context, 'Description')}:',
                style: Theme.of(context).textTheme.headline5,
              ),
              TextFormField(
                style: Theme.of(context).textTheme.headline5,
                initialValue: product != null ? product.description : null,
                decoration: kTextFieldDecoration,
                maxLines: 10,
                minLines: 3,
                onChanged: (val) {
                  product != null
                      ? product.description = val
                      : _description = val;
                },
              ),
              SizedBox(height: height * 0.02),
              Row(
                mainAxisAlignment: product != null
                    ? MainAxisAlignment.spaceAround
                    : MainAxisAlignment.center,
                children: [
                  Btn(
                    title: product != null
                        ? getTranslated(context, 'Edit')
                        : getTranslated(context, 'ADD'),
                    color: Colors.black54,
                    onPressed: () {
                      if (product == null) {
                        if (_image == null) {
                          setSnackbar(
                              getTranslated(
                                  context, 'Please Added/wait UpLoad Image!'),
                              context);
                          return;
                        }
                        if (categoryName == null) {
                          setSnackbar(
                              getTranslated(context, 'Please Choose Category!'),
                              context);
                          return;
                        }
                        if (_name.trim().isEmpty ||
                            _price.trim().isEmpty ||
                            _description.trim().isEmpty) {
                          setSnackbar(
                              getTranslated(
                                  context, 'Please Enter All Field.!'),
                              context);
                          return;
                        }
                        Product product = Product(
                            price: _price,
                            name: _name,
                            description: _description,
                            image: _image!,
                            categoryName: categoryName!);
                        BlocProduct.get(context).add(AddProduct(product));
                      } else {
                        if (product.name.trim().isEmpty ||
                            product.price.trim().isEmpty ||
                            product.description.trim().isEmpty) {
                          setSnackbar(
                              getTranslated(
                                  context, 'Please Enter All Field.!'),
                              context);
                          return;
                        } else
                          BlocProduct.get(context).add(EditProduct(product));
                      }
                      Navigator.pop(context);
                    },
                  ),
                  product != null
                      ? Btn(
                          title: getTranslated(context, 'Remove'),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text(
                                  getTranslated(
                                      context, 'Are you need delete?'),
                                  style: Theme.of(context).textTheme.headline3,
                                ),
                                content: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          getTranslated(context, 'No'),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5,
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.pop(ctx);
                                      },
                                    ),
                                    InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          getTranslated(context, 'Yes'),
                                          style: TextStyle(
                                              color: Colors.redAccent,
                                              fontFamily: 'Cairo'),
                                        ),
                                      ),
                                      onTap: () async {
                                        BlocProduct.get(context)
                                            .add(RemoveProduct(product));
                                        Navigator.pop(ctx);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          color: Colors.red,
                        )
                      : const SizedBox(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
