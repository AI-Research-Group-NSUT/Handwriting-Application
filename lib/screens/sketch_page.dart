import 'package:flutter/material.dart';
import 'package:handwriting/logic/character_logic.dart';
import 'package:handwriting/logic/sketch_page_logic.dart';
import 'package:handwriting/sketch.dart';

class SketchPage extends StatefulWidget {
  const SketchPage({Key? key}) : super(key: key);

  @override
  State<SketchPage> createState() => _SketchPageState();
}

class _SketchPageState extends State<SketchPage> {
  final logic = SketchPageLogic();
  final characterLogic = CharacterLogic();

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
          child: Row(
            children: [
              TextButton(
                child: const Text(
                  'Previous',
                  style: TextStyle(fontSize: 20, color: Colors.blue),
                ),
                onPressed: () {
                  setState(() {
                    characterLogic.previous();
                    characterLogic.currentCharacter.clearStroke();
                  });
                },
              ),
              TextButton(
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 20, color: Colors.blue),
                ),
                onPressed: () {
                  setState(() {
                    characterLogic.currentCharacter.setStroke(logic.lines);
                    logic.clear();
                    characterLogic.next();
                  });
                },
              ),
            ],
          ),
        ),
        Positioned(
          right: 16,
          top: 16,
          width: 40,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.blue.shade200,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    characterLogic.characters.map<Widget>((Char character) {
                  if (character.stroke.isEmpty) {
                    return const Text(
                      '.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        decoration: TextDecoration.none,
                      ),
                    );
                  }
                  return const Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 15,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        Positioned(
          top: 16,
          left: 16,
          child: Container(
            color: Colors.blue,
            width: 55,
            height: 55,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  characterLogic.currentCharacter.char,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
