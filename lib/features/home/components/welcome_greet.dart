import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lets_chat/features/home/components/chat_bubble.dart';
import 'package:lets_chat/shared/const.dart';

class WelcomeGreet extends StatelessWidget {
  const WelcomeGreet({super.key});

  @override
  Widget build(BuildContext context) {
    return ChatBubble(
      child: AnimatedTextKit(
        totalRepeatCount: 1,
        pause: const Duration(milliseconds: 1000),
        animatedTexts: [
          TypewriterAnimatedText(
            defaultWelcomeGreet,
            textAlign: TextAlign.start,
            speed: const Duration(milliseconds: 50),
            textStyle: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
