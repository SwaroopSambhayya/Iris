import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lets_chat/features/home/providers/chat_status_provider.dart';

class KeyboardInput extends ConsumerWidget {
  const KeyboardInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool showInputLayout =
        ref.watch(chatStatusProvider.select((value) => value.showInputLayout));
    return showInputLayout
        ? const SizedBox(
            width: 0,
            height: 0,
          )
        : FloatingActionButton(
            heroTag: "keyboard",
            onPressed: () => ref
                .read(chatStatusProvider.notifier)
                .changeKeyboardLayout(!showInputLayout),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            child: const Icon(
              Icons.keyboard_alt_outlined,
            ),
          );
  }
}
