import 'package:flutter/material.dart';
import 'package:tictactoe/board_tile.dart';
import 'package:tictactoe/tile_state.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final navigatorKey = GlobalKey<NavigatorState>();
  var _bordState = List.filled(9, TileState.EMPTY);

  var _currentTurn = TileState.CROSS;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Stack(children: [
            TextButton(
              onPressed: () => _resetGame(),
              child: Text('reset'),
            ),
            Image.asset('images/board.png'),
            _boardTile(),
          ]),
        ),
      ),
    );
  }

  Widget _boardTile() {
    return Builder(
      builder: (BuildContext context) {
        final boardDimension = MediaQuery.of(context).size.width;
        final tileDimension = boardDimension / 3;

        return Container(
          height: boardDimension,
          width: boardDimension,
          child: Column(
            children: chunk(_bordState, 3).asMap().entries.map((entry) {
              final chunkIndex = entry.key;
              final titleStateChunk = entry.value;

              return Row(
                children: titleStateChunk.asMap().entries.map((innerentry) {
                  final innerIndex = innerentry.key;
                  final tileState = innerentry.value;
                  final tileIndex = (chunkIndex * 3) + innerIndex;
                  return BoardTile(
                      dimension: tileDimension,
                      // ignore: avoid_print
                      onpressed: () => _updateTiileStateforIndex(tileIndex),
                      tileState: tileState);
                }).toList(),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _updateTiileStateforIndex(int selectedIndex) {
    if (_bordState[selectedIndex] == TileState.EMPTY) {
      setState(() {
        _bordState[selectedIndex] = _currentTurn;
        _currentTurn = _currentTurn == TileState.CROSS
            ? TileState.CIRCLE
            : TileState.CROSS;
      });

      final winner = _findWineer();
      if (winner != null) {
        print('winner is : $winner');
        _showWinnerDialog(winner);
      }
    }
  }

// function 2
  TileState? _findWineer() {
    winnerofthematch(a, b, c) {
      if (_bordState[a] != TileState.EMPTY) {
        if ((_bordState[a] == _bordState[b]) &&
            (_bordState[b] == _bordState[c])) {
          return _bordState[a];
        }
      }
    }

    final Checks = [
      winnerofthematch(0, 1, 2),
      winnerofthematch(3, 4, 5),
      winnerofthematch(6, 7, 8),
      winnerofthematch(0, 3, 6),
      winnerofthematch(1, 4, 7),
      winnerofthematch(2, 5, 8),
      winnerofthematch(0, 4, 8),
      winnerofthematch(2, 4, 6),
    ];

    TileState? winner;

    for (int i = 0; i < Checks.length; i++) {
      if (Checks[i] != null) {
        winner = Checks[i];
        break;
      }
    }
    return winner;
  }

  /// function for winner
  void _showWinnerDialog(TileState tileState) {
    final context = navigatorKey.currentState!.overlay!.context;
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Winner'),
            content: Image.asset(
                tileState == TileState.CROSS ? 'images/x.png' : 'images/o.png'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _resetGame();
                  },
                  child: Text('New Game'))
            ],
          );
        });
  }

  void _resetGame() {
    setState(() {
      _bordState = List.filled(9, TileState.EMPTY);
      var _currentTurn = TileState.CROSS;
    });
  }
}
