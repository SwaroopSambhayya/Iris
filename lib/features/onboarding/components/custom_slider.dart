import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:go_router/go_router.dart';

class CustomSlider extends StatefulWidget {
  const CustomSlider({Key? key}) : super(key: key);

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  double horizontalDragPosition = 0;
  bool showText = true;
  final GlobalKey _slideKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(
            (MediaQuery.of(context).size.width * 0.75 + 80) / 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          GestureDetector(
            onPanUpdate: (details) async {
              if (!(details.globalPosition.dx >=
                      (MediaQuery.of(context).size.width -
                                  MediaQuery.of(context).size.width * 0.75) /
                              2 +
                          MediaQuery.of(context).size.width * 0.75 -
                          55) &&
                  details.localPosition.dx > 0) {
                setState(() {
                  horizontalDragPosition = details.localPosition.dx;
                  showText = false;
                });
                RenderBox? box =
                    _slideKey.currentContext?.findRenderObject() as RenderBox?;
                Offset? position = box?.localToGlobal(Offset.zero);
                if (position?.dx != null &&
                    horizontalDragPosition + 55 > position!.dx) {}
              } else {
                context.go('/home');
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.setBool("onboarded", true);
                setState(() {
                  horizontalDragPosition = 0;
                  showText = true;
                });
              }
            },
            onPanEnd: (details) {
              setState(() {
                horizontalDragPosition = 0;
                showText = true;
              });
            },
            child: Transform(
              transform:
                  Matrix4.translationValues(horizontalDragPosition, 0, 0),
              child: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                radius: 25,
                child: Icon(
                  Icons.arrow_forward,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            ),
          ),
          if (showText)
            Expanded(
              child: Center(
                child: Shimmer.fromColors(
                  baseColor: Theme.of(context).primaryColor,
                  highlightColor: Colors.grey,
                  child: Text(
                    "Slide to interact",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          if (!showText)
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: DottedBorder(
                  borderType: BorderType.Circle,
                  color: Theme.of(context).primaryColor,
                  dashPattern: const [6, 3, 6, 3],
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    width: 50,
                    height: 50,
                    key: _slideKey,
                    margin: const EdgeInsets.only(right: 2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          style: BorderStyle.none),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
