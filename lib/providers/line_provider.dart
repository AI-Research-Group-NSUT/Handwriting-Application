import 'package:flutter/material.dart';

import '../line_param.dart';

class Lines with ChangeNotifier {
  final List<DrawnLine> _points = [];

  List<DrawnLine> get points => _points;

  void newLine(Offset point) {
    print(point);
    _points.add(DrawnLine.defaultLine([point]));
    notifyListeners();
  }

  void addPointToCurrentLine(Offset point) {
    print(point);
    _points.last.path.add(point);
    notifyListeners();
  }

  void removeLine() {
    _points.removeLast();
    notifyListeners();
  }
}
