import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lets_chat/features/home/providers/chat_status_provider.dart';

class KeyboardInputField extends ConsumerStatefulWidget {
  final double viewInsetsBottom;
  const KeyboardInputField({
    super.key,
    this.viewInsetsBottom = 0,
  });

  @override
  ConsumerState<KeyboardInputField> createState() => _KeyboardInputFieldState();
}

class _KeyboardInputFieldState extends ConsumerState<KeyboardInputField> {
  late TextEditingController _textController;
  bool sendDisabled = true;
  @override
  void initState() {
    _textController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List selectedData = ref.watch(chatStatusProvider
        .select((value) => [value.showInputLayout, value.listening]));
    bool showInputLayout = selectedData[0];
    bool listening = selectedData[1];
    return showInputLayout && !listening
        ? Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: widget.viewInsetsBottom),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  border: Border(
                    top: BorderSide(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                height: 60,
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        controller: _textController,
                        onSubmitted: (value) {
                          // widget.changeLayout(false);
                        },
                        onChanged: (value) {
                          if (value.isEmpty) {
                            setState(() {
                              sendDisabled = true;
                            });
                          } else if (sendDisabled) {
                            setState(() {
                              sendDisabled = false;
                            });
                          }
                        },
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: "Ask Question...",
                          contentPadding: const EdgeInsets.all(0)
                              .copyWith(left: 20, top: 5),
                          hintStyle: const TextStyle(fontSize: 14),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.secondary,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 0),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    if (!sendDisabled)
                      CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        radius: 20,
                        child: Ink(
                          child: InkWell(
                            onTap: () {
                              ref
                                  .read(chatStatusProvider.notifier)
                                  .changeKeyboardLayout(false);
                              ref
                                  .read(chatStatusProvider.notifier)
                                  .changeScaleState(0.0);
                              ref
                                  .read(chatStatusProvider.notifier)
                                  .addChat(_textController.text);
                              _textController.clear();
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Icon(
                                Icons.send,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ),
          )
        : const SizedBox(width: 0, height: 0);
  }
}
