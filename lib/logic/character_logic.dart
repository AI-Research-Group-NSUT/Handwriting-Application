import 'package:flutter/material.dart';
import 'package:handwriting/line_param.dart';
import 'package:handwriting/logic/sketch_page_logic.dart';

class CharacterLogic {
  var i = 0;
  final List<Char> _characters = [];
  final _strokePresentColor = Colors.green.shade400;
  final _strokeAbsentColor = Colors.grey.shade400;
  final _currentStroke = Colors.yellow.shade800;

  get characters => _characters;

  Char get currentCharacter => _characters[i];

  currentCharColor(Char char) {
    if (currentCharacter.char == char.char) {
      return _currentStroke;
    } else {
      if (char.stroke.isEmpty) {
        return _strokeAbsentColor;
      } else {
        return _strokePresentColor;
      }
    }
  }

  setCharacters(List<dynamic> characters) {
    _characters.clear();

    for (var e in characters) {
      _characters.add(Char(e));
    }
  }

  setCurrentCharacter(Char c) {
    // find index of c and set it as i
    int i = _characters.indexOf(c);
    this.i = i;
  }

  void next() {
    if (i + 1 >= _characters.length) {
      return;
    }
    i++;
  }

  void previous() {
    if (i <= 0) {
      return;
    }
    i--;
  }

  void clear() {
    _characters[i].clearStroke();
  }

  void clearAll() {
    for (var e in _characters) {
      e.clearStroke();
    }

    i = 0;
  }

  void setStroke(List<DrawnLine> lineParam) {
    _characters[i].setStroke(lineParam);
  }

  int emptyFromStart() {
    for (int i = 0; i < _characters.length; i++) {
      if (_characters[i].stroke.isEmpty) {
        return i;
      }
    }

    return -1;
  }

  bool isNextPresent() {
    return i + 1 < _characters.length;
  }

  Map<String, List<List<double>>> allStrokes() {
    final charAndStroke = <String, List<List<double>>>{};

    for (int i = 0; i < _characters.length; ++i) {
      charAndStroke[_characters[i].char] =
          SketchPageLogic.linesToPath(_characters[i].stroke);
    }

    return charAndStroke;
  }

  Map<String, dynamic> reqObject(
      double screenHeight, double screenWidth, index) {
    final strokes = allStrokes();

    final reqObj = {
      'strokes': strokes,
      'screenHeight': screenHeight,
      'screenWidth': screenWidth,
      'index': index,
    };

    return reqObj;
  }
}

class Char {
  final dynamic _char;
  List<DrawnLine> stroke = <DrawnLine>[];

  Char(this._char);

  get char => _char;

  void setStroke(List<DrawnLine> value) {
    stroke = List.from(value);
  }

  void clearStroke() {
    stroke = <DrawnLine>[];
  }
}
