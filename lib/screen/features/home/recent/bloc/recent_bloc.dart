import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talk/core/firebase_service/fire_auth.dart';
import 'package:talk/core/data/common/recent_response.dart';

part 'recent_event.dart';
part 'recent_state.dart';

class RecentBloc extends Bloc<RecentEvent, RecentState> {
  RecentBloc() : super(RecentInitial()) {
    on<FetchRecentChatEvent>(fetchRecentChatEvent);
  }

  FutureOr<void> fetchRecentChatEvent(
      FetchRecentChatEvent event, Emitter<RecentState> emit) async {
    emit(const RecentLoadingState(true));
    final response = await FireAuth.fetchRecentChat();
    emit(const RecentLoadingState(false));

    if (response.$1.isNotEmpty) {
      List<RecentChatModel> data = [];
      data.addAll(response.$1);
      emit(RecentChatState(data));
    } else {
      if (response.$2 != null) {
        log(response.$2.toString());
        emit(RecentChatErrorState(response.$2!));
      }
      emit(const RecentChatState([]));
    }
  }
}
