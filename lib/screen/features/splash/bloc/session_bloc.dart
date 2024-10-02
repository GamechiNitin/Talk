import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'session_event.dart';
part 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  SessionBloc() : super(SessionInitial()) {
    on<CurrentSessionEvent>(currentSessionEvent);
  }

  FutureOr<void> currentSessionEvent(
      CurrentSessionEvent event, Emitter<SessionState> emit) async {
    User? user = FirebaseAuth.instance.currentUser;
    await Future.delayed(const Duration(seconds: 2));
    if (user != null) {
      final name = user.displayName;
      log("Session $name");
      emit(HomeNavigateState());
    } else {
      emit(LoginNavigateState());
    }
  }
}
