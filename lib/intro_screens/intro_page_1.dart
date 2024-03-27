import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// ignore: use_key_in_widget_constructors
class IntroPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[100],
      child: Center(
          child: LottieBuilder.asset(
        'animations/Animation - 1706586680050.json',
        // height: 100,
        reverse: true,
        repeat: true,
        fit: BoxFit.cover,
      )),
    );
  }
}
