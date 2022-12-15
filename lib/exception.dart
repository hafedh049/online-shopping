import 'package:blue_diamond/methods_and_variables/methods.dart';
import 'package:blue_diamond/methods_and_variables/variables.dart';
import 'package:flutter/material.dart';

class FlutterException extends StatelessWidget {
  const FlutterException({super.key, required this.exception});
  final String exception;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: const DecorationImage(
          image: AssetImage("assets/bg.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      width: dynamicView(context)[0] * .6,
      height: dynamicView(context)[1] * .8,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            runSpacing: 5,
            children: exception
                .split(RegExp(r"\[.+\] "))
                .map((String text) => textWriter("$text ", 25, white))
                .toList(),
          ),
        ),
      ),
    );
  }
}
