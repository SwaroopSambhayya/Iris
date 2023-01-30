import 'package:chat_gpt_api/app/chat_gpt.dart';
import 'package:chat_gpt_api/app/model/data_model/completion/completion_request.dart';
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
    chatGpt = ChatGPT.builder(token: secretToken);
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
      var botResponse = await chatGpt.textCompletion(
        request: CompletionRequest(
            prompt: message,
            maxTokens: 256,
            presencePenalty: 0,
            temperature: 0.7),
      );

      tts.speak(botResponse!.choices!.first.text!.trim());
      state = state.copyWith(loadingResponse: false, chatList: [
        ...state.chatList,
        Chat(
            isMe: false,
            message: botResponse.choices!.first.text!.trim(),
            time: DateTime.now()),
      ]);
    } catch (e) {
      print(e);
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
