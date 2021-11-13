import 'package:delivery_app/helper/Session.dart';
import 'package:delivery_app/screens_user/Explore_screen.dart';
import 'package:delivery_app/screens_user/Stores_views.dart';
import 'package:delivery_app/screens_user/favorite_screen.dart';
import 'package:delivery_app/screens_user/setting_Screen.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: DrawerPath(),
      child: Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Image.asset(
                  'assets/images/pic_drawer.jpg',
                ),
              ),
              BuildListTile(
                title: getTranslated(context, 'Explore'),
                iconData: Icons.shopping_bag_outlined,
                onPress: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, ExploreScreen.id);
                },
              ),
              BuildListTile(
                  title: getTranslated(context, 'Stores'),
                  iconData: Icons.store_mall_directory_sharp,
                  onPress: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, StoresViews.id);
                  }),
              BuildListTile(
                title: getTranslated(context, 'Favorite'),
                iconData: Icons.favorite,
                onPress: () {
                  if (!checkUserNull(context)) {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, FavoriteScreen.id);
                  }
                },
              ),
              BuildListTile(
                title: getTranslated(context, 'Setting'),
                iconData: Icons.settings,
                onPress: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, Setting.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width * 0.85, 0);
    path.quadraticBezierTo(
        size.width, size.height * 0.5, size.width * 0.85, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class BuildListTile extends StatelessWidget {
  final Function()? onPress;
  final String title;
  final IconData iconData;
  const BuildListTile(
      {required this.onPress, required this.title, required this.iconData});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(title, style: Theme.of(context).textTheme.headline5),
          leading: Icon(
            iconData,
            color: Theme.of(context).iconTheme.color,
          ),
          onTap: onPress,
          contentPadding: EdgeInsets.symmetric(horizontal: 15),
        ),
        Divider(
          indent: 50,
          endIndent: 50,
        ),
      ],
    );
  }
}
