import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// ignore: use_key_in_widget_constructors
class IntroPage3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.blue[100],
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomRight,
          colors: [Colors.black.withOpacity(.9), Colors.black.withOpacity(.4)],
        ),
      ),
      child: Center(
          child: LottieBuilder.asset(
        'animations/Animation - 1706586854571.json',
        height: 200,
        reverse: true,
        repeat: true,
        fit: BoxFit.cover,
      )),
    );
  }
}
