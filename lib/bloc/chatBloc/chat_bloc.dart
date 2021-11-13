import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:delivery_app/data/repo/firebase_firestore.dart';
import 'package:delivery_app/models/message.dart';
import 'package:delivery_app/models/question_ans.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(this.dbFireStore) : super(ChatInitial());
  final DBFireStore dbFireStore;
  static ChatBloc get(context) => BlocProvider.of(context);
  List<MessageModel>? messages;
  List<QuestionAnswer>? qA;
  List<String>? usersID;

  // get all message from correct user and other user
  List<MessageModel> getMessages(String userID1, String userID2) {
    return messages!.where((val) {
      if ((val.sendID == userID1 || val.sendID == userID2) &&
          (val.receiverID == userID1 || val.receiverID == userID2)) {
        return true;
      } else {
        return false;
      }
    }).toList();
  }

  @override
  Stream<ChatState> mapEventToState(
    ChatEvent event,
  ) async* {
    if (event is InitialChat) {
      qA = await dbFireStore.getQA();
    }
    if (event is DeleteChat) {
      await dbFireStore.deleteChat(event.correctUser, event.otherUser);
      if (usersID != null) {
        usersID!.removeWhere((element) => element == event.otherUser);
      }
      yield DeleteUserSuccess();
    }
    if (event is SendMessage) {
      try {
        dbFireStore.sendMessage(event.message);
        yield SendMessageSuccess();
      } catch (e) {
        yield SendMessageError();
      }
    }
    if (event is AddUsersId) {
      usersID = dbFireStore.usersID;
      yield UsersIdLoaded(usersID!);
    }
    if (event is AddMessages) {
      messages = dbFireStore.messages;
      yield ChatLoaded(messages!);
    }
    if (event is SetMessagesRead) {
      dbFireStore.setMessageRead(event.sender, event.receiver);
    }
  }
}
