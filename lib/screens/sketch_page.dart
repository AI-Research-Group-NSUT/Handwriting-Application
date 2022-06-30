import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:handwriting/logic/sketch_page_logic.dart';
import 'package:handwriting/sketch.dart';

class SketchPage extends StatefulWidget {
  const SketchPage({Key? key}) : super(key: key);

  @override
  State<SketchPage> createState() => _SketchPageState();
}

class _SketchPageState extends State<SketchPage> {
  final logic = SketchPageLogic();

  void _addNewLine(Offset point) {
    setState(() {
      logic.addNewLine(point);
    });
  }

  void _addToCurrentLine(Offset point) {
    setState(() {
      logic.addToCurrentLine(point);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SketchCanvas(
          lines: logic.lines,
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
                        logic.clear();
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
                        logic.undo();
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
              Clipboard.setData(
                ClipboardData(
                  text: logic.linesToPath().toString(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
