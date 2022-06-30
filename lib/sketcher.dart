import 'package:flutter/material.dart';

import 'line_param.dart';

class Sketcher extends CustomPainter {
  final List<DrawnLine> lines;

  Sketcher({required this.lines});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.grey.shade200
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    // draw grid lines 2 horizontal and 2 vertical
    double d;
    if (size.width > 400) {
      d = 150;
    } else {
      d = size.width / 4;
    }
    drawGrid(d, size, canvas, paint);

    // Rect r = Rect.fromCenter(
    //     center: Offset(size.width / 2, size.height / 2),
    //     width: size.width / 2,
    //     height: size.height / 2);

    // canvas.drawRect(r, paint);

    for (int i = 0; i < lines.length; ++i) {
      // if current line.length < 6 make a circle
      if (lines[i].path.length < 6) {
        paint.color = lines[i].color;
        paint.strokeWidth = lines[i].width;
        canvas.drawCircle(lines[i].path.first, 3, paint);
      }

      for (int j = 0; j < lines[i].path.length - 1; ++j) {
        paint.color = lines[i].color;
        paint.strokeWidth = lines[i].width;
        canvas.drawLine(lines[i].path[j], lines[i].path[j + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(Sketcher oldDelegate) {
    return true;
  }
}

void drawGrid(double d, Size size, Canvas canvas, Paint paint) {
  paint.color = Colors.grey.shade200;
  paint.strokeCap = StrokeCap.round;
  paint.strokeWidth = 2.0;

  // draw a line in center height
  // draw a line in center width

  canvas.drawLine(
      Offset(size.width / 2, 0), Offset(size.width / 2, size.height), paint);

  double y1 = d;
  while (y1 <= size.width / 2) {
    // draw line
    canvas.drawLine(Offset(size.width / 2 + y1, 0),
        Offset(size.width / 2 + y1, size.height), paint);
    y1 += d;
  }

  double y2 = d;
  while (size.width / 2 - y2 >= 0) {
    canvas.drawLine(Offset(size.width / 2 - y2, 0),
        Offset(size.width / 2 - y2, size.height), paint);

    y2 += d;
  }

  // make a horizontal centre line
  canvas.drawLine(
      Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);

  double x1 = d;
  while (x1 <= size.height / 2) {
    // draw line
    canvas.drawLine(Offset(0, size.height / 2 + x1),
        Offset(size.width, size.height / 2 + x1), paint);
    x1 += d;
  }

  double x2 = d;
  while (size.height / 2 - x2 >= 0) {
    canvas.drawLine(Offset(0, size.height / 2 - x2),
        Offset(size.width, size.height / 2 - x2), paint);

    x2 += d;
  }
}
