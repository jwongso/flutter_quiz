import 'dart:math';

import 'package:flutter/material.dart';
import './result.dart';
import './game_button.dart';

class HomePage extends StatefulWidget {
  final int totalScore;
  final Function resetQuiz;

  HomePage({@required this.totalScore, @required this.resetQuiz});

  @override
  _HomePageState createState() =>
      new _HomePageState(totalScore: totalScore, resetQuiz: resetQuiz);
}

class _HomePageState extends State<HomePage> {
  List<GameButton> buttonsList;
  var player1;
  var player2;
  var activePlayer;
  int totalScore;
  final Function resetQuiz;
  bool quit = false;

  _HomePageState({@required this.totalScore, @required this.resetQuiz});

  @override
  void initState() {
    super.initState();
    buttonsList = doInit();
  }

  List<GameButton> doInit() {
    player1 = new List();
    player2 = new List();
    activePlayer = 1;

    var gameButtons = <GameButton>[
      new GameButton(id: 1),
      new GameButton(id: 2),
      new GameButton(id: 3),
      new GameButton(id: 4),
      new GameButton(id: 5),
      new GameButton(id: 6),
      new GameButton(id: 7),
      new GameButton(id: 8),
      new GameButton(id: 9),
    ];
    return gameButtons;
  }

  void playGame(GameButton gb) {
    setState(() {
      if (activePlayer == 1) {
        gb.text = "X";
        gb.bg = Colors.red;
        activePlayer = 2;
        player1.add(gb.id);
      } else {
        gb.text = "0";
        gb.bg = Colors.black;
        activePlayer = 1;
        player2.add(gb.id);
      }
      gb.enabled = false;
      int winner = checkWinner();
      if (winner == -1) {
        if (buttonsList.every((p) => p.text != "")) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Game is done'),
                content: winner == 1
                    ? const Text('You won! Reset the game or quit?')
                    : const Text('App won! Reset the game or quit?'),
                actions: <Widget>[
                  FlatButton(
                      child: const Text('Reset'), onPressed: () => resetGame()),
                  FlatButton(
                    child: const Text('Quit'),
                    onPressed: () {
                      if (winner == 1) {
                        totalScore += 10;
                      }
                      quitGame();
                    },
                  )
                ],
              );
            },
          );
        } else {
          if (activePlayer == 2) {
            autoPlay();
          }
        }
      }
    });
  }

  void autoPlay() {
    var emptyCells = new List();
    var list = new List.generate(9, (i) => i + 1);
    for (var cellID in list) {
      if (!(player1.contains(cellID) || player2.contains(cellID))) {
        emptyCells.add(cellID);
      }
    }

    var r = new Random();
    var randIndex = r.nextInt(emptyCells.length - 1);
    var cellID = emptyCells[randIndex];
    int i = buttonsList.indexWhere((p) => p.id == cellID);
    playGame(buttonsList[i]);
  }

  void resetGame() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    setState(() {
      buttonsList = doInit();
    });
  }

  void quitGame() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    quit = true;
    setState(() {});
  }

  int checkWinner() {
    var winner = -1;
    if (player1.contains(1) && player1.contains(2) && player1.contains(3)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(2) && player2.contains(3)) {
      winner = 2;
    }

    // row 2
    if (player1.contains(4) && player1.contains(5) && player1.contains(6)) {
      winner = 1;
    }
    if (player2.contains(4) && player2.contains(5) && player2.contains(6)) {
      winner = 2;
    }

    // row 3
    if (player1.contains(7) && player1.contains(8) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(7) && player2.contains(8) && player2.contains(9)) {
      winner = 2;
    }

    // col 1
    if (player1.contains(1) && player1.contains(4) && player1.contains(7)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(4) && player2.contains(7)) {
      winner = 2;
    }

    // col 2
    if (player1.contains(2) && player1.contains(5) && player1.contains(8)) {
      winner = 1;
    }
    if (player2.contains(2) && player2.contains(5) && player2.contains(8)) {
      winner = 2;
    }

    // col 3
    if (player1.contains(3) && player1.contains(6) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(3) && player2.contains(6) && player2.contains(9)) {
      winner = 2;
    }

    //diagonal
    if (player1.contains(1) && player1.contains(5) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(5) && player2.contains(9)) {
      winner = 2;
    }

    if (player1.contains(3) && player1.contains(5) && player1.contains(7)) {
      winner = 1;
    }
    if (player2.contains(3) && player2.contains(5) && player2.contains(7)) {
      winner = 2;
    }

    if (winner != -1) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Game is done'),
            content: winner == 1
                ? const Text('You won! Reset the game or quit?')
                : const Text('App won! Reset the game or quit?'),
            actions: <Widget>[
              FlatButton(
                  child: const Text('Reset'), onPressed: () => resetGame()),
              FlatButton(
                child: const Text('Quit'),
                onPressed: () {
                  if (winner == 1) {
                    totalScore += 10;
                  }
                  quitGame();
                },
              )
            ],
          );
        },
      );
    }
    return winner;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: !quit
            ? new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  new Expanded(
                    child: new GridView.builder(
                      padding: const EdgeInsets.all(10.0),
                      gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1.0,
                              crossAxisSpacing: 9.0,
                              mainAxisSpacing: 9.0),
                      itemCount: buttonsList.length,
                      itemBuilder: (context, i) => new SizedBox(
                        width: 100.0,
                        height: 100.0,
                        child: new RaisedButton(
                          padding: const EdgeInsets.all(8.0),
                          onPressed: buttonsList[i].enabled
                              ? () => playGame(buttonsList[i])
                              : null,
                          child: new Text(
                            buttonsList[i].text,
                            style: new TextStyle(
                                color: Colors.white, fontSize: 20.0),
                          ),
                          color: buttonsList[i].bg,
                          disabledColor: buttonsList[i].bg,
                        ),
                      ),
                    ),
                  ),
                  new RaisedButton(
                    child: new Text(
                      "Reset",
                      style: new TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                    color: Colors.red,
                    padding: const EdgeInsets.all(20.0),
                    onPressed: resetGame,
                  )
                ],
              )
            : Result(totalScore, resetQuiz));
  }
}
