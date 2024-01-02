import 'dart:math';

import 'package:flutter/material.dart';

class GeneratedRectangle extends StatelessWidget {
  final double rectangleWidth;
  final double rectangleHeight;
  final double maxHeight;
  final String rectangleName;

  const GeneratedRectangle(
      {super.key,
      required this.rectangleName,
      required this.rectangleWidth,
      required this.rectangleHeight,
      required this.maxHeight});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      verticalOffset: 50,
      message:
          "Rectangle: $rectangleName\nWidth: $rectangleWidth\nHeight: $rectangleHeight",
      child: Container(
        alignment: Alignment.bottomLeft,
        height: maxHeight,
        width: rectangleWidth,
        child: Container(
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 63, 138, 192),
              border: Border.all(color: Colors.blueGrey)),
          width: rectangleWidth,
          height: rectangleHeight,
          child: Center(
            child: Text(
              rectangleName,
              style: TextStyle(
                  fontSize: min(rectangleHeight, rectangleWidth) * 0.4),
            ),
          ),
        ),
      ),
    );
  }
}
