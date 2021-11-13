part of 'chat_bloc.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<MessageModel> messages;
  ChatLoaded(this.messages);
}

class SendMessageSuccess extends ChatState {}

class SendMessageError extends ChatState {}

class UsersIdLoading extends ChatState {}

class DeleteUserSuccess extends ChatState {}

class UsersIdLoaded extends ChatState {
  final List<String> usersID;
  UsersIdLoaded(this.usersID);
}
