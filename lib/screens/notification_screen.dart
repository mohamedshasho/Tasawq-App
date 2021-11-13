import 'package:delivery_app/bloc/Auth/auth_bloc.dart';
import 'package:delivery_app/bloc/Products/bloc_product.dart';
import 'package:delivery_app/bloc/controlApp/ControlAppBloc.dart';
import 'package:delivery_app/bloc/controlApp/controlAppEvent.dart';
import 'package:delivery_app/bloc/controlApp/controlAppState.dart';
import 'package:delivery_app/constants.dart';
import 'package:delivery_app/helper/Strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'send_notification.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = AuthBloc.get(context);
    ControlAppBloc appBloc = ControlAppBloc.get(context);
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: CustomPaint(
        painter: BackgroundCustomColor(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            authBloc.userModel!.type == DELIVERY
                ? IconButton(
                    alignment: Alignment.topRight,
                    color: kColorBtmBarIcon,
                    onPressed: () {
                      //if condition because screen use data from bloc
                      if (context.read<BlocProduct>().allUsers != null)
                        Navigator.pushNamed(context, SendNotification.id);
                    },
                    icon: Icon(Icons.notification_add),
                  )
                : const SizedBox(),
            Expanded(
              child: BlocBuilder<ControlAppBloc, ControlAppState>(
                builder: (context, state) {
                  return ListView.separated(
                      itemBuilder: (_, index) {
                        return Card(
                          elevation: 0.5,
                          color: Theme.of(context).backgroundColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: width * 0.8,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${appBloc.notificationTitle[index]}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                        textAlign: TextAlign.start,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        '${appBloc.notificationBody[index]}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3,
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  child: const Icon(Icons.clear),
                                  onTap: () {
                                    appBloc.add(RemoveNotification(index));
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (_, index) => const SizedBox(height: 5),
                      itemCount: appBloc.notificationTitle.length);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
