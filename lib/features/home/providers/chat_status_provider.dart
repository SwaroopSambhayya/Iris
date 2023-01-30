import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lets_chat/features/home/models/conversation_state_model.dart';
import 'package:lets_chat/features/home/repositories/chat_notifier.dart';

final chatStatusProvider =
    StateNotifierProvider<ChatRepo, ConversationState>((ref) {
  return ChatRepo();
});
