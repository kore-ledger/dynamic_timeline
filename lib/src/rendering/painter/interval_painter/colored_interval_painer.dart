import 'package:flutter/src/painting/basic_types.dart';
import 'interval_painter.dart';
import 'dart:ui';

class ColoredIntervalPainter extends IntervalPainter {
  Color? Function(int intervalIdx) _getIntervalColor =
      (intervalIdx) => <Color?>[const Color.fromARGB(255, 180, 180, 180), null][intervalIdx % 2];

  static IntervalPainter createHorizontal(
          {Color? Function(int intervalIdx)? intervalColorCallback}) =>
      ColoredIntervalPainter._(axis: Axis.horizontal)..setIntervalColor(intervalColorCallback);

  static IntervalPainter createVertical(
          {Color? Function(int intervalIdx)? intervalColorCallback}) =>
      ColoredIntervalPainter._(axis: Axis.vertical)..setIntervalColor(intervalColorCallback);

  ColoredIntervalPainter._({required Axis axis}) : super(drawingAxis: axis);

  void setIntervalColor(Color? Function(int intervalIdx)? callback) =>
      _getIntervalColor = callback ?? _getIntervalColor;

  @override
  void paintCallback(Canvas canvas, Rect drawingRegion, int intervalIdx) {
    var color = _getIntervalColor(intervalIdx);
    if (color == null) return;
    var paint = Paint()..color = color!;
    canvas.drawRect(drawingRegion, paint);
  }
}
