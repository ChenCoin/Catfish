import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'data/grid_data.dart';
import 'view/black_board.dart';
import 'view/count_down.dart';
import 'view/game_board.dart';

void main() {
  final data = GridData();
  data.init();
  runApp(MyApp(data: data));
}

class MyApp extends StatelessWidget {
  final GridData data;

  const MyApp({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff8A9CA0)),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page', data: data),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final GridData data;

  final String title;

  const MyHomePage({super.key, required this.title, required this.data});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static String gameStart = 'Start';

  static String gameEnd = 'End';

  String btnText = gameStart;

  // 游戏状态，true为进行中，false为空闲中
  bool gameState = false;

  void _gameStart() {
    setState(() {
      widget.data.start();
      btnText = gameEnd;
    });
  }

  void _gameOver() {
    setState(() {
      widget.data.end();
      btnText = gameStart;
    });
  }

  void _onBtnTap() {
    gameState = !gameState;
    if (gameState) {
      _gameStart();
    } else {
      _gameOver();
    }
  }

  void _onScoreChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    // 宽度为屏幕宽度 - 40，特殊适配大屏
    final double width = min(screenSize.width - 32, 400);
    double height = width / 10 * 16;
    var scoreText = AppLocalizations.of(context)!.score;
    var highestScoreText = AppLocalizations.of(context)!.highestScore;
    return Scaffold(
      backgroundColor: const Color(0xff8A9CA0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: width - 20,
              height: 64,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '$scoreText: ${widget.data.score}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '$highestScoreText: ${widget.data.highestScore}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  if (gameState) ...[
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: TimerText(
                          secondCount: 120,
                          onTickEnd: () {
                            gameState = false;
                            _gameOver();
                          },
                        ),
                      ),
                    )
                  ]
                ],
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                RepaintBoundary(
                    child: BlackBoard(size: Size(width + 20, height + 20))),
                SizedBox(
                  width: width,
                  height: height,
                  child: GameBoard(
                    size: Size(width, height),
                    callback: _onScoreChanged,
                    data: widget.data,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () => _onBtnTap(),
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(200, 54))),
              child: Text(
                btnText,
                style: const TextStyle(
                  fontSize: 24,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
