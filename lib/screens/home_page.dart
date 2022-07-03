import 'package:flutter/material.dart';

import '/logic/get_logic.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final _getLogic = HTTPGetLogic();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Sketch',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isLoading = true;
                    });

                    // get data from server
                    _getLogic.getData().then((characterData) {
                      setState(() {
                        isLoading = false;
                      });

                      if (characterData != null) {
                        // push a new route 'sketch'
                        Navigator.pushNamed(
                          context,
                          'sketch',
                          arguments: characterData,
                        );
                      } else {
                        // show an error message
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Error'),
                            content:
                                const Text('Failed to get data from server'),
                            actions: [
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        );
                      }
                    });
                  },
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                          semanticsLabel: 'Loading...',
                        )
                      : const Text('Draw', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
