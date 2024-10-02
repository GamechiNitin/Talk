part of 'session_bloc.dart';

@immutable
sealed class SessionEvent {}

class CurrentSessionEvent extends SessionEvent {}
