import 'dart:io';

import 'package:delivery_app/bloc/Products/bloc_product.dart';
import 'package:delivery_app/componants/Btn.dart';
import 'package:delivery_app/componants/appbar_custom.dart';
import 'package:delivery_app/componants/snack_bar.dart';
import 'package:delivery_app/helper/Session.dart';
import 'package:delivery_app/models/categories.dart';
import 'package:delivery_app/wedgets/select_image_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../constants.dart';

//ignore: must_be_immutable
class NewCategory extends StatelessWidget {
  static const String id = 'newCategory';
  String? _name, _image;
  PickedFile? pickedFile;
  @override
  Widget build(BuildContext context) {
    BlocProduct bloc = BlocProduct.get(context);
    var height = MediaQuery.of(context).size.height;
    Category? category =
        ModalRoute.of(context)!.settings.arguments as Category?;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BuildAppbar(
                title: getTranslated(context, 'Add Category'),
                onTap: () => Navigator.pop(context),
              ),
              category != null
                  ? Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Hero(
                          tag: category.id!,
                          child: Image.network(category.image),
                        ),
                        IconButton(
                            onPressed: () async {
                              pickedFile = await showDialog(
                                  context: context,
                                  builder: (ctx) => SelectImageDialog());
                              if (pickedFile != null) {
                                bloc.add(EditImageCategory(
                                    category: category,
                                    newFile: File(pickedFile!.path)));
                                Navigator.pop(context);
                              }
                            },
                            icon: const Icon(
                              Icons.edit,
                            )),
                      ],
                    )
                  : BlocBuilder<BlocProduct, DataState>(
                      builder: (ctx, state) {
                        if (state is ImageLoading) {
                          return getProgress();
                        }
                        if (state is ImageLoaded) {
                          _image = state.url;
                          return Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Image.network(_image!),
                              IconButton(
                                  onPressed: () async {
                                    pickedFile = await showDialog(
                                        context: context,
                                        builder: (ctx) => SelectImageDialog());
                                    if (pickedFile != null) {
                                      bloc.add(DeleteImage(_image!));
                                      bloc.add(
                                          AddImage(File(pickedFile!.path)));
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                  )),
                            ],
                          );
                        }
                        if (state is ImageError)
                          setSnackbar(state.msg, context);

                        return Center(
                          child: InkWell(
                            child: SvgPicture.asset('assets/images/camera.svg'),
                            onTap: () async {
                              pickedFile = await showDialog(
                                  context: context,
                                  builder: (ctx) => SelectImageDialog());
                              if (pickedFile != null) {
                                bloc.add(AddImage(File(pickedFile!.path)));
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
              SizedBox(height: height * 0.02),
              TextFormField(
                style: Theme.of(context).textTheme.headline5,
                initialValue: category != null ? category.name : null,
                decoration: kTextFieldDecoration,
                onChanged: (val) {
                  category != null ? category.name = val : _name = val;
                },
              ),
              SizedBox(height: height * 0.02),
              Center(
                child: Btn(
                  title: category != null
                      ? getTranslated(context, 'Edit')
                      : getTranslated(context, 'ADD'),
                  color: Colors.black54,
                  onPressed: () {
                    if (category == null) {
                      if (_image == null) {
                        setSnackbar(
                            getTranslated(
                                context, 'Please Added/wait UpLoad Image!'),
                            context);
                        return;
                      }
                      if (_name == null || _name!.trim().isEmpty) {
                        setSnackbar(
                            getTranslated(context, 'Please Enter name.!'),
                            context);
                        return;
                      }
                      Category category =
                          Category(name: _name!, image: _image!);
                      bloc.add(AddCategory(category));
                    } else {
                      if (category.name.trim().isEmpty) {
                        setSnackbar(
                            getTranslated(context, 'Please Enter name.!'),
                            context);
                        return;
                      } else
                        bloc.add(EditCategory(category));
                    }
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
