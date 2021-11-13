import 'package:delivery_app/bloc/controlApp/ControlAppBloc.dart';
import 'package:delivery_app/bloc/controlApp/controlAppEvent.dart';
import 'package:delivery_app/bloc/controlApp/controlAppState.dart';
import 'package:delivery_app/helper/Session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants.dart';

class BNBar extends StatefulWidget {
  @override
  _BNBarState createState() => _BNBarState();
}

class _BNBarState extends State<BNBar> with SingleTickerProviderStateMixin {
  TabController? tab;
  @override
  void initState() {
    super.initState();
    tab = TabController(length: 4, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    // var height = MediaQuery.of(context).size.height;
    ControlAppBloc bloc = ControlAppBloc.get(context);

    return Container(
      height: kBottomNavigationBarHeight, //height * 0.07,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topRight: const Radius.circular(10),
          topLeft: const Radius.circular(10),
        ),
        color: Theme.of(context).primaryColor,
      ),
      child: BlocBuilder<ControlAppBloc, ControlAppState>(
        builder: (context, state) {
          return TabBar(
            controller: tab,
            onTap: (c) {
              if (c == 0) {
                bloc.add(ControlAppChangeBottomBar(c));
              } else if (!checkUserNull(context))
                bloc.add(ControlAppChangeBottomBar(c));
            },
            indicatorColor: secondaryColorDark,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              ItemBNBAR(
                iconData: bloc.index == 0 ? Icons.home : Icons.home_outlined,
                color: Theme.of(context).iconTheme.color!,
              ),
              ItemBNBAR(
                iconData: bloc.index == 1 ? Icons.chat : Icons.chat_outlined,
                color: Theme.of(context).iconTheme.color!,
              ),
              ItemBNBAR(
                iconData: bloc.index == 2
                    ? Icons.notifications
                    : Icons.notifications_outlined,
                color: Theme.of(context).iconTheme.color!,
              ),
              ItemBNBAR(
                iconData: bloc.index == 3 ? Icons.person : Icons.person_outline,
                color: Theme.of(context).iconTheme.color!,
              ),
            ],
          );
        },
      ),
    );
  }
}

class ItemBNBAR extends StatelessWidget {
  final IconData iconData;
  final Color color;
  const ItemBNBAR({required this.iconData, required this.color});
  @override
  Widget build(BuildContext context) {
    return Icon(
      iconData,
      color: color,
      size: color == secondaryColor ? 27 : 24,
    );
  }
}
