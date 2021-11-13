import 'package:delivery_app/bloc/Products/bloc_product.dart';
import 'package:delivery_app/screens/Home_screen.dart';
import 'package:delivery_app/bloc/Auth/auth_bloc.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splashScreen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    AuthBloc authBloc = AuthBloc.get(context);
    Future.delayed(Duration(milliseconds: 1500)).then((value) {
      print(authBloc.userModel!.email);
      if (authBloc.userModel!.email == null) {
        Navigator.pushNamedAndRemoveUntil(context, Home.id, (route) => false);
      } else {
        BlocProduct.get(context);
        Navigator.pushNamedAndRemoveUntil(context, Home.id, (route) => false);
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    precacheImage(AssetImage("assets/images/pic_drawer.jpg"), context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/appIcon.png',
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height * 0.3,
        ),
      ),
    );
  }
}
