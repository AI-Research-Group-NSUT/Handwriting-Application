import 'package:flutter/material.dart';
import 'package:handwriting/screens/sketch_page.dart';
import 'package:provider/provider.dart';

import 'providers/line_provider.dart';
import 'screens/home_page.dart';

void main() => runApp(const MyHomePage());

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider<Lines>(
          create: (_) => Lines(),
        ),
      ],
      child: MaterialApp(
        routes: {
          '/': (context) => const StartPage(),
          'sketch': (context) => const SketchPage()
        },
      ),
    );
  }
}
