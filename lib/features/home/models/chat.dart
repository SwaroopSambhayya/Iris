class Chat {
  const Chat(
      {required this.isMe,
      required this.message,
      required this.time,
      this.isAnimationPlayed = false});
  final bool isMe;
  final bool isAnimationPlayed;
  final String message;
  final DateTime time;
  Chat copyWith(
      {bool? isMe, String? message, DateTime? time, bool? isAnimationPlayed}) {
    return Chat(
        isMe: isMe ?? this.isMe,
        message: message ?? this.message,
        isAnimationPlayed: isAnimationPlayed ?? this.isAnimationPlayed,
        time: time ?? this.time);
  }
}
