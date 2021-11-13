import 'package:delivery_app/bloc/Auth/auth_bloc.dart';
import 'package:delivery_app/bloc/controlApp/ControlAppBloc.dart';
import 'package:delivery_app/bloc/controlApp/controlAppState.dart';
import 'package:delivery_app/componants/drawer.dart';
import 'package:delivery_app/data/repo/firebase_firestore.dart';
import 'package:delivery_app/data/repo/firebase_repo.dart';
import 'package:delivery_app/helper/Session.dart';
import 'package:delivery_app/helper/Strings.dart';
import 'package:delivery_app/helper/notifications_service.dart';
import 'package:delivery_app/screens_delivery/categories.dart';
import 'package:delivery_app/screens_delivery/home.dart';
import 'package:delivery_app/screens_delivery/products.dart';
import 'package:delivery_app/wedgets/Build_BNBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants.dart';

class Home extends StatefulWidget {
  static const String id = 'home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    FirebaseRepo.initial(context);
    DBFireStore.initial(context);
    NotificationsService().initialise(context);
  }

  @override
  void dispose() {
    FirebaseRepo.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ControlAppBloc bloc = ControlAppBloc.get(context);
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: CustomPaint(
              painter: BackgroundAppbarColor(context),
              child: Container(),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 50,
            leading: Builder(
              builder: (ctx) => GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Image.asset(
                    'assets/images/menu.png',
                    fit: BoxFit.fill,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                onTap: () {
                  Scaffold.of(ctx).openDrawer();
                },
              ),
            ),
            title: BlocConsumer<ControlAppBloc, ControlAppState>(
                listener: (context, state) {},
                builder: (context, state) {
                  return Text(
                    getTranslated(context, bloc.screenTitle[bloc.index]),
                    style: Theme.of(context).textTheme.headline3,
                  );
                }),
            actions: [
              context.read<AuthBloc>().userModel!.type == DELIVERY
                  ? PopupMenuButton<int>(
                      color: Theme.of(context).backgroundColor,
                      icon: Icon(
                        Icons.settings,
                        color: Theme.of(context).primaryColor,
                      ),
                      itemBuilder: (ctx) => [
                        PopupMenuItem(
                          value: 0,
                          child: Text(
                            getTranslated(context, 'DashBoard'),
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                        PopupMenuItem(
                          value: 1,
                          child: Text(
                            getTranslated(context, 'Categories'),
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                        PopupMenuItem(
                          value: 2,
                          child: Text(
                            getTranslated(context, 'Products'),
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                      ],
                      onSelected: _onSelected,
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Image.asset(
                        'assets/images/appIcon.png',
                        height: 30,
                        width: 30,
                      ),
                    ),
            ],
          ),
          bottomNavigationBar: BNBar(),
          drawer: CustomDrawer(),
          body: BlocConsumer<ControlAppBloc, ControlAppState>(
              listener: (_, state) {},
              builder: (_, state) {
                if (AuthBloc.get(context).isUserSignIn())
                  return bloc.screens[bloc.index];
                else {
                  return bloc.screens[0];
                }
              }),
        ),
      ),
    );
  }

  void _onSelected(int value) {
    switch (value) {
      case 0:
        {
          Navigator.pushNamed(context, HomeDelivery.id);
          break;
        }
      case 1:
        {
          Navigator.pushNamed(context, Categories.id);
          break;
        }
      case 2:
        {
          Navigator.pushNamed(context, Products.id);
          break;
        }
    }
  }
}
