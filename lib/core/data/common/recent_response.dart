import 'package:cloud_firestore/cloud_firestore.dart';

import 'user_model.dart';

class RecentChatModel {
  final String? chatID;
  final UserModel? receiver;
  final UserModel? sender;
  final List<String>? participants;

  RecentChatModel({
    this.chatID,
    this.receiver,
    this.sender,
    this.participants,
  });

  factory RecentChatModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RecentChatModel(
      chatID: data['chatID'],
      receiver: UserModel.fromJson(data['receiver']),
      sender: UserModel.fromJson(data['sender']),
      participants: List<String>.from(data['participants']),
    );
  }
  factory RecentChatModel.fromJson(Map<String, dynamic> json) {
    return RecentChatModel(
      chatID: json['chatID'],
      receiver: UserModel.fromJson(json['receiver']),
      sender: UserModel.fromJson(json['sender']),
      participants: List<String>.from(json['participants']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatID': chatID,
      'receiver': receiver?.toJson(),
      'sender': sender?.toJson(),
      'participants': participants,
    };
  }
}
