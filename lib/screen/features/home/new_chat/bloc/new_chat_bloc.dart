import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talk/core/firebase_service/fire_auth.dart';
import 'package:talk/screen/features/chat_details/data/chat_model.dart';
import 'package:talk/core/data/common/user_model.dart';

part 'new_chat_event.dart';
part 'new_chat_state.dart';

class NewChatBloc extends Bloc<NewChatEvent, NewChatState> {
  NewChatBloc() : super(const NewChatInitial([])) {
    on<FetchUserEvent>(fetchUserEvent);
    on<CreateChatEvent>(createChatEvent);
    on<SearchUserEvent>(searchUserEvent);
  }

  FutureOr<void> fetchUserEvent(
      FetchUserEvent event, Emitter<NewChatState> emit) async {
    emit(const LoadingAuthState(true));
    final response = await FireAuth.fetchAllUsersExcludingSelf();
    emit(const LoadingAuthState(false));

    // log(response.$1.elementAt(0).toJson().toString());
    if (response.$1.isNotEmpty) {
      List<UserModel> data = [];
      data.addAll(response.$1);
      emit(NewChatInitial(data));
    } else if (response.$1.isEmpty) {
      emit(const NewChatInitial([]));
    } else {
      if (response.$2 != null) {
        log(response.$2.toString());
        emit(NewChatErrorState(response.$2!));
      }
    }
  }

  FutureOr<void> searchUserEvent(
      SearchUserEvent event, Emitter<NewChatState> emit) {}

  FutureOr<void> createChatEvent(
      CreateChatEvent event, Emitter<NewChatState> emit) async {
    emit(const LoadingAuthState(true));
    final chatId = await FireAuth.createChat(event.userId1, event.sender);
    emit(const LoadingAuthState(false));

    ChatModel chatModel = ChatModel(
      // message: "message",
      id: event.userModel.id ?? "",
      email: event.userModel.email,
      name: event.userModel.name,
      chatID: chatId,
      status: event.userModel.status,
      photoURL: event.userModel.photoURL,
      senderId: event.sender,
    );
    emit(NavigateToChat(chatModel));
  }
}
