part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

class EmitMessages extends ChatEvent {
  final List<ChatModel> chatId;

  EmitMessages(this.chatId);
}

class FetchMessages extends ChatEvent {
  final String chatId;

  FetchMessages(this.chatId);
}

class SendMessage extends ChatEvent {
  final String message;
  final String chatId;
  final String senderId;
  final File? file;
  SendMessage({
    required this.chatId,
    required this.senderId,
    required this.message,
    this.file,
  });
}
