import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        Positioned(
          bottom: 16,
          left: 16,
          child: Container(
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        // add lines to undo stack

                        _lines.clear();
                      });
                    },
                    child: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    child: const Icon(
                      Icons.undo,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _lines.removeLast();

                        // add lines to undo stack
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: TextButton(
            child: const Text(
              'Copy Path of Lines',
              style: TextStyle(fontSize: 20, color: Colors.blue),
            ),
            onPressed: () {
              // get path of lines into one array and two array separate by -1 -1
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
              Clipboard.setData(ClipboardData(text: updatedPath.toString()));
            },
          ),
        ),
      ],
    );
  }
}
