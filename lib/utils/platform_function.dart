import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

void runFunction(Function ifAndroidWebOrIos, Function ifSomethingElse) {
  if (Platform.isAndroid || Platform.isIOS || kIsWeb) {
    ifAndroidWebOrIos();
  } else {
    ifSomethingElse();
  }
}
