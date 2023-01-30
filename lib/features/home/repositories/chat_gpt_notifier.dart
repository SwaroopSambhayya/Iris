// import 'package:flutter_chatgpt_api/flutter_chatgpt_api.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:lets_chat/features/chat/models/chat_response.dart';
// import 'package:lets_chat/shared/keys.dart';

// class ChatGPTNotifier extends StateNotifier<ChatResponse> {
//   ChatGPTNotifier()
//       : super(ChatResponse(message: "", messageId: "", conversationId: "")) {
//     initInstance();
//   }
//   late ChatGPTApi _api;
//   void initInstance() {
//     _api =
//         ChatGPTApi(sessionToken: sessionToken, clearanceToken: clearanceToken);
//   }

//   void sendMessage(String message) async {
//     var botResponse = await _api.sendMessage(message);
//     state = ChatResponse(
//         message: botResponse.message,
//         conversationId: botResponse.conversationId,
//         messageId: botResponse.messageId);
//   }
// }
