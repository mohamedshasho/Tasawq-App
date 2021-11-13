import 'package:delivery_app/componants/Btn.dart';
import 'package:delivery_app/helper/Session.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SelectImageDialog extends StatefulWidget {
  @override
  _SelectImageDialogState createState() => _SelectImageDialogState();
}

class _SelectImageDialogState extends State<SelectImageDialog> {
  final ImagePicker _imagePicker = ImagePicker();
  PickedFile? _file;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 3,
      title: Text(
        getTranslated(context, 'Select one!'),
        style: Theme.of(context).textTheme.headline5,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                  child: Btn(
                title: getTranslated(context, 'Camera'),
                onPressed: () => chooseImage(ImageSource.camera),
                color: Theme.of(context).buttonColor,
              )),
              Flexible(
                  child: Btn(
                title: getTranslated(context, 'Gallery'),
                onPressed: () => chooseImage(ImageSource.gallery),
                color: Theme.of(context).buttonColor,
              )),
            ],
          ),
        ],
      ),
    );
  }

  void chooseImage(ImageSource src) async {
    _file = await _imagePicker.getImage(source: src, imageQuality: 50);
//50% Image Quality - 590KB نصف الدقة
// 25% Image Quality - 276KB حالتنا هون
// 5% Image Quality - 211KB
    if (_file != null) {
      Navigator.pop(context, _file);
    } else {
      print('no image selected');
    }
  }
}
