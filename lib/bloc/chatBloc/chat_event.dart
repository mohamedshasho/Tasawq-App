part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}

class InitialChat extends ChatEvent {}

class SendMessage extends ChatEvent {
  final MessageModel message;
  SendMessage(this.message);
}

class AddUsersId extends ChatEvent {}

class AddMessages extends ChatEvent {}

class DeleteChat extends ChatEvent {
  final String correctUser;
  final String otherUser;
  DeleteChat({required this.correctUser, required this.otherUser});
}

class SetMessagesRead extends ChatEvent {
  final String sender;
  final String receiver;
  SetMessagesRead({required this.sender, required this.receiver});
}
