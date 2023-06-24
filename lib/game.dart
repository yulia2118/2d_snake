import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:snake_game/homepage.dart';
import 'control_panel.dart';
import 'direction.dart';
import 'piece.dart';

class GamePage extends StatefulWidget {
  const GamePage(
      {Key? key, required this.scoreDifficulty, required this.speedDifficulty})
      : super(key: key);
  final double speedDifficulty;
  final int scoreDifficulty;
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<Offset> positions = [];
  int length = 5;
  int step = 20;
  Direction direction = Direction.right;

  late Piece food;
  Offset? foodPosition;

  late double screenWidth;
  late double screenHeight;
  late int lowerBoundX, upperBoundX, lowerBoundY, upperBoundY;

  Timer? timer;
  double speed = 1;

  int score = 0;

  void draw() async {
    // generates a random position
    if (positions.isEmpty) {
      positions.add(getRandomPositionWithinRange());
    }
    // increase the length and update the position
    while (length > positions.length) {
      positions.add(positions[positions.length - 1]);
    }
    // creates the illusion of a moving snake
    for (var i = positions.length - 1; i > 0; i--) {
      positions[i] = positions[i - 1];
    }

    // moves the first piece to a new position
    positions[0] = await getNextPosition(positions[0]);
  }

  Direction getRandomDirection([DirectionType? type]) {
    if (type == DirectionType.horizontal) {
      bool random = Random().nextBool();
      if (random) {
        return Direction.right;
      } else {
        return Direction.left;
      }
    } else if (type == DirectionType.vertical) {
      bool random = Random().nextBool();
      if (random) {
        return Direction.up;
      } else {
        return Direction.down;
      }
    } else {
      int random = Random().nextInt(4);
      return Direction.values[random];
    }
  }

  Offset getRandomPositionWithinRange() {
    int posX = Random().nextInt(upperBoundX) + lowerBoundX;
    int posY = Random().nextInt(upperBoundY) + lowerBoundY;
    return Offset(roundToNearestTens(posX).toDouble(),
        roundToNearestTens(posY).toDouble());
  }

//checks if the snake has reached any of the four boundaries. If it has, then it returns true, otherwise, it returns false.
  bool detectCollision(Offset position) {

    if (position.dx >= upperBoundX && direction == Direction.right) {
      return true;
    } else if (position.dx <= lowerBoundX && direction == Direction.left) {
      return true;
    } else if (position.dy >= upperBoundY && direction == Direction.down) {
      return true;
    } else if (position.dy <= lowerBoundY && direction == Direction.up) {
      return true;
    }

    return false;
  }


  void showGameOverDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.red,
          shape: const RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.black,
                width: 3.0,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Game Over",
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            "Your game is over but you played well. Your score is " +
                score.toString() +
                ".",
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                restart();
              },
              child: const Text(
                "Restart",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              child: const Text(
                "Home",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

//creates a new position for the snake based on the snake's current position,
  Future<Offset> getNextPosition(Offset position) async {
    Offset? nextPosition;
    if (detectCollision(position) == true) {
      if (timer != null && timer!.isActive) timer!.cancel();
      await Future.delayed(
          const Duration(milliseconds: 500), () => showGameOverDialog());
      return position;
    }

// increase the value of x-coordinates if the direction is set right decrases if th edirection if left
    if (direction == Direction.right) {
      nextPosition = Offset(position.dx + step, position.dy);
    } else if (direction == Direction.left) {
      nextPosition = Offset(position.dx - step, position.dy);
    }
    // increase the value of y-coordinates if the direction is set up decrases if th edirection if  down

    else if (direction == Direction.up) {
      nextPosition = Offset(position.dx, position.dy - step);
    } else if (direction == Direction.down) {
      nextPosition = Offset(position.dx, position.dy + step);
    }

    return nextPosition!;
  }

  void drawFood() {
    // creates a piece and stores it inside food
    foodPosition ??= getRandomPositionWithinRange();

    //checks if you the position you stored in foodPosition and the position of the snake’s first Piece widget are the same.
    // If they match, you increase length by 1, speed by 0.25 and score by 1.
    if (foodPosition == positions[0]) {
      length++;
      speed = speed + widget.speedDifficulty;
      score = score + widget.scoreDifficulty;
      changeSpeed();

      foodPosition = getRandomPositionWithinRange();
    }

    // stores it inside an offset object
    food = Piece(
      posX: foodPosition!.dx.toInt(),
      posY: foodPosition!.dy.toInt(),
      size: step,
      color: Colors.deepPurpleAccent,
      isAnimated: true,
    );
  }

  List<Piece> getPieces() {
    final pieces = <Piece>[];
    draw();
    drawFood();
    // Covers the entire length of the snake
    for (var i = 0; i < length; i++) {
      // handles an edge case when thee length of the snake does not match the length of the position
      if (i >= positions.length) {
        continue;
      } // each iteration creates a piece with the accuret position and adds it to the list
      pieces.add(
        Piece(
          posX: positions[i].dx.toInt(),
          posY: positions[i].dy.toInt(),
          //ensures the snake moves along the grid
          size: step,
          color: Colors.blue,
          borderColr: Colors.blueAccent,
        ),
      );
    }
    return pieces;
  }

  Widget getControls() {
    return ControlPanel(
      // 4 buttons to control snake movement
      onTapped: (Direction newDirection) {
        // recieves the direction of the snake movemnts
        direction = newDirection; // to change the direction of the snake
      },
    );
  }

  int roundToNearestTens(int num) {
    int divisor = step;
    int output = (num ~/ divisor) * divisor;
    if (output == 0) {
      output += step;
    }
    return output;
  }

// resets the timer with a duration that factors in speed you control speed and increase it every time the snake eats
  void changeSpeed() {
    if (timer != null && timer!.isActive) timer!.cancel();

    timer = Timer.periodic(Duration(milliseconds: 200 ~/ speed), (timer) {
      setState(() {});
    });
  }

  Widget getScore() {
    return Positioned(
      top: 50.0,
      right: 40.0,
      child: Text(
        "Score: " + score.toString(),
        style: const TextStyle(fontSize: 24.0, color: Colors.white),
      ),
    );
  }

  void restart() {
    score = 0;
    length = 5;
    positions = [];
    direction = getRandomDirection();
    speed = 1;
    changeSpeed();
  }

  Widget getPlayAreaBorder() {
    return Positioned(
      top: lowerBoundY.toDouble(),
      left: lowerBoundX.toDouble(),
      child: Container(
        width: (upperBoundX - lowerBoundX + step).toDouble(),
        height: (upperBoundY - lowerBoundY + step).toDouble(),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.red.withOpacity(0.5),
            style: BorderStyle.solid,
            width: 2.0,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    restart();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    lowerBoundX = step;
    lowerBoundY = step;
    upperBoundX = roundToNearestTens(screenWidth.toInt() - step);
    upperBoundY = roundToNearestTens(screenHeight.toInt() - step);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0XFF000000),
        ),
        child: Stack(
          children: [
            getPlayAreaBorder(),
            Stack(
              children: getPieces(),
            ),
            getControls(),
            food,
            getScore(),
          ],
        ),
      ),
    );
  }
}
