part of 'recent_bloc.dart';

@immutable
sealed class RecentEvent {}

class FetchRecentChatEvent extends RecentEvent {}
