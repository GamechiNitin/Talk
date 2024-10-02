import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String email;
  final String name;
  final String? photoURL;
  final String status;
  UserModel({
    this.id,
    required this.email,
    required this.name,
    this.photoURL,
    required this.status,
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      photoURL: data['photoURL'],
      status: data['status'] ?? 'offline',
    );
  }
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      photoURL: json['photoURL'],
      name: json['name'],
      email: json['email'],
      status: json['status'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photoURL': photoURL,
      'status': status,
    };
  }
}
