import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class GridData {
  static const int col = 10;

  static const int row = 16;

  List<List<int>> grids = [];

  int score = 0;

  int highestScore = 0;

  GridData() {
    for (int i = 0; i < row; i++) {
      List<int> list = [];
      for (int j = 0; j < col; j++) {
        list.add(0);
      }
      grids.add(list);
    }
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    highestScore = prefs.getInt('highestScore') ?? 0;
  }

  void start() {
    print('start');
    score = 0;
    var random = Random();
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < col; j++) {
        grids[i][j] = random.nextInt(9) + 1;
      }
    }
  }

  void end() async {
    if (score > highestScore) {
      highestScore = score;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('highestScore', highestScore);
    }
    score = 0;
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < col; j++) {
        grids[i][j] = 0;
      }
    }
  }

  bool onGridDrag(int startX, int startY, int endX, int endY) {
    int count = 0;
    int existNum = 0;
    if (startX > endX) {
      int temp = startX;
      startX = endX;
      endX = temp;
    }
    if (startY > endY) {
      int temp = startY;
      startY = endY;
      endY = temp;
    }
    if (startX < 0) startX = 0;
    if (startY < 0) startY = 0;
    if (endX >= col) endX = col - 1;
    if (endY >= row) endY = row - 1;

    for (int i = startY; i <= endY; i++) {
      for (int j = startX; j <= endX; j++) {
        int num = grids[i][j];
        if (num != 0) {
          count += num;
          existNum++;
        }
      }
    }

    print('ret $count $existNum');
    if (count == 10) {
      for (int i = startY; i <= endY; i++) {
        for (int j = startX; j <= endX; j++) {
          grids[i][j] = 0;
        }
      }
      scoring(existNum);
      return true;
    }
    return false;
  }

  // 记分规则
  void scoring(int score) {
    this.score += score;
  }

  void printGrids() {
    for (int i = 0; i < row; i++) {
      print(grids[i]);
    }
  }
}
