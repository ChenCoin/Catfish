import 'dart:math';

import 'package:flutter/material.dart';
import 'data/GridData.dart';
import 'view/black_board.dart';
import 'view/draw_board.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const String gameStart = 'Start';

  static const String gameEnd = 'End';

  final GridData data = GridData();

  String btnText = gameStart;

  // 游戏状态，true为进行中，false为空闲中
  bool gameState = false;

  void _onBtnTap() {
    setState(() {
      gameState = !gameState;
      if (gameState) {
        data.start();
        btnText = gameEnd;
      } else {
        data.end();
        btnText = gameStart;
      }
    });
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
                      'SCORE: ${data.score}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'HighestScore: ${data.highestScore}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
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
                    data: data,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () => _onBtnTap(),
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(120, 48))),
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
