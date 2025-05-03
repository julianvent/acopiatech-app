import 'package:acopiatech/services/chat/chat_service.dart';
import 'package:acopiatech/widgets/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminChatView extends StatefulWidget {
  final String? receiverCollectionId;
  const AdminChatView({super.key, required this.receiverCollectionId});

  @override
  State<AdminChatView> createState() => _AdminChatViewState();
}

class _AdminChatViewState extends State<AdminChatView> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.receiverCollectionId!,
        _messageController.text,
      );
      _messageController.clear();
    }
  }

  // Fix text field focus when sending message
  FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  void scrollDown() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 100), () => scrollDown());
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Soporte Técnico')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(child: _buildMessageList()),
              buildMessageInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
        _firebaseAuth.currentUser!.uid,
        widget.receiverCollectionId!,
      ),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error al cargar los mensajes'));
        }

        final messages = snapshot.data!.docs;

        return ListView(
          controller: _scrollController,
          children:
              messages.map((document) => buildChatMessages(document)).toList(),
        );
      },
    );
  }

  // Chat messages list
  Widget buildChatMessages(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    var alignment =
        data['senderId'] == _firebaseAuth.currentUser!.uid
            ? Alignment.centerRight
            : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 10,
          crossAxisAlignment:
              (data['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
          mainAxisAlignment:
              data['senderId'] == _firebaseAuth.currentUser!.uid
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
          children: [
            Text(data['SenderEmail']),
            ChatBubble(message: data['message']),
          ],
        ),
      ),
    );
  }

  // Message input
  Widget buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              focusNode: _focusNode,
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Escribe un mensaje...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(icon: const Icon(Icons.send), onPressed: sendMessage),
        ],
      ),
    );
  }
}
