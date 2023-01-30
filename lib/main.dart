import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lets_chat/features/home/home.dart';
import 'package:lets_chat/features/onboarding/onboarding.dart';
import 'package:lets_chat/shared/design_system/lightTheme/light_theme.dart';
import 'package:lets_chat/shared/route_config.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  runApp(const Iris());
}

class Iris extends StatelessWidget {
  const Iris({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        title: 'Iris',
        debugShowCheckedModeBanner: false,
        theme: lightThemeData,
        routerConfig: router,
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  SharedPreferences? pref;
  bool? onboarded;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      pref = await SharedPreferences.getInstance();
      if (pref!.getBool("onboarded") != null) {
        setState(() {
          onboarded = true;
        });
      } else {
        setState(() {
          onboarded = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (onboarded == null) {
      return Material(
        child: Lottie.asset('lib/resources/assets/lottie/typing.json'),
      );
    }

    return !onboarded! ? const Onboarding() : const Home();
  }
}
