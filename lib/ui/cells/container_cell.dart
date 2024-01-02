import 'package:bin_packing_problem_resolver/models/entity/bin_packing/container_entity.dart';
import 'package:bin_packing_problem_resolver/ui/controls/container_painter.dart';
import 'package:flutter/material.dart';

class ContainerCell extends StatelessWidget {
  final ContainerEntity model;

  const ContainerCell({required this.model, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: ContainerPainter(model),
      size: Size(model.height.toDouble(), model.width.toDouble()),
      child: SizedBox(
        width: model.width.toDouble(),
        height: model.height.toDouble(),
      ),
    );
  }
}
