import 'package:flutter/material.dart';
import 'package:handwriting/line_param.dart';
import 'package:handwriting/sketch.dart';

class SketchPage extends StatefulWidget {
  const SketchPage({Key? key}) : super(key: key);

  @override
  State<SketchPage> createState() => _SketchPageState();
}

class _SketchPageState extends State<SketchPage> {
  final List<DrawnLine> _lines = [];

  void _addNewLine(Offset point) {
    setState(() {
      final line = DrawnLine.defaultLine([point]);
      _lines.add(line);
    });
  }

  void _addToCurrentLine(Offset point) {
    setState(() {
      _lines.last.path.add(point);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SketchCanvas(
          lines: _lines,
          addNewLine: _addNewLine,
          addToCurrentLine: _addToCurrentLine,
        ),
      ],
    );
  }
}
