import 'package:flutter/material.dart';
import 'package:handwriting/line_param.dart';

import 'sketcher.dart';

class SketchCanvas extends StatelessWidget {
  final List<DrawnLine> lines;
  final Function addNewLine;
  final Function addToCurrentLine;

  const SketchCanvas({
    Key? key,
    required this.lines,
    required this.addNewLine,
    required this.addToCurrentLine,
  }) : super(key: key);

  void _handlePanStart(DragStartDetails details, BuildContext context) {
    // get point of touch
    final box = context.findRenderObject() as RenderBox;
    final point = box.globalToLocal(details.localPosition);

    // add new line
    addNewLine(point);
  }

  void _handlePanUpdate(DragUpdateDetails details, BuildContext context) {
    // get point of touch
    final box = context.findRenderObject() as RenderBox;
    final point = box.globalToLocal(details.localPosition);

    // add point to current line
    addToCurrentLine(point);
  }

  void _handlePanEnd(DragEndDetails details, BuildContext context) {
    // clear points
    // setState(() {
    //   _points.clear();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (_) => _handlePanStart(_, context),
      onPanUpdate: (_) => _handlePanUpdate(_, context),
      onPanEnd: (_) => _handlePanEnd(_, context),
      child: Container(
        // set to device width and height
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.transparent,

        child: CustomPaint(
          painter: Sketcher(lines: lines),
        ),
      ),
    );
  }
}
