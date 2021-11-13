import 'package:delivery_app/bloc/Products/bloc_product.dart';
import 'package:delivery_app/bloc/chatBloc/chat_bloc.dart';
import 'package:delivery_app/helper/Session.dart';
import 'package:delivery_app/models/message.dart';
import 'package:delivery_app/models/user_model.dart';
import 'package:delivery_app/screens/chat.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class BuildChatItem extends StatelessWidget {
  BuildChatItem({required this.user});
  final UserModel user;
  @override
  Widget build(BuildContext context) {
    var bloc = ChatBloc.get(context);
    var blocProduct = BlocProduct.get(context);
    List<MessageModel> messages =
        bloc.getMessages(blocProduct.userStore!.id, user.id);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    String _getTime() {
      var time =
          DateTime.now().difference(DateTime.parse(messages.last.dateTime));
      if (time.inSeconds == 00 && time.inMinutes == 00)
        return 'Now';
      else if (time.inSeconds < 60 && time.inMinutes == 00)
        return '${time.inSeconds} s';
      else if (time.inMinutes < 60 && time.inHours == 00)
        return '${time.inMinutes} m';
      else if (time.inHours < 24)
        return '${time.inHours} h';
      else
        return '${time.inDays} d';
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, SendChat.id, arguments: user);
        },
        onLongPress: () {
          final RenderBox? overlay =
              Overlay.of(context)!.context.findRenderObject() as RenderBox;

          final RenderBox button = context.findRenderObject() as RenderBox;

          final RelativeRect position = RelativeRect.fromRect(
            Rect.fromPoints(
              button.localToGlobal(const Offset(40, -20), ancestor: overlay),
              button.localToGlobal(
                  button.size.bottomRight(Offset.zero) + const Offset(-50, 0),
                  ancestor: overlay),
            ),
            Offset.zero & overlay!.size,
          );

          showMenu(
            context: context,
            position: position,
            elevation: 2,
            initialValue: 'menu',
            items: [
              PopupMenuItem(
                enabled: false,
                height: 30,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: Theme.of(context).cardColor,
                        title: Text(
                          getTranslated(context, 'Alert'),
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Divider(),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    bloc.add(DeleteChat(
                                        otherUser: user.id,
                                        correctUser:
                                            blocProduct.userStore!.id));
                                    Navigator.pop(ctx);
                                    Navigator.pop(context, "menu");
                                  },
                                  child: Text(
                                    getTranslated(context, 'Delete'),
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    Navigator.pop(context, "menu");
                                  },
                                  child: Text(
                                    getTranslated(context, 'Cancel'),
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  child: Text(
                    getTranslated(context, 'Delete'),
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              )
            ],
          );
        },
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              child: ClipOval(
                child: user.image != null
                    ? FadeInImage(
                        placeholder: AssetImage('assets/images/user.png'),
                        image: NetworkImage(user.image!),
                        fit: BoxFit.fill,
                        height: height,
                        width: width,
                      )
                    : Image.asset(
                        'assets/images/user.png',
                        fit: BoxFit.cover,
                        height: height,
                        width: width,
                      ),
              ),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.username,
                    style: Theme.of(context).textTheme.headline4),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      messages.last.text,
                      style: messages.last.read
                          ? Theme.of(context).textTheme.headline6
                          : Theme.of(context).textTheme.headline5!.copyWith(
                              color: secondaryColor,
                              fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.access_time),
                    const SizedBox(width: 3),
                    Text(_getTime()),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
