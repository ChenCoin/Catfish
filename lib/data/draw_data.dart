import 'dart:math';
import 'package:flutter/animation.dart';
import '../ux.dart';

class DrawData {
  EffectCreator effectCreator = NilEffectCreator();

  List<EffectGrids> allItem = <EffectGrids>[];

  void initBoard(EffectCreator effectCreator) {
    this.effectCreator = effectCreator;
  }

  bool isEffectActive() {
    return allItem.isNotEmpty;
  }

  void addEffectItem(List<(int, int, int)> newItem) {
    if (!effectCreator.isEffectEnable()) {
      return;
    }
    var args = newItem
        .map((e) => EffectPoint(e.$1.toDouble(), e.$2.toDouble(), e.$3))
        .toList();
    effectCreator.createEffect(args);
  }

  void add(EffectGrids newItem) {
    allItem.add(newItem);
  }

  void remove(EffectGrids item) {
    allItem.remove(item);
  }

  void dispose() {
    allItem.clear();
    effectCreator = NilEffectCreator();
  }
}

class EffectGrids {
  List<EffectPoint> allItem;

  Animation<double> anim;

  late EffectPoint center;

  EffectGrids(this.allItem, this.anim) {
    double minX = 0;
    double maxX = UX.col.toDouble();
    double minY = 0;
    double maxY = UX.row.toDouble();
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

abstract class EffectCreator {
  bool isEffectEnable();

  void createEffect(List<EffectPoint> item);
}

class NilEffectCreator implements EffectCreator {
  @override
  bool isEffectEnable() => true;

  @override
  void createEffect(List<EffectPoint> item) {}
}
