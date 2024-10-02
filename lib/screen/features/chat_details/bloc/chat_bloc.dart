import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talk/core/firebase_service/fire_auth.dart';
import 'package:talk/screen/features/chat_details/data/chat_model.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  late final StreamSubscription<QuerySnapshot> _messagesSubscription;

  ChatBloc() : super(const ChatInitial([])) {
    on<FetchMessages>(fetchMessages);
    on<EmitMessages>(emitMessages);
    on<SendMessage>(sendMessage);
  }

  FutureOr<void> sendMessage(SendMessage event, Emitter<ChatState> emit) async {
    log(event.chatId);
    emit(LoadingChatState(true));
    await FireAuth.sendMessage(
      event.chatId,
      event.senderId,
      event.message,
      file: event.file,
    );
    emit(LoadingChatState(false));
  }

  FutureOr<void> fetchMessages(FetchMessages event, Emitter<ChatState> emit) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    _messagesSubscription = firestore
        .collection('chats')
        .doc(event.chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .listen(
      (messagesSnapshot) {
        final messages = messagesSnapshot.docs
            .map((doc) => ChatModel.fromDocument(doc))
            .toList();
        add(EmitMessages(messages));
      },
      onError: (error) {},
    );
  }

  @override
  Future<void> close() {
    _messagesSubscription.cancel();
    return super.close();
  }

  FutureOr<void> emitMessages(EmitMessages event, Emitter<ChatState> emit) {
    emit(LoadingChatState(true));
    emit(ChatInitial(event.chatId));
    emit(LoadingChatState(false));
  }
}
