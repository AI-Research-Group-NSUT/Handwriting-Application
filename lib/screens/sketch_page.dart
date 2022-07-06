import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:handwriting/logic/character_logic.dart';
import 'package:handwriting/logic/get_logic.dart';
import 'package:handwriting/logic/post_logic.dart';
import 'package:handwriting/logic/sketch_page_logic.dart';
import 'package:handwriting/sketch.dart';
import 'package:handwriting/utils/platform_function.dart';

class SketchPage extends StatefulWidget {
  const SketchPage({Key? key}) : super(key: key);

  @override
  State<SketchPage> createState() => _SketchPageState();
}

class _SketchPageState extends State<SketchPage> {
  final logic = SketchPageLogic();
  final characterLogic = CharacterLogic();
  final httpPostLogic = HTTPPostLogic();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _argumentSet = false;

  int _index = -1;

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

  void _handleDone() {
    logic.disable();

    setState(() {
      // save the stroke
      characterLogic.currentCharacter.setStroke(logic.lines);
    });

    if (characterLogic.emptyFromStart() != -1) {
      setState(() {
        characterLogic.setStroke(logic.lines);

        characterLogic.setCurrentCharacter(
          characterLogic.characters[characterLogic.emptyFromStart()],
        );

        logic.clear();
      });

      runFunction(() {
        Fluttertoast.showToast(
            msg: "Please draw all the characters",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.yellow.shade900,
            textColor: Colors.white,
            fontSize: 16.0);
      }, () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please draw all the characters'),
          ),
        );
      });

      logic.enable();

      return;
    }

    final req = characterLogic.reqObject(MediaQuery.of(context).size.height,
        MediaQuery.of(context).size.width, _index);
    // while not done show spinning indicator
    setState(() {
      isVisible = true;
    });

    final res = httpPostLogic.postData(req);

    res.then((wasSuccessful) {
      if (wasSuccessful) {
        Navigator.pop(context);
        setState(() {
          isVisible = false;
          logic.clear();
          characterLogic.clear();
        });

        runFunction(() {
          Fluttertoast.showToast(
              msg: "Successfully Posted",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
        }, () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Successfully Posted'),
            ),
          );
        });
      } else {
        // add a toast
        runFunction(() {
          Fluttertoast.showToast(
              msg: "Something went wrong :(",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }, () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Something went wrong :('),
            ),
          );
        });

        logic.enable();

        setState(() {
          isVisible = false;
        });
      }
    });
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  @override
  void initState() {
    _scaffoldKey.currentState?.openEndDrawer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!_argumentSet) {
      final args =
          ModalRoute.of(context)?.settings.arguments as CharacterResponse;
      characterLogic.setCharacters(args.data);
      _index = args.index;
      _argumentSet = true;
    }

    return Scaffold(
      key: _scaffoldKey,

      // app drawer
      endDrawer: Drawer(
        width: 100,
        backgroundColor: Colors.white,
        child: ListView(
          children: characterLogic.characters
              .map<Widget>((character) => GestureDetector(
                    onTap: () {
                      setState(() {
                        characterLogic.setStroke(logic.lines);
                        characterLogic.setCurrentCharacter(character);
                        logic.setStroke(characterLogic.currentCharacter.stroke);
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 100,
                      color: characterLogic.currentCharColor(character),
                      child: Center(
                        child: Text(
                          character.char,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
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
                ElevatedButton(
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Previous',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
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
                const SizedBox(
                  width: 16,
                ),
                if (characterLogic.isNextPresent())
                  ElevatedButton(
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Next',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
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
                  ElevatedButton(
                    onPressed: _handleDone,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Done',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  )
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Visibility(
              visible: isVisible,
              child: const CircularProgressIndicator(color: Colors.blue),
            ),
          ),
          Positioned(
            right: 16,
            top: 16,
            height: 40,
            child: GestureDetector(
              onTap: _openDrawer,
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
                      return Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Icon(
                          Icons.circle,
                          color: characterLogic.currentCharColor(character),
                          size: 10,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              color: Colors.blue,
              width: 100,
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
