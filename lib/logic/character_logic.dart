import 'package:handwriting/line_param.dart';
import 'package:handwriting/logic/sketch_page_logic.dart';

import '../assets/devanagri.dart';

class CharacterLogic {
  var i = 0;
  final List<Char> _characters = hindiSwars.map((e) => Char(e)).toList();

  get characters => _characters;

  Char get currentCharacter => _characters[i];

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

  void setStroke(List<DrawnLine> lineParam) {
    _characters[i].setStroke(lineParam);
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
}

class Char {
  final String _char;
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
