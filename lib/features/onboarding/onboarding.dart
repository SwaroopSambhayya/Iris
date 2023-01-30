import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lets_chat/features/onboarding/components/custom_slider.dart';
import 'package:lets_chat/shared/const.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  late CarouselController _controller;

  @override
  void initState() {
    _controller = CarouselController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CarouselSlider(
                carouselController: _controller,
                items: [
                  Image.asset(
                    '$imagePath/logo.png',
                    width: MediaQuery.of(context).size.width * 0.5,
                  ),
                  Lottie.asset('lib/resources/assets/lottie/mobile.json')
                ],
                options: CarouselOptions(
                  enableInfiniteScroll: false,
                  viewportFraction: 0.9,
                  aspectRatio: 1,
                  pauseAutoPlayInFiniteScroll: true,
                  autoPlay: true,
                  autoPlayAnimationDuration: const Duration(seconds: 1),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 30),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Iris",
                      style: TextStyle(
                          fontSize: 64,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "The interactive assistant!",
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    const Center(
                      child: CustomSlider(),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
