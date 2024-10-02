part of 'session_bloc.dart';

@immutable
sealed class SessionState {}

final class SessionInitial extends SessionState {}

class HomeNavigateState extends SessionState {}

class LoginNavigateState extends SessionState {}

class SignUPNavigateState extends SessionState {}
