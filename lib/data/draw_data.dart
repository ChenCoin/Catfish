import 'dart:math';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'grid_data.dart';

typedef CreateFunc = void Function(List<EffectPoint> item);

class DrawData {
  CreateFunc createEffectGrids = (arg) {};

  List<EffectGrids> allItem = <EffectGrids>[];

  void initBoard(CreateFunc createFn) {
    createEffectGrids = createFn;
  }

  bool isEffectActive() {
    return allItem.isNotEmpty;
  }

  void addEffectItem(List<(int, int, int)> newItem) {
    var args = newItem
        .map((e) => EffectPoint(e.$1.toDouble(), e.$2.toDouble(), e.$3))
        .toList();
    createEffectGrids(args);
  }

  void add(EffectGrids newItem) {
    allItem.add(newItem);
  }

  void remove(EffectGrids item) {
    allItem.remove(item);
  }

  void dispose() {
    allItem.clear();
    createEffectGrids = (arg) {};
  }
}

class EffectGrids {
  List<EffectPoint> allItem;

  Animation<double> anim;

  late EffectPoint center;

  EffectGrids(this.allItem, this.anim) {
    double minX = 0;
    double maxX = GridData.col.toDouble();
    double minY = 0;
    double maxY = GridData.row.toDouble();
    if (allItem.isNotEmpty) {
      minX = allItem[0].x;
      maxX = allItem[0].x;
      minY = allItem[0].y;
      maxY = allItem[0].y;
    }
    for (var value in allItem) {
      minX = min(minX, value.x);
      maxX = max(maxX, value.x);
      minY = min(minY, value.y);
      maxY = max(maxY, value.y);
    }
    center = EffectPoint(((minX + maxX) / 2), ((minY + maxY) / 2), 10);
  }
}

class EffectPoint {
  double x;

  double y;

  int number;

  EffectPoint(this.x, this.y, this.number);
}
