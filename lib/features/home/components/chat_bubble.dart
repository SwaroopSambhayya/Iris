import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final Widget child;
  final bool isMe;
  const ChatBubble({super.key, required this.child, this.isMe = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isMe
            ? Theme.of(context).primaryColor.withOpacity(0.2)
            : Colors.grey[300],
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(15),
        ).copyWith(
            topRight:
                isMe ? const Radius.circular(0) : const Radius.circular(15),
            topLeft:
                isMe ? const Radius.circular(15) : const Radius.circular(0)),
      ),
      child: child,
    );
  }
}
