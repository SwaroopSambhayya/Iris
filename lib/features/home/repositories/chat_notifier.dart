// import 'package:chat_gpt_api/chat_gpt.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lets_chat/features/home/models/chat.dart';
import 'package:lets_chat/features/home/models/conversation_state_model.dart';
import 'package:lets_chat/shared/const.dart';
import 'package:lets_chat/shared/keys.dart';
import 'package:text_to_speech/text_to_speech.dart';

class ChatRepo extends StateNotifier<ConversationState> {
  ChatRepo()
      : super(
          ConversationState(
            scale: 0,
            listening: false,
            showInputLayout: false,
            recognizedWords: "",
            viewInsetsBottom: 0,
            chatList: [
              Chat(
                isMe: false,
                message: defaultWelcomeGreet,
                time: DateTime.now(),
              ),
            ],
          ),
        ) {
    initGPTInstance();
  }

  late ChatGPT chatGpt;
  late TextToSpeech tts;

  void initGPTInstance() {
    tts = TextToSpeech();
    tts.setRate(1);
    tts.speak(defaultWelcomeGreet);
    chatGpt = ChatGPT.instance
        .builder(secretToken, baseOption: HttpSetup(receiveTimeout: 6000));
  }

  void changeRecognizedWords(String words) {
    state = state.copyWith(
      recognizedWords: words.trim(),
    );
  }

  void addChat(String words, {bool isMe = true}) {
    state = state.copyWith(
      chatList: [
        ...state.chatList,
        Chat(
          isMe: isMe,
          message: words,
          time: DateTime.now(),
        ),
      ],
    );
    sendMessage(words);
  }

  void sendMessage(String message) async {
    state = state.copyWith(loadingResponse: true);
    try {
      final request = CompleteReq(
          prompt: message, model: kTranslateModelV3, max_tokens: 200);

      chatGpt.onCompleteStream(request: request).listen((response) {
        tts.speak(response!.choices.first.text.trim());
        state = state.copyWith(loadingResponse: false, chatList: [
          ...state.chatList,
          Chat(
              isMe: false,
              message: response.choices.first.text.trim(),
              time: DateTime.now()),
        ]);
      }, onError: (err) {
        debugPrint("Error: " + err.toString());
      });
    } catch (e) {
      print("error send: " + e.toString());
    }
  }

  void setTextAnimationStatus(int index) {
    state = state.copyWith(
        chatList: state.chatList
            .map((e) => e == state.chatList[index]
                ? state.chatList[index].copyWith(isAnimationPlayed: true)
                : e)
            .toList());
  }

  void changeListenState() {
    state = state.copyWith(
        listening: !state.listening,
        recognizedWords: !state.listening ? "" : state.recognizedWords);
  }

  void changeScaleState(double scaleVal) {
    state = state.copyWith(scale: scaleVal);
  }

  void changeKeyboardLayout(bool val) {
    state = state.copyWith(showInputLayout: val);
  }
}
