// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_zh.dart';

void main() {
  debugPrint('test start');
  var textContent = '0123456789';
  textContent += 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';

  AppLocalizationsZh local = AppLocalizationsZh();
  textContent += local.title;
  textContent += local.startGame;
  textContent += local.endGame;
  textContent += local.restartGame;
  textContent += local.backHome;
  textContent += local.score;
  textContent += local.highestScore;
  textContent += local.remainingTime;
  textContent += local.scoreNow;
  textContent += local.tip;

  debugPrint(textContent.characters.toSet().reduce((a, b) => a + b));
  debugPrint('test end');

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {});
}
