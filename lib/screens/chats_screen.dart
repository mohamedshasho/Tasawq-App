import 'package:delivery_app/bloc/Products/bloc_product.dart';
import 'package:delivery_app/bloc/chatBloc/chat_bloc.dart';
import 'package:delivery_app/componants/no_internet.dart';
import 'package:delivery_app/constants.dart';
import 'package:delivery_app/helper/Session.dart';
import 'package:delivery_app/models/user_model.dart';
import 'package:delivery_app/wedgets/build_chat_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatelessWidget {
  static const String id = 'ChatScreen';

  @override
  Widget build(BuildContext context) {
    BlocProduct blocProduct = BlocProduct.get(context);
    ChatBloc bloc = ChatBloc.get(context);
    return Scaffold(
      body: CustomPaint(
        painter: BackgroundCustomColor(context),
        child: BlocBuilder<BlocProduct, DataState>(
          ///todo remove when adding offline database
          builder: (ctx, state) {
            if (state is DataLoaded) {
              return BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  return ListView.separated(
                    itemBuilder: (ctx, index) {
                      UserModel? user =
                          blocProduct.getUser(bloc.usersID![index]);
                      return BuildChatItem(user: user!);
                    },
                    separatorBuilder: (_, index) => Divider(),
                    itemCount: bloc.usersID != null ? bloc.usersID!.length : 0,
                  );
                },
              );
            }
            if (state is NoNetworkAvail) {
              return noInternet(context);
            }
            return getProgress();
          },
        ),
      ),
    );
  }
}
