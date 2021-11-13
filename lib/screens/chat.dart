import 'dart:async';

import 'package:delivery_app/bloc/Products/bloc_product.dart';
import 'package:delivery_app/bloc/chatBloc/chat_bloc.dart';
import 'package:delivery_app/componants/appbar_custom.dart';
import 'package:delivery_app/constants.dart';
import 'package:delivery_app/helper/Session.dart';
import 'package:delivery_app/models/message.dart';
import 'package:delivery_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntp/ntp.dart';

class SendChat extends StatefulWidget {
  static const String id = 'SendChat';

  @override
  _SendChatState createState() => _SendChatState();
}

class _SendChatState extends State<SendChat> {
  String message = '';
  TextEditingController _textController = TextEditingController();
  late UserModel user;
  late ChatBloc bloc;
  late List<MessageModel> messages;
  late BlocProduct blocProduct;
  ScrollController _controller = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = ModalRoute.of(context)!.settings.arguments as UserModel;
    bloc = ChatBloc.get(context);
    blocProduct = BlocProduct.get(context);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_controller.hasClients) {
      _controller.animateTo(_controller.position.maxScrollExtent,
          duration: Duration(milliseconds: 300), curve: Curves.elasticOut);
    } else {
      Timer(Duration(milliseconds: 400), () => _scrollToBottom());
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BuildAppbar(
                title: user.username,
                onTap: () => Navigator.pop(context),
              ),
              BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  //todo set message is read it when open screen chat OR when listen to new message
                  bloc.add(SetMessagesRead(
                      sender: blocProduct.userStore!.id, receiver: user.id));
                  WidgetsBinding.instance!
                      .addPostFrameCallback((_) => _scrollToBottom());
                  messages =
                      bloc.getMessages(blocProduct.userStore!.id, user.id);
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: messages.length,
                        controller: _controller,
                        itemBuilder: (_, index) {
                          if (messages[index].sendID ==
                              blocProduct.userStore!.id)
                            return userMessage(
                                text: messages[index].text,
                                isMe: true,
                                width: width);
                          else
                            return userMessage(
                                text: messages[index].text,
                                isMe: false,
                                width: width);
                        },
                      ),
                    ),
                  );
                },
              ),
              TextField(
                minLines: 1,
                maxLines: 2,
                controller: _textController,
                onChanged: (val) {
                  setState(() {});
                  message = val;
                },
                decoration: InputDecoration(
                  hintText: getTranslated(context, 'type your message hire..'),
                  suffixIcon: InkWell(
                    child: Icon(
                      Icons.send,
                      color: _textController.text.trim().isNotEmpty
                          ? secondaryColor
                          : Colors.grey,
                    ),
                    onTap: _textController.text.trim().isNotEmpty
                        ? () async {
                            DateTime startDate = new DateTime.now().toLocal();
                            int offset =
                                await NTP.getNtpOffset(localTime: startDate);
                            //todo time
                            String time = startDate
                                .add(new Duration(milliseconds: offset))
                                .toString();
                            if (_textController.text.trim().isNotEmpty) {
                              bloc.add(SendMessage(MessageModel(
                                text: message,
                                receiverID: user.id,
                                sendID: blocProduct.userStore!.id,
                                dateTime: time,
                                read: false,
                              )));
                              _textController.clear();
                            }
                          }
                        : null,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: secondaryColor, width: 1),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: secondaryColor, width: 2.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget userMessage(
      {required String text, required bool isMe, required var width}) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
            color: isMe ? kColorMeMessage : kColorMessage,
            borderRadius: BorderRadius.only(
              bottomLeft: const Radius.circular(10),
              topLeft: isMe ? const Radius.circular(10) : Radius.zero,
              topRight: !isMe ? const Radius.circular(10) : Radius.zero,
              bottomRight: const Radius.circular(10),
            )),
        child: Text(
          text,
          style: Theme.of(context).textTheme.headline5!.copyWith(
                color: Colors.black,
              ),
        ),
      ),
    );
  }
}
