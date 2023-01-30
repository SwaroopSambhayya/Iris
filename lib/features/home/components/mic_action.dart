import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lets_chat/features/home/providers/chat_status_provider.dart';
import 'package:lets_chat/shared/const.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class MicAction extends ConsumerStatefulWidget {
  final AudioPlayer player;

  const MicAction({super.key, required this.player});

  @override
  ConsumerState<MicAction> createState() => _MicActionState();
}

class _MicActionState extends ConsumerState<MicAction> {
  late stt.SpeechToText speech;
  @override
  void initState() {
    speech = stt.SpeechToText();
    super.initState();
  }

  speechStatusListener(String text) {
    print(text);
  }

  errorListener(error) {
    print(error.errorMsg);
  }

  speechResultListener(SpeechRecognitionResult result) {
    print(result.recognizedWords);
    ref
        .read(chatStatusProvider.notifier)
        .changeRecognizedWords(result.recognizedWords);
  }

  @override
  Widget build(BuildContext context) {
    bool listening =
        ref.watch(chatStatusProvider.select((value) => value.listening));
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        AnimatedScale(
          duration: const Duration(milliseconds: 500),
          scale: listening ? 1 : 0,
          child: Lottie.asset('$lottieBasePath/circular.json',
              animate: true, width: 160, height: 160),
        ),
        Positioned.fill(
          top: listening ? 0 : null,
          bottom: listening ? 0 : 52,
          left: listening ? 52 : 0,
          right: listening ? null : 0,
          child: FloatingActionButton(
            onPressed: () async {
              if (!listening) {
                await widget.player.setAsset('music/mic1.mp3');
                widget.player.play();
                bool available = await speech.initialize(
                    onStatus: speechStatusListener, onError: errorListener);
                if (available) {
                  speech.listen(onResult: speechResultListener);
                } else {
                  print("User denied the speech recognition");
                }
              } else {
                await widget.player.setAsset('music/mic2.mp3');
                widget.player.play();
                speech.stop();
                String recognizedWords =
                    ref.read(chatStatusProvider).recognizedWords;
                if (recognizedWords.isNotEmpty) {
                  ref
                      .read(chatStatusProvider.notifier)
                      .addChat(recognizedWords);
                }
              }
              ref.read(chatStatusProvider.notifier).changeScaleState(0.0);
              ref.read(chatStatusProvider.notifier).changeListenState();
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: const Icon(
              Icons.mic,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
