import 'package:delivery_app/helper/Session.dart';

import '../helper/Strings.dart';
import '../bloc/themeBloc/theme_bloc.dart';
import 'package:flutter/material.dart';

class ThemeDialog extends StatefulWidget {
  @override
  _ThemeDialogState createState() => _ThemeDialogState();
}

class _ThemeDialogState extends State<ThemeDialog> {
  @override
  Widget build(BuildContext context) {
    ThemeBloc themeBloc = ThemeBloc.get(context);
    String theme;
    if (themeBloc.themeMode == ThemeMode.light)
      theme = LIGHT;
    else if (themeBloc.themeMode == ThemeMode.dark)
      theme = DARK;
    else
      theme = SYSTEM;
    return AlertDialog(
      title: Text(
        getTranslated(context, 'Choose Theme'),
        style: Theme.of(context).textTheme.headline6,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(),
          RadioListTile(
              title: Text(getTranslated(context, SYSTEM)),
              value: SYSTEM,
              groupValue: theme,
              onChanged: (val) {
                setState(() {
                  theme = val.toString();
                });
                themeBloc.add(ChangeTheme(ThemeMode.system));
              }),
          RadioListTile(
              title: Text(getTranslated(context, LIGHT)),
              value: LIGHT,
              groupValue: theme,
              onChanged: (val) {
                setState(() {
                  theme = val.toString();
                  themeBloc.add(ChangeTheme(ThemeMode.light));
                });
              }),
          RadioListTile(
              title: Text(getTranslated(context, DARK)),
              value: DARK,
              groupValue: theme,
              onChanged: (val) {
                setState(() {
                  theme = val.toString();
                  themeBloc.add(ChangeTheme(ThemeMode.dark));
                });
              }),
        ],
      ),
    );
  }
}
