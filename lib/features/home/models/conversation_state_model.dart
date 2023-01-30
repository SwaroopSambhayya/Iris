import 'package:lets_chat/features/home/models/chat.dart';

class ConversationState {
  final double scale;
  final bool listening;
  final bool showInputLayout;
  final double viewInsetsBottom;
  final bool loadingResponse;
  final String recognizedWords;
  final List<Chat> chatList;
  const ConversationState(
      {required this.scale,
      required this.listening,
      required this.showInputLayout,
      required this.recognizedWords,
      this.loadingResponse = false,
      required this.viewInsetsBottom,
      required this.chatList});

  ConversationState copyWith(
      {double? scale,
      bool? listening,
      bool? showInputLayout,
      double? viewInsetsBottom,
      String? recognizedWords,
      bool? loadingResponse,
      List<Chat>? chatList}) {
    return ConversationState(
        scale: scale ?? this.scale,
        listening: listening ?? this.listening,
        showInputLayout: showInputLayout ?? this.showInputLayout,
        recognizedWords: recognizedWords ?? this.recognizedWords,
        viewInsetsBottom: viewInsetsBottom ?? this.viewInsetsBottom,
        loadingResponse: loadingResponse ?? this.loadingResponse,
        chatList: chatList ?? this.chatList);
  }
}
