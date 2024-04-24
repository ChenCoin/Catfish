import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GridData {
  static const int col = 10;

  static const int row = 16;

  static const String highestScoreKey = 'catfish.highestScore';

  List<List<int>> grids = [];

  int score = 0;

  int highestScore = 0;

  String magicNumber = '';

  GridData() {
    for (int i = 0; i < row; i++) {
      List<int> list = [];
      for (int j = 0; j < col; j++) {
        list.add(0);
      }
      grids.add(list);
    }
  }

  void init(void Function() callback) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    highestScore = prefs.getInt(highestScoreKey) ?? 0;
    callback();
  }

  void start() {
    score = 0;
    var random = Random();
    // 加入成对的数字组合，因为可能选到不可放置的格子，尝试次数总共48次
    int pair = 0;
    for (int i = 0; i < 48; i++) {
      int number = random.nextInt(9) + 1;
      int numberNext = 10 - number;
      (int, int, int, int) thePoint = findPoint(random);
      if (thePoint.$1 == -1) {
        continue;
      }
      grids[thePoint.$2][thePoint.$1] = number;
      grids[thePoint.$4][thePoint.$3] = numberNext;
      pair++;
    }
    var magicNumStart = random.nextInt(10);
    var magicNumEnd = random.nextInt(10);
    magicNumber =
        '$magicNumStart${pair.toString().padLeft(2, '0')}$magicNumEnd';

    // 剩余空白的格子，加入随机数
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < col; j++) {
        if (grids[i][j] != 0) {
          continue;
        }
        grids[i][j] = random.nextInt(9) + 1;
      }
    }
  }

  void end() async {
    if (score > highestScore) {
      highestScore = score;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt(highestScoreKey, highestScore);
    }
    magicNumber = '';
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < col; j++) {
        grids[i][j] = 0;
      }
    }
  }

  List<(int, int, int)> onGridDrag(int startX, int startY, int endX, int endY) {
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

    debugPrint('ret $count $existNum');
    if (count == 10) {
      var result = <(int, int, int)>[];
      for (int i = startY; i <= endY; i++) {
        for (int j = startX; j <= endX; j++) {
          if (grids[i][j] == 0) {
            continue;
          }
          result.add((j, i, grids[i][j]));
          grids[i][j] = 0;
        }
      }
      scoring(existNum);
      return result;
    }
    return List.empty();
  }

  // 检查给出的格子是否是可用的
  bool checkPointAvailable((int dx, int dy) point) {
    if (point.$1 < 0 || point.$2 < 0 || point.$1 >= col || point.$2 >= row) {
      return false;
    }
    if (grids[point.$2][point.$1] != 0) {
      return false;
    }
    return true;
  }

  // 寻找2个空白的格子
  (int, int, int, int) findPoint(Random random) {
    var error = (-1, -1, -1, -1);
    // 随机一个点，并检查是否可用
    int dx = random.nextInt(col);
    int dy = random.nextInt(row);
    if (!checkPointAvailable((dx, dy))) {
      return error;
    }
    // 向周围4个方向取点，随机一个方向
    int direction = random.nextInt(4) + 1;
    // 取左边
    if (direction == 1 && checkPointAvailable((dx - 1, dy))) {
      return (dx, dy, dx - 1, dy);
    }
    // 取右边
    if (direction == 1 && checkPointAvailable((dx + 1, dy))) {
      return (dx, dy, dx + 1, dy);
    }
    // 取上边
    if (direction == 1 && checkPointAvailable((dx, dy - 1))) {
      return (dx, dy, dx, dy - 1);
    }
    // 取下边
    if (direction == 1 && checkPointAvailable((dx, dy + 1))) {
      return (dx, dy, dx, dy + 1);
    }
    return error;
  }

  // 记分规则
  void scoring(int score) {
    this.score += score;
  }

  void printGrids() {
    for (int i = 0; i < row; i++) {
      debugPrint(grids[i].toString());
    }
  }
}
