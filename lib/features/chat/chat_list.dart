import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lets_chat/features/home/components/chat_bubble.dart';
import 'package:lets_chat/features/home/models/conversation_state_model.dart';
import 'package:lets_chat/features/home/providers/chat_status_provider.dart';
import 'package:lottie/lottie.dart';

class ChatList extends ConsumerStatefulWidget {
  const ChatList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    ConversationState conversationState = ref.watch(chatStatusProvider);
    ref.listen(chatStatusProvider, (previous, next) {
      if (previous?.chatList.length != next.chatList.length) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
      }
    });
    return GestureDetector(
      onTap: () {
        if (conversationState.showInputLayout) {
          FocusManager.instance.primaryFocus?.unfocus();
          ref.read(chatStatusProvider.notifier).changeKeyboardLayout(false);
        }
      },
      child: ListView.builder(
        controller: _scrollController,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                if (index == 0)
                  Center(
                    child: AnimatedContainer(
                      width: conversationState.scale == 1
                          ? MediaQuery.of(context).size.width
                          : 0,
                      duration: const Duration(milliseconds: 500),
                      child: AnimatedScale(
                        scale: conversationState.scale,
                        duration: const Duration(milliseconds: 500),
                        child: Image.asset(
                          'lib/resources/assets/images/gooey.gif',
                          gaplessPlayback: true,
                        ),
                      ),
                    ),
                  ),
                Align(
                  alignment: conversationState.chatList[index].isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: ChatBubble(
                      isMe: conversationState.chatList[index].isMe,
                      child: conversationState.chatList[index].isMe
                          ? AnimatedSize(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeIn,
                              child: Text(
                                conversationState.chatList[index].message,
                                style: const TextStyle(fontSize: 18),
                              ),
                            )
                          : conversationState.chatList[index].isAnimationPlayed
                              ? Text(
                                  conversationState.chatList[index].message,
                                  style: const TextStyle(fontSize: 18),
                                )
                              : AnimatedTextKit(
                                  totalRepeatCount: 1,
                                  isRepeatingAnimation: false,
                                  onFinished: () {
                                    _scrollController.animateTo(
                                        _scrollController
                                            .position.maxScrollExtent,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.easeIn);
                                    ref
                                        .read(chatStatusProvider.notifier)
                                        .setTextAnimationStatus(index);
                                  },
                                  animatedTexts: [
                                    TypewriterAnimatedText(
                                      conversationState.chatList[index].message,
                                      textAlign: TextAlign.start,
                                      speed: const Duration(milliseconds: 50),
                                      textStyle: const TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                    ),
                  ),
                ),
                if (index == conversationState.chatList.length - 1) ...[
                  if (conversationState.listening &&
                      conversationState.recognizedWords.isNotEmpty)
                    Align(
                      alignment: Alignment.centerRight,
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeIn,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          child: ChatBubble(
                            isMe: true,
                            child: Text(
                              conversationState.recognizedWords,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (conversationState.loadingResponse)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Lottie.asset(
                          'lib/resources/assets/lottie/typing.json',
                          width: 80,
                          height: 80),
                    ),
                  SizedBox(
                      height: MediaQuery.of(context).viewInsets.bottom + 100),
                ]
              ],
            ),
          );
        },
        itemCount: conversationState.chatList.length,
      ),
    );
  }
}
