import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/line_provider.dart';
import 'sketcher.dart';

class SketchPage extends StatelessWidget {
  const SketchPage({Key? key}) : super(key: key);

  void _handlePanStart(DragStartDetails details, BuildContext context) {
    // get point of touch
    final box = context.findRenderObject() as RenderBox;
    final point = box.globalToLocal(details.localPosition);

    // add new line
    context.read<Lines>().newLine(point);
  }

  void _handlePanUpdate(DragUpdateDetails details, BuildContext context) {
    // get point of touch
    final box = context.findRenderObject() as RenderBox;
    final point = box.globalToLocal(details.localPosition);

    // add point to current line
    context.read<Lines>().addPointToCurrentLine(point);
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
          painter: Sketcher(lines: context.read<Lines>().points),
        ),
      ),
    );
  }
}
