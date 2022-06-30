import 'package:handwriting/line_param.dart';

import '../assets/devanagri.dart';

class CharacterLogic {
  var i = 0;
  final List<Char> _characters = hindiSwars.map((e) => Char(e)).toList();

  get characters => _characters;

  Char get currentCharacter => _characters[i];

  void next() {
    i++;
    if (i >= _characters.length) {
      i = 0;
    }
  }

  void previous() {
    i--;
    if (i < 0) {
      i = _characters.length - 1;
    }
  }

  void clear() {
    _characters[i].clearStroke();
  }

  void setStroke(List<DrawnLine> lineParam) {
    _characters[i].setStroke(lineParam);
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
