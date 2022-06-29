import 'package:flutter/material.dart';

class DrawnLine {
  final List<Offset> path;
  final Color color;
  final double width;

  DrawnLine(this.path, this.color, this.width);

  factory DrawnLine.defaultLine(List<Offset> path) {
    return DrawnLine(path, Colors.black, 5.0);
  }
}
