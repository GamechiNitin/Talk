import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:talk/screen/features/chat_details/data/chat_model.dart';
import 'package:talk/core/data/common/recent_response.dart';
import 'package:talk/core/data/common/user_model.dart';

abstract class FireAuth {
  static Future<(User?, String)> signInWithGoogle() async {
    try {
      await GoogleSignIn().signOut();
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      User? user = (await auth.signInWithCredential(credential)).user;
      if (user != null) {
        firestore.collection("users").doc(auth.currentUser!.uid).set({
          "name": user.displayName,
          "email": user.email,
          "photoURL": user.photoURL,
          "status": "Active",
        });
      }
      return (user, "Success");
    } catch (e) {
      log(e.toString());
      return (null, e.toString());
    }
  }

  static Future<DocumentSnapshot?> fetchUserByEmail(String email) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      final response = await firestore
          .collection('users')
          .where("email", isEqualTo: email)
          .get();

      if (response.docs.isNotEmpty) {
        return response.docs.first;
      } else {
        log("No user found with the email: $email");
        return null;
      }
    } catch (e) {
      log("Error fetching user: $e");
      return null;
    }
  }

  static Future<(List<RecentChatModel>, String?)> fetchRecentChat() async {
    List<RecentChatModel> data = [];
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      // User? user = FirebaseAuth.instance.currentUser;
      // String? currentUserEmail = user?.email;

      final response = await firestore
          .collection('chats')
          // .where("email", isNotEqualTo: currentUserEmail)
          .get();

      if (response.docs.isNotEmpty) {
        data = response.docs
            .map((doc) => RecentChatModel.fromDocument(doc))
            .toList();
      }
      return (data, null);
    } on FirebaseException catch (e) {
      String message = "Firestore error: ${e.code} - ${e.message}";
      log("Err ${e.code}");
      return (data, message);
    } catch (e) {
      log("Error fetching Recent Data: $e");
      return (data, e.toString());
    }
  }

  static Future<(List<UserModel>, String?)> fetchAllUsersExcludingSelf() async {
    List<UserModel> data = [];
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      User? user = FirebaseAuth.instance.currentUser;
      String? currentUserEmail = user?.email;

      // final chatResponse = await firestore.collection('chats').get();

      // List<String> chatUserEmails = chatResponse.docs
      //     .map((doc) => doc['chatID'].toString().split('_').first)
      //     .toList();

      final response = await firestore
          .collection('users')
          .where("email", isNotEqualTo: currentUserEmail)
          .get();

      if (response.docs.isNotEmpty) {
        data = response.docs.map((doc) => UserModel.fromDocument(doc)).toList();
      }
      return (data, null);
    } on FirebaseException catch (e) {
      String message = "Firestore error: ${e.code} - ${e.message}";
      log("Err ${e.code}");
      return (data, message);
    } catch (e) {
      log("Error fetching users: $e");
      return (data, e.toString());
    }
  }

  static Future<void> sendMessage(
    String chatId,
    String senderId,
    String message, {
    File? file,
  }) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String? imageUrl;
    String? type;
    if (file != null) {
      type = file.path.split(".").last;
      final ref = FirebaseStorage.instance
          .ref()
          .child('chat_images/${DateTime.now().toString()}.$type');
      await ref.putFile(file);
      imageUrl = await ref.getDownloadURL();
    }
    log("Image:  $imageUrl");
    await firestore.collection('chats').doc(chatId).collection('messages').add({
      'senderId': senderId,
      'message': message,
      'imageUrl': imageUrl,
      'type': type,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  static Future<String> createChat(String userId1, String userId2) async {
    String chatId = createChatId(userId1, userId2);
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final s1 = (await firestore.collection('users').doc(userId1).get()).data();
    final s2 = (await firestore.collection('users').doc(userId2).get()).data();
    await firestore.collection('chats').doc(chatId).set({
      'chatID': chatId,
      'sender': s2,
      'receiver': s1,
      'participants': [userId1, userId2],
    });
    return chatId;
  }

  static String createChatId(String userId1, String userId2) {
    List<String> ids = [userId1, userId2];
    ids.sort();
    return ids.join('_');
  }

  static Stream<(List<ChatModel>, String?)> fetchChat(String chatId) async* {
    List<ChatModel> data = [];
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      final messagesSnapshot = await firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .get();

      data = messagesSnapshot.docs
          .map((doc) => ChatModel.fromDocument(doc))
          .toList();
      yield (data, null);
    } on FirebaseException catch (e) {
      String message = "Firestore error: ${e.code} - ${e.message}";
      log("Err ${e.code}");
      yield (data, message);
    } catch (e) {
      log("Error fetching users: $e");
      yield (data, e.toString());
    }
  }
}
