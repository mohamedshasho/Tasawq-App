import 'package:delivery_app/helper/Session.dart';
import 'package:flutter/material.dart';

class TitleStart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            getTranslated(context, 'Tasawq'),
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        const SizedBox(height: 5),
        Center(
          child: Text(
            getTranslated(context, 'markets center'),
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
