import 'package:collection/collection.dart';

import 'package:delivery_app/bloc/chatBloc/chat_bloc.dart';
import 'package:delivery_app/helper/Strings.dart';
import 'package:delivery_app/models/message.dart';
import 'package:delivery_app/models/question_ans.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class DBFireStore {
  CollectionReference users = FirebaseFirestore.instance.collection(USERS);
  static List<MessageModel> _messages = [];
  static List<String> _usersID = [];
  List<String> get usersID => _usersID;
  List<MessageModel> get messages => _messages;

  static initial(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      ChatBloc chatBloc = ChatBloc.get(context);
      FirebaseFirestore.instance
          .collection(USERS)
          .doc(user.uid)
          .collection(CHATS)
          .orderBy(DATE_TIME)
          .snapshots()
          .listen((event) {
        if (event.docs.isNotEmpty) {
          _messages.clear();
          event.docs.forEach((element) {
            if (element.exists) {
              _messages.add(MessageModel.fromJson(element.data(), element.id));
              if (element.data()[SEND_ID] != user.uid) {
                var found = _usersID
                    .firstWhereOrNull((val) => val == element.data()[SEND_ID]);
                if (found == null) _usersID.add(element.data()[SEND_ID]);
              } else if (element.data()[RECEIVER_ID] != user.uid) {
                var found = _usersID.firstWhereOrNull(
                    (val) => val == element.data()[RECEIVER_ID]);
                if (found == null) _usersID.add(element.data()[RECEIVER_ID]);
              }
            }
          });
        }
        chatBloc.add(AddUsersId());
        chatBloc.add(AddMessages());
      });
    }
  }

  Future<void> sendMessage(MessageModel message) async {
    try {
      await users.doc(message.sendID).collection(CHATS).add(message.toMap());
      await users
          .doc(message.receiverID)
          .collection(CHATS)
          .add(message.toMap());
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> deleteChat(String correctUser, String otherUser) async {
    try {
      var data = await users.doc(correctUser).collection(CHATS).get();
      if (data.docs.isNotEmpty) {
        _usersID.removeWhere((element) => element == otherUser);
        for (var doc in data.docs) {
          if ((doc.data()[SEND_ID] == correctUser ||
                  doc.data()[SEND_ID] == otherUser) &&
              (doc.data()[RECEIVER_ID] == correctUser ||
                  doc.data()[RECEIVER_ID] == otherUser)) {
            await doc.reference.delete();
          }
        }
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> setMessageRead(String sender, String receiver) async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await users
          .doc(user.uid)
          .collection(CHATS)
          .where(READ, isEqualTo: false)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty)
          value.docs.forEach((element) {
            if ((element.data()[SEND_ID] == sender ||
                    element.data()[SEND_ID] == receiver) &&
                (element.data()[RECEIVER_ID] == sender ||
                    element.data()[RECEIVER_ID] == receiver)) {
              element.reference.update({READ: true});
            }
          });
      });
    }
  }

  Future<List<QuestionAnswer>?> getQA() async {
    try {
      var data = await FirebaseFirestore.instance.collection('Q_A').get();
      for (var doc in data.docs) {
        if (doc.exists) {
          List<QuestionAnswer> Q_A = [];
          for (var i = 1; i <= doc.data().length / 2; i++) {
            Q_A.add(QuestionAnswer(q: doc.data()['q$i'], a: doc.data()['a$i']));
          }
          return Q_A;
        }
      }
    } catch (e) {
      return null;
    }
  }
}
