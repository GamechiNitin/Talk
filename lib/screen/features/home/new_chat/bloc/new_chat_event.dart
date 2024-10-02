part of 'new_chat_bloc.dart';

@immutable
sealed class NewChatEvent {}

class FetchUserEvent extends NewChatEvent {}

class CreateChatEvent extends NewChatEvent {
  final String userId1;
  final String sender;
  final UserModel userModel;

  CreateChatEvent(this.userId1, this.sender, this.userModel);
}

class SearchUserEvent extends NewChatEvent {
  final String email;

  SearchUserEvent(this.email);
}
