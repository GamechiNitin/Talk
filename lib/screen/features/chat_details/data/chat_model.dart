import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String? id;
  final String? email;
  final String? name;
  final String? senderId;
  final String? message;
  final Timestamp? timestamp;
  final String? photoURL;
  final String? imageUrl;
  final String? type;
  final String? status;
  final String? chatID;
  ChatModel({
    this.message,
    this.id,
    this.email,
    this.name,
    this.senderId,
    this.imageUrl,
    this.timestamp,
    this.type,
    this.photoURL,
    this.status,
    this.chatID,
  });

  factory ChatModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatModel(
      id: doc.id,
      email: data['email'] ?? '',
      message: data['message'] ?? '',
      senderId: data['senderId'] ?? '',
      name: data['name'] ?? '',
      photoURL: data['photoURL'],
      imageUrl: data['imageUrl'],
      timestamp: data['timestamp'],
      type: data['type'],
      status: data['status'] ?? 'offline',
      chatID: data['chatID'] ?? 'NA',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photoURL': photoURL,
      'message': message,
      'status': status,
      'timestamp': timestamp,
      'imageUrl': imageUrl,
      'senderId': senderId,
      'type': type,
      'chatID': chatID,
    };
  }
}
