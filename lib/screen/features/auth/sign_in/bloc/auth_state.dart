part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

abstract class AuthActionState extends AuthState {}

class HomeNavigateState extends AuthActionState {}

class LoadingAuthState extends AuthState {
  final bool loading;
  LoadingAuthState(this.loading);
}

class LoginNavigateState extends AuthActionState {}

class SignUPNavigateState extends AuthActionState {}

class ErrorAuthState extends AuthActionState {
  final String message;

  ErrorAuthState(this.message);
}
