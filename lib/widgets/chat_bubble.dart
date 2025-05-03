import 'package:acopiatech/constants/colors_palette.dart';
import 'package:acopiatech/services/cloud/chat/message.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorsPalette.backgroundDarkGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
