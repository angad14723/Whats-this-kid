import 'dart:async';

import 'package:flutter/material.dart';
import 'package:seekbar/seekbar.dart';

class TestSeekBarPage extends StatefulWidget {
  @override
  _TestSeekBarPageState createState() {
    return _TestSeekBarPageState();
  }
}

class _TestSeekBarPageState extends State<TestSeekBarPage> {
  double _value = 0.0;
  double sliderValue = 10.0;

  Timer _progressTimer;
  Timer _secondProgressTimer;

  bool _done = false;

  @override
  void initState() {
    super.initState();
  }

  _resumeProgressTimer() {
    _progressTimer = Timer.periodic(const Duration(milliseconds: 10), (_) {
      setState(() {
        _value += 0.0005;
        if (_value >= 1) {
          _progressTimer.cancel();
          _done = true;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        alignment: Alignment.center,
        color: Colors.black87,
        child:  SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.red,
            inactiveTrackColor: Colors.black,
            trackHeight: 3.0,
            thumbColor: Colors.yellow,
            thumbShape:
            RoundSliderThumbShape(enabledThumbRadius: 8.0),
            overlayColor: Colors.purple.withAlpha(32),
            overlayShape:
            RoundSliderOverlayShape(overlayRadius: 14.0),
          ),
          child: Slider(
              value: sliderValue,
              onChanged: (value) {
                setState(() {
                  sliderValue = value;
                });
              }),
        ),
      ),
    );
  }
}