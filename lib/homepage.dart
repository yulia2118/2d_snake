import 'package:flutter/material.dart';
import 'package:snake_game/game.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'The Snake Game',
                style: TextStyle(fontSize: 30, color: Colors.blue[50]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                'Choose a Mode:',
                style: TextStyle(fontSize: 24, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              Button(
                shade: 400,
                text: 'Easy',
                speed: 0.25,
                score: 5,
              ),
              Button(
                shade: 600,
                text: 'Medium',
                speed: 0.45,
                score: 3,
              ),
              Button(
                shade: 800,
                text: 'Hard',
                speed: 0.65,
                score: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Button extends StatelessWidget {
  Button({
    Key? key,
    required this.text,
    required this.shade,
    required this.speed,
    required this.score,
  }) : super(key: key);
  String text;
  int shade;
  double speed;
  int score;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GamePage(
                      scoreDifficulty: score,
                      speedDifficulty: speed,
                    ))),
        child: Text(text),
        style: ElevatedButton.styleFrom(
            fixedSize: const Size(150, 60),
            primary: Colors.purple[shade],
            textStyle:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
