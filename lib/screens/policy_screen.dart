import 'package:delivery_app/componants/appbar_custom.dart';
import 'package:delivery_app/helper/Session.dart';
import 'package:flutter/material.dart';

class PolicyScreen extends StatelessWidget {
  static const String id = 'PolicyScreen';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BuildAppbar(
                  title: getTranslated(context, 'Policy'),
                  onTap: () => Navigator.pop(context)),
              Text(
                getTranslated(context, 'Usage Agreement'),
                style: Theme.of(context).textTheme.headline3,
              ),
              const SizedBox(height: 3),
              Text(
                getTranslated(context, 'Introduction'),
                style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: Colors.green,
                    ),
              ),
              const SizedBox(height: 3),
              Text(getTranslated(context, 'POLICY_INFO')),
              const SizedBox(height: 8),
              Text(
                getTranslated(context, 'Introduce'),
                style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: Colors.green,
                    ),
              ),
              const SizedBox(height: 3),
              Text(getTranslated(context, 'POLICY_INTRODUCE')),
              const SizedBox(height: 8),
              Text(
                getTranslated(context, 'Terms of use'),
                style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: Colors.green,
                    ),
              ),
              const SizedBox(height: 3),
              Text(getTranslated(context, 'POLICY_TERMS'))
            ],
          ),
        ),
      ),
    );
  }
}
