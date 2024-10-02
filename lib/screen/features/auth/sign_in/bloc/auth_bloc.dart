import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talk/core/firebase_service/fire_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>(loginEvent);
  }

  FutureOr<void> loginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(LoadingAuthState(true));
    final user = await FireAuth.signInWithGoogle();

    if (user.$1 != null) {
      emit(LoadingAuthState(false));
      emit(HomeNavigateState());
    } else {
      emit(LoadingAuthState(false));
      emit(ErrorAuthState(user.$2));
    }
  }
}
