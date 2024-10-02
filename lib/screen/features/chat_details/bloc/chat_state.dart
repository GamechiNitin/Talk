part of 'chat_bloc.dart';

@immutable
sealed class ChatState {
  final List<ChatModel> chatList;

  const ChatState({this.chatList = const []});
}

class ChatStateActionState extends ChatState {}

class LoadingChatState extends ChatStateActionState {
  final bool loading;
  LoadingChatState(this.loading);
}

final class ChatInitial extends ChatState {
  final List<ChatModel> user;

  const ChatInitial(this.user) : super(chatList: user);
}

final class ChatErrorState extends ChatState {
  final String message;

  const ChatErrorState(this.message);
}
