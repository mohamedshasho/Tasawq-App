import 'package:delivery_app/bloc/chatBloc/chat_bloc.dart';
import 'package:delivery_app/componants/appbar_custom.dart';
import 'package:delivery_app/helper/Session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QAScreen extends StatelessWidget {
  static const String id = 'QAScreen';

  @override
  Widget build(BuildContext context) {
    ChatBloc chatBloc = ChatBloc.get(context);
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              BuildAppbar(
                title: getTranslated(context, 'Common Questions'),
                onTap: () => Navigator.pop(context),
              ),
              Expanded(
                child: BlocBuilder<ChatBloc, ChatState>(
                  builder: (context, state) {
                    // if (state is ChatLoaded) {
                    return ListView.separated(
                        itemBuilder: (ctx, index) {
                          return itemQA(context,
                              question: chatBloc.qA![index].q,
                              answer: chatBloc.qA![index].a);
                        },
                        separatorBuilder: (ctx, _) => Divider(),
                        itemCount:
                            chatBloc.qA != null ? chatBloc.qA!.length : 0);
                    // }
                    // return getProgress();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  ExpansionTile itemQA(BuildContext context,
      {required String question, required String answer}) {
    return ExpansionTile(
      title: Text(
        question,
        style: Theme.of(context).textTheme.headline5,
      ),
      tilePadding: const EdgeInsets.symmetric(horizontal: 10),
      expandedAlignment: Alignment.topRight,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, bottom: 5, right: 10),
          child: Text(
            answer,
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
      ],
    );
  }
}
