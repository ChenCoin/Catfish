import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TimerText extends StatefulWidget {
  final int secondCount;

  final void Function() onTickEnd;

  const TimerText(
      {super.key, required this.secondCount, required this.onTickEnd});

  @override
  State<StatefulWidget> createState() => _TimerTextState();
}

class _TimerTextState extends State<TimerText> {
  int secondCount = 0;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    secondCount = widget.secondCount;
    _timer = Timer.periodic(const Duration(seconds: 1), onTick);
  }

  @override
  Widget build(BuildContext context) {
    var minute = (secondCount / 60).floor().toString().padLeft(2, '0');
    var second = (secondCount % 60).toString().padLeft(2, '0');
    var content = AppLocalizations.of(context)!.remainingTime;
    return Text('$content $minute:$second'
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  void onTick(Timer timer) {
    if (secondCount == 0) {
      timer.cancel();
      widget.onTickEnd();
    } else {
      setState(() {
        secondCount--;
      });
    }
  }
}
