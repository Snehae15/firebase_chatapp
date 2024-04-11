// import 'package:chatapps/model/message.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class ChatService extends ChangeNotifier {
//   //get instance of auth and firestore
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   //SEND MESSAGE
//   Future<void> sendMessage(String receiverId, String message) async {
//     //get current user info
//     final String currentUserId = _firebaseAuth.currentUser!.uid;
//     final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
//     final Timestamp timestamp = Timestamp.now();

//     //create a new message
//     Message newMessage = Message(
//         senderId: currentUserId,
//         senderEmail: currentUserEmail,
//         receiverId: receiverId,
//         timestamp: timestamp,
//         message: message);
//     //construct chat room id from current user id and receiver id (sorted to ensure uniqueness)
//     List<String> ids = [currentUserId, receiverId];
//     ids.sort(); //sort the ids(this ensure the chat room id is always the same for any pair)
//     String chatRoomId =
//         ids.join("_"); //combine the ids into a string to use as a chatroomID
//     //add new message to database
//     await _firestore
//         .collection('chat_rooms')
//         .doc(chatRoomId)
//         .collection('message')
//         .add(newMessage.toMap());
//   }

//   //GET MESSAGE
//   Stream<QuerySnapshot> getMessage(String userId, String otherUserId) {
//     //construct chat room id from user ids(sorted to ensure it matches the id user when sending message)
//     List<String> ids = [userId, otherUserId];
//     ids.sort();
//     String chatRoomId = ids.join("_");
//     return _firestore
//         .collection('chat_rooms')
//         .doc(chatRoomId)
//         .collection('messages')
//         .orderBy('timestamp', descending: false)
//         .snapshots();
//   }
// }
import 'package:chatapps/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String receiverId, String message) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      timestamp: timestamp,
      message: message,
    );

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('message')
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessage(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('message')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
