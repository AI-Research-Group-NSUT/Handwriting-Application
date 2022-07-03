import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:handwriting/logic/character_logic.dart';
import 'package:handwriting/logic/post_logic.dart';
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
  final httpPostLogic = HTTPPostLogic();
  bool isVisible = false;
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
    return Scaffold(
      body: Stack(
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
                      // save stroke to current stroke
                      characterLogic.setStroke(logic.lines);
                      characterLogic.previous();
                      logic.setStroke(characterLogic.currentCharacter.stroke);
                    });
                  },
                ),
                if (characterLogic.isNextPresent())
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
                        logic.setStroke(characterLogic.currentCharacter.stroke);
                      });
                    },
                  )
                else
                  TextButton(
                    child: const Text(
                      'Done',
                      style: TextStyle(fontSize: 20, color: Colors.blue),
                    ),
                    onPressed: () async {
                      setState(() {
                        // save the stroke
                        characterLogic.currentCharacter.setStroke(logic.lines);
                      });

                      final req = characterLogic.reqObject(
                        MediaQuery.of(context).size.height,
                        MediaQuery.of(context).size.width,
                      );
                      // while not done show spinning indicator
                      setState(() {
                        isVisible = true;
                      });
                      httpPostLogic.postData(req).then((res) {
                        final Map parsed = json.decode(res.body);
                        if (res.statusCode == 200 && parsed['success']) {
                          Navigator.pop(context);
                          setState(() {
                            isVisible = false;
                            logic.clear();
                            characterLogic.clear();
                          });
                          print('done');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Something went wrong :('),
                            ),
                          );
                          setState(() {
                            isVisible = false;
                          });
                        }
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Something went wrong :('),
                          ),
                        );
                        setState(() {
                          isVisible = false;
                        });
                      });
                    },
                  )
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Visibility(
              visible: isVisible,
              child: CircularProgressIndicator(color: Colors.blue),
            ),
          ),
          Positioned(
            right: 16,
            top: 16,
            height: 40,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.blue,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:
                      characterLogic.characters.map<Widget>((Char character) {
                    if (character.stroke.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Icon(
                          Icons.circle,
                          color: (characterLogic.currentCharacter.char ==
                                  character.char)
                              ? Colors.yellow.shade800
                              : Colors.white,
                          size: 10,
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Icon(
                        Icons.circle,
                        color: Colors.green.shade400,
                        size: 10,
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
      ),
    );
  }
}
