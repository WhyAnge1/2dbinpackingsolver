import 'package:flutter/material.dart';

class SelectablePageItemViewEntity {
  final String title;
  final IconData icon;
  final Widget page;
  Function? onTap;
  bool isSelected = false;

  SelectablePageItemViewEntity({
    required this.title,
    required this.icon,
    required this.page,
  });
}
