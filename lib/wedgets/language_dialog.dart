import 'package:delivery_app/bloc/controlApp/ControlAppBloc.dart';
import 'package:delivery_app/main.dart';
import 'package:delivery_app/helper/Session.dart';
import 'package:flutter/material.dart';

class LanguageDialog extends StatefulWidget {
  @override
  _LanguageDialogState createState() => _LanguageDialogState();
}

class _LanguageDialogState extends State<LanguageDialog> {
  String? language;
  final List<String> langCode = ["en", "ar"];
  @override
  void didChangeDependencies() {
    language = ControlAppBloc.get(context).direction;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        getTranslated(context, 'Choose Language'),
        style: Theme.of(context).textTheme.headline6,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(),
          RadioListTile(
              title: Text(getTranslated(context, 'English')),
              value: 'en',
              groupValue: language,
              onChanged: (val) {
                setState(() {
                  language = val.toString();
                  _changeLan(langCode[0]);
                });
              }),
          RadioListTile(
              title: Text(getTranslated(context, 'Arabic')),
              value: 'ar',
              groupValue: language,
              onChanged: (val) {
                setState(() {
                  language = val.toString();
                  _changeLan(langCode[1]);
                });
              }),
        ],
      ),
    );
  }

  void _changeLan(String language) async {
    Locale _locale = await setLocale(language);
    MyApp.setLocale(context, _locale);
  }
}
