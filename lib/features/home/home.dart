import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lets_chat/features/chat/chat_list.dart';
import 'package:lets_chat/features/home/components/keyboard_input.dart';
import 'package:lets_chat/features/home/components/keyboard_input_icon.dart';
import 'package:lets_chat/features/home/components/mic_action.dart';
import 'package:lets_chat/features/home/providers/chat_status_provider.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  late AudioPlayer player;
  double viewInsetsBottom = 0;

  @override
  void initState() {
    player = AudioPlayer();
    Future.delayed(const Duration(milliseconds: 500), () {
      ref.read(chatStatusProvider.notifier).changeScaleState(1);
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    double diff = MediaQuery.of(context).viewInsets.bottom - 20;
    if (MediaQuery.of(context).viewInsets.bottom - 20 >= 0) {
      viewInsetsBottom = diff;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Iris",
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
        elevation: 0.5,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const KeyboardInput(),
            MicAction(player: player),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 15).copyWith(top: 0),
          child: Stack(
            children: [
              const ChatList(),
              KeyboardInputField(
                viewInsetsBottom: viewInsetsBottom,
              )
            ],
          ),
        ),
      ),
    );
  }
}
