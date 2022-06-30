import 'dart:ui';

import 'package:handwriting/line_param.dart';

class SketchPageLogic {
  final List<DrawnLine> _lines = [];

  void addNewLine(Offset point) {
    final line = DrawnLine.defaultLine([point]);
    _lines.add(line);
  }

  void addToCurrentLine(Offset point) {
    _lines.last.path.add(point);
  }

  void clear() {
    _lines.clear();
  }

  List<DrawnLine> get lines => _lines;

  void undo() {
    if (_lines.isNotEmpty) {
      _lines.removeLast();
    }
  }

  List<List<double>> linesToPath() {
    final path = _lines.map((line) => line.path).toList();

    List<List<double>> updatedPath = [];

    for (int i = 0; i < path.length; ++i) {
      for (int j = 0; j < path[i].length; ++j) {
        final addendum = [path[i][j].dx, path[i][j].dy];
        updatedPath.add(addendum);
      }
      updatedPath.add([-1, -1]);
    }

    // copy path to clipboard
    return updatedPath;
  }
}
