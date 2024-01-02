import 'package:bin_packing_problem_resolver/models/entity/bin_packing/container_entity.dart';
import 'package:flutter/material.dart';

class ContainerPainter extends CustomPainter {
  final ContainerEntity container;
  final Paint containerPainter = Paint()
    ..strokeWidth = 1
    ..color = Color.fromARGB(255, 33, 32, 42)
    ..style = PaintingStyle.stroke;
  final Paint rectanglePainter = Paint()
    ..strokeWidth = 1
    ..color = Color.fromARGB(255, 63, 138, 192)
    ..style = PaintingStyle.fill;
  final Paint rectangleBorderPainter = Paint()
    ..strokeWidth = 1
    ..color = Color.fromARGB(255, 33, 32, 42)
    ..style = PaintingStyle.stroke;

  ContainerPainter(this.container);

  @override
  void paint(Canvas canvas, Size size) {
    for (var child in container.placedChildren) {
      final rectangle = Rect.fromPoints(
          Offset(child.x, size.height - child.topMostY),
          Offset(child.rightMostX, size.height - child.y));

      canvas.drawRect(rectangle, rectanglePainter);
      canvas.drawRect(rectangle, rectangleBorderPainter);

      final tp = TextPainter(
        text: TextSpan(
            text: child.name,
            style: TextStyle(
                color: Color.fromARGB(255, 33, 32, 42),
                fontSize:
                    (child.height > child.width ? child.width : child.height) *
                        0.4)),
        textDirection: TextDirection.ltr,
      );

      tp.layout(maxWidth: child.width);
      var point = Offset(
          rectangle.left + (rectangle.width / 2) - (tp.width / 2),
          rectangle.top + (rectangle.height / 2) - (tp.height / 2));
      tp.paint(canvas, point);
    }
    final rectangle = Rect.fromPoints(
        const Offset(0, 0), Offset(container.width, container.height));

    canvas.drawRect(rectangle, containerPainter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
