part of 'new_chat_bloc.dart';

@immutable
sealed class NewChatState {
  final List<UserModel> userList;

  const NewChatState({this.userList = const []});
}

abstract class NewChatActionState extends NewChatState {}

class LoadingAuthState extends NewChatState {
  final bool loading;
  const LoadingAuthState(this.loading);
}

final class NewChatInitial extends NewChatState {
  final List<UserModel> user;

  const NewChatInitial(this.user) : super(userList: user);
}

final class NewChatErrorState extends NewChatState {
  final String message;

  const NewChatErrorState(this.message);
}

class NavigateToChat extends NewChatActionState {
  final ChatModel chatModel;

  NavigateToChat(this.chatModel);
}
