import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/line_provider.dart';
import 'sketch.dart';

void main() => runApp(const MyHomePage());

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Lines>(
          create: (_) => Lines(),
        ),
      ],
      child: MaterialApp(
        routes: {
          '/': (context) => const SketchPage(),
        },
      ),
    );
  }
}
