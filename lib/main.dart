import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
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
  // 游戏状态，0为初次进入游戏，1为游戏进行中，2为游戏结束
  int gameState = 0;

  void _gameStart() {
    setState(() {
      widget.data.start();
    });
  }

  void _gameOver() {
    setState(() {
      widget.data.end();
    });
  }

  void _onBtnTap() {
    if (gameState == 0) {
      gameState = 1;
      _gameStart();
      return;
    }
    if (gameState == 1) {
      gameState = 2;
      _gameOver();
      return;
    }
    if (gameState == 2) {
      gameState = 1;
      _gameStart();
      return;
    }
  }

  void _onScoreChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final String gameStart = AppLocalizations.of(context)!.startGame;
    final String gameRestart = AppLocalizations.of(context)!.restartGame;
    final String gameEnd = AppLocalizations.of(context)!.endGame;
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
              width: width,
              height: 48,
              child: Stack(
                children: [
                  if (gameState == 1) ...[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '$scoreText: ${widget.data.score}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: TimerText(
                              secondCount: 120,
                              onTickEnd: () {
                                gameState = 2;
                                _gameOver();
                              },
                            ),
                          ),
                          TextButton(
                            onPressed: () => _onBtnTap(),
                            child: Text(gameEnd),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                if (gameState != 1) ...[
                  DecoratedBox(
                    decoration: BoxDecoration(
                        color: const Color(0x80FFFFFF),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black54,
                              offset: Offset(2.0, 2.0),
                              blurRadius: 16.0),
                        ]),
                    child: SizedBox(
                      width: 300,
                      height: 400,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (gameState == 2) ...[
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                '本局分数',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            Text(
                              '${widget.data.score}',
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                          ],
                          const Padding(padding: EdgeInsets.all(24)),
                          TextButton(
                            onPressed: () => _onBtnTap(),
                            style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(
                                    const Size(200, 54))),
                            child: Text(
                              gameState == 0 ? gameStart : gameRestart,
                              style: const TextStyle(
                                fontSize: 24,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              '$highestScoreText: ${widget.data.highestScore}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}
