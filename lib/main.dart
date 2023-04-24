import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const RandomNumber());
}

class RandomNumber extends StatelessWidget {
  const RandomNumber({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(title: 'Guess my number'),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textController = TextEditingController();

  int _randomNumber = Random().nextInt(101);
  List<int> guessList = <int>[];
  bool startReset = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text(widget.title))),
      body: Center(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(8.00),
              child: Text(
                "I'm thinking of a number between 1 and 100",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Text("It's your turn to guess my number"),
            Visibility(
                visible: guessList.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text(
                      guessList.isEmpty
                          ? 'Enter your first item'
                          : 'You tried ${guessList.last}\n ${startReset ? 'You guessed right' : 'Try something ${_randomNumber < guessList.last ? "lower" : "higher"}'}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      )),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: const BoxDecoration(color: Colors.white, boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 7,
                      offset: Offset(0, 6),
                    )
                  ]),
                  child: Column(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.fromLTRB(8.00, 16.00, 8.00, 8.00),
                        child: Text('Try a number',
                            style: TextStyle(
                              fontSize: 28,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.00, 0.00, 16.00, 16.00),
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            enabled: !startReset,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                            controller: _textController,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a number';
                              } else {
                                try {
                                  int.parse(value);
                                } catch (e) {
                                  if (RegExp(r'^\d+$').hasMatch(value)) {
                                    return 'The number provided is too big';
                                  }
                                  return 'Please enter a natural number!';
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 16.00),
                        child: ElevatedButton(
                          onPressed: () {
                            if (startReset == true) {
                              setState(() {
                                startReset = false;
                                guessList.clear();
                                _randomNumber = Random().nextInt(101);
                              });
                            } else if (_formKey.currentState!.validate()) {
                              setState(() {
                                guessList.add(int.parse(_textController.text));
                                if (_randomNumber == guessList.last) {
                                  startReset = true;
                                  final String lastValue = _textController.text;
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('You guessed right!'),
                                          content: Text('It was $lastValue'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('Try Again!'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('OK'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                  _textController.clear();
                                }
                              });
                            } else {}
                          },
                          child: Text(startReset ? 'Reset' : 'Guess Number', style: const TextStyle(fontSize: 14)),
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
