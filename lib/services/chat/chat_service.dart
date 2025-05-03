import 'package:acopiatech/services/cloud/chat/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // Send message to the chat with collectionId
  Future<void> sendMessage(String collectionId, String message) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // Create a new message
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: collectionId,
      message: message,
      timestamp: timestamp,
    );

    // Create a unique chatRoomId using collectionId and currentUserId
    List<String> ids = [currentUserId, collectionId];
    ids.sort(); // Sorting to ensure unique and consistent chat room ID
    String chatRoomId = ids.join("...");

    // Save the message to Firestore
    await _firebaseFirestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  // Get chat messages based on collectionId
  Stream<QuerySnapshot> getMessages(String userId, String collectionId) {
    // Create a unique chatRoomId using userId and collectionId
    List<String> ids = [userId, collectionId];
    ids.sort(); // Sorting to ensure unique and consistent chat room ID
    String chatRoomId = ids.join("...");

    return _firebaseFirestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
