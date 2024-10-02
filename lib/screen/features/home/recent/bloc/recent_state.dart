part of 'recent_bloc.dart';

@immutable
sealed class RecentState {
  final List<RecentChatModel> chatList;

  const RecentState({this.chatList = const []});
}

final class RecentInitial extends RecentState {}

abstract class RecentActionState extends RecentState {}

class RecentLoadingState extends RecentState {
  final bool loading;
  const RecentLoadingState(this.loading);
}

final class RecentChatState extends RecentState {
  final List<RecentChatModel> user;
  const RecentChatState(this.user) : super(chatList: user);
}

class RecentChatErrorState extends RecentActionState {
  final String message;
  RecentChatErrorState(this.message);
}
