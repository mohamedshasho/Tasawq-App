import 'package:delivery_app/bloc/Products/bloc_product.dart';
import 'package:delivery_app/componants/ContainerBn.dart';
import 'package:delivery_app/componants/appbar_custom.dart';
import 'package:delivery_app/componants/snack_bar.dart';
import 'package:delivery_app/helper/Session.dart';
import 'package:delivery_app/helper/notifications_service.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class SendNotification extends StatefulWidget {
  static const String id = 'SendNotification';

  @override
  _SendNotificationState createState() => _SendNotificationState();
}

class _SendNotificationState extends State<SendNotification> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late BlocProduct bloc;
  late List<String> _tokens;
  String? _title;
  String? _body;
  @override
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = BlocProduct.get(context);
    _tokens = bloc.getAllToken();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              BuildAppbar(
                  title: getTranslated(context, 'Send Notification'),
                  onTap: () => Navigator.pop(context)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  getTranslated(context,
                      'Note!: The notification can only be received by the person who following you'),
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Divider(),
              const SizedBox(height: 10),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: getTranslated(context, 'Title'),
                      ),
                      initialValue: "${bloc.userStore!.value.username}",
                      enabled: false,
                      onSaved: (val) => _title = val,
                      validator: (val) {
                        if (val!.isEmpty)
                          return getTranslated(context, 'Please enter title');
                        else
                          return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      minLines: 5,
                      maxLines: 10,
                      onSaved: (val) => _body = val,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: getTranslated(context, 'Body'),
                      ),
                      validator: (val) {
                        if (val!.isEmpty)
                          return getTranslated(context, 'Please enter body');
                        else
                          return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ContainerBn(
                color: Theme.of(context).buttonColor,
                title: getTranslated(context, 'Send'),
                onPress: () async {
                  final form = _formKey.currentState;
                  if (form!.validate()) {
                    form.save();
                    if (_tokens.isNotEmpty) {
                      String result = await NotificationsService()
                          .sendNotificationBody(
                              title: _title!,
                              body: _body!,
                              tokens: _tokens,
                              context: context);
                      setSnackbar(result, context);
                    } else {
                      setSnackbar(
                          getTranslated(context, 'No found followers yet!'),
                          context);
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
