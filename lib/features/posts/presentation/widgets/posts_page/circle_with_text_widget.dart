import 'package:flutter/material.dart';

class CircleWithText extends StatelessWidget {
  final String text;
  final double radius;

  const CircleWithText({Key? key, required this.text, required this.radius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey, // Change to your preferred color
      ),
      child: Center(
        child: Text(
          text,
        ),
      ),
    );
  }
}