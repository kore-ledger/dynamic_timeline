// ignore_for_file: public_member_api_docs

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DynamicTimelineParentData extends ContainerBoxParentData<RenderBox> {
  DynamicTimelineParentData({
    required this.microsecondExtent,
    required this.minItemDuration,
    required this.axis,
    required this.resizable,
  });

  DateTime? startDateTime;
  DateTime? endDateTime;
  int? position;
  final double microsecondExtent;
  final Duration minItemDuration;
  final Axis axis;
  final bool resizable;
}

class RenderDynamicTimeline extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, DynamicTimelineParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, DynamicTimelineParentData> {
  RenderDynamicTimeline({
    required double pixels,
    required double windowsLenght,
    required int sizeVec,
    required DateTime firstDateTime,
    required DateTime lastDateTime,
    required String? Function(int) labelBuilder,
    required Axis axis,
    required int crossAxisCount,
    required double maxCrossAxisIndicatorExtent,
    required double? maxCrossAxisItemExtent,
    required double crossAxisSpacing,
    required bool resizable,
  })  : _pixels = pixels,
        _windowsLenght = windowsLenght,
        _sizeVec = sizeVec,
        _firstDateTime = firstDateTime,
        _lastDateTime = lastDateTime,
        _labelBuilder = labelBuilder,
        _axis = axis,
        _crossAxisCount = crossAxisCount,
        _maxCrossAxisIndicatorExtent = maxCrossAxisIndicatorExtent,
        _maxCrossAxisItemExtent = maxCrossAxisItemExtent,
        _crossAxixSpacing = crossAxisSpacing,
        _resizable = resizable;

  double _pixels;

  double get pixels => _pixels;

  set pixels(double value) {
    _pixels = value;
  }


  double _windowsLenght;

  double get windowsLenght => _windowsLenght;

  set windowsLenght(double value) {
    _windowsLenght = value;
  }

  int _sizeVec;

  int get sizeVec => _sizeVec;

  set sizeVec(int value) {
    _sizeVec = value;
  }

  DateTime _firstDateTime;

  DateTime get firstDateTime =>
      _firstDateTime.subtract(const Duration(days: 1));

  set firstDateTime(DateTime value) {
    if (value == _firstDateTime) return;

    _firstDateTime = value;
    markNeedsLayout();
  }

  DateTime _lastDateTime;

  DateTime get lastDateTime => _lastDateTime.add(const Duration(days: 2));

  set lastDateTime(DateTime value) {
    if (value == _lastDateTime) return;

    _lastDateTime = value;
    markNeedsLayout();
  }

  String? Function(int index) _labelBuilder;

  String? Function(int index) get labelBuilder => _labelBuilder;

  set labelBuilder(String? Function(int index) value) {
    if (value == _labelBuilder) return;

    _labelBuilder = value;
    markNeedsLayout();
  }


  Axis _axis;

  Axis get axis => _axis;

  set axis(Axis value) {
    if (value == _axis) return;

    _axis = value;
    markNeedsLayout();
  }

  int _crossAxisCount;

  int get crossAxisCount => _crossAxisCount;

  set crossAxisCount(int value) {
    if (value == _crossAxisCount) return;

    _crossAxisCount = value;
    markNeedsLayout();
  }

  double _maxCrossAxisIndicatorExtent;

  double get maxCrossAxisIndicatorExtent => _maxCrossAxisIndicatorExtent;

  set maxCrossAxisIndicatorExtent(double value) {
    if (value == _maxCrossAxisIndicatorExtent) return;

    _maxCrossAxisIndicatorExtent = value;
    markNeedsLayout();
  }

  double? _maxCrossAxisItemExtent;

  double? get maxCrossAxisItemExtent => _maxCrossAxisItemExtent;

  set maxCrossAxisItemExtent(double? value) {
    if (value == _maxCrossAxisItemExtent) return;

    _maxCrossAxisItemExtent = value;
    markNeedsLayout();
  }

  double _crossAxixSpacing;

  double get crossAxisSpacing => _crossAxixSpacing;

  set crossAxisSpacing(double value) {
    if (value == _crossAxixSpacing) return;

    _crossAxixSpacing = value;
    markNeedsLayout();
  }

  bool _resizable;

  bool get resizable => _resizable;

  set resizable(bool value) {
    if (value == _resizable) return;

    _resizable = value;
  }

  Duration _getTotalDuration() {
    return lastDateTime.difference(firstDateTime);
  }

  double _getCrossAxisSize(Size size) {
    switch (axis) {
      case Axis.vertical:
        return size.width;
      case Axis.horizontal:
        return size.height;
    }
  }

  double _getMainAxisSize(Size size) {
    switch (axis) {
      case Axis.vertical:
        return size.height;
      case Axis.horizontal:
        return size.width;
    }
  }

  double _getCrossAxisExtent({required BoxConstraints constraints}) {
    final crossAxisSize = _getCrossAxisSize(constraints.biggest);

    if (maxCrossAxisItemExtent == null) return crossAxisSize;

    final attemptExtent = maxCrossAxisIndicatorExtent +
        (crossAxisSpacing + maxCrossAxisItemExtent!) * crossAxisCount;

    return min(
      crossAxisSize,
      attemptExtent,
    );
  }

  double _getMainAxisExtent({required BoxConstraints constraints}) {
    return max(pixels * sizeVec + 10 + 70, windowsLenght);
  }

  Size _computeSize({required BoxConstraints constraints}) {
    final crossAxisExtent = _getCrossAxisExtent(constraints: constraints);

    final mainAxisExtent = _getMainAxisExtent(constraints: constraints);

    switch (axis) {
      case Axis.vertical:
        return Size(crossAxisExtent, mainAxisExtent);
      case Axis.horizontal:
        return Size(mainAxisExtent, crossAxisExtent);
    }
  }

  double _getMaxCrossAxisItemExtent({required BoxConstraints constraints}) {
    if (maxCrossAxisItemExtent != null) return maxCrossAxisItemExtent!;

    final crosAxisExtent = _getCrossAxisExtent(constraints: constraints);

    final freeSpaceExtent = crosAxisExtent -
        maxCrossAxisIndicatorExtent -
        crossAxisSpacing * crossAxisCount;

    return freeSpaceExtent / crossAxisCount;
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! DynamicTimelineParentData) {
      child.parentData = DynamicTimelineParentData(
        microsecondExtent: 0,
        minItemDuration: Duration.zero,
        axis: axis,
        resizable: resizable,
      );
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return _computeSize(constraints: constraints);
  }

  @override
  void performLayout() {
    size = _computeSize(constraints: constraints);
    final maxCrossAxisItemExtent =
        _getMaxCrossAxisItemExtent(constraints: constraints);

    var child = firstChild;
    var count = 0;
    // define children layout and position
    while (child != null) {
      final childParentData = child.parentData! as DynamicTimelineParentData;


      late final int position;

      position = childParentData.position!;

//////// _getMainAxisExtent
      // final childDuration = endDateTime.difference(startDateTime);
      final childMainAxisExtent = pixels;
      final mainAxisPosition = 10 + pixels * count;
      count++;

      final crossAxisPosition = maxCrossAxisIndicatorExtent +
          crossAxisSpacing +
          (crossAxisSpacing + maxCrossAxisItemExtent) * position;

///////

      if (axis == Axis.vertical) {
        child.layout(
          BoxConstraints(
            minHeight: childMainAxisExtent,
            maxHeight: childMainAxisExtent,
            maxWidth: maxCrossAxisItemExtent,
          ),
        );

        childParentData.offset = Offset(crossAxisPosition, mainAxisPosition);
      } else {
        child.layout(
          BoxConstraints(
            minWidth: childMainAxisExtent,
            maxWidth: childMainAxisExtent,
            maxHeight: maxCrossAxisItemExtent,
          ),
        );

        childParentData.offset = Offset(mainAxisPosition, crossAxisPosition);
      }

      child = childParentData.nextSibling;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.pushClipRect(
      needsCompositing,
      offset,
      Offset.zero & size,
      (context, offset) {
        final canvas = context.canvas;
        if (axis == Axis.vertical) {
          /*
          // paint children
          defaultPaint(context, offset);

          // paint line
          canvas.drawLine(
            Offset(
              offset.dx + maxCrossAxisIndicatorExtent,
              offset.dy,
            ),
            Offset(
              offset.dx + maxCrossAxisIndicatorExtent,
              offset.dy + size.height,
            ),
            linePaint,
          );

          // paint labels
          var dateTime = firstDateTime;
          var labelOffset = offset;

          
          while (dateTime.isBefore(lastDateTime)) {
            final label = labelBuilder(dateTime);

            if (label != null) {
              TextPainter(
                text: TextSpan(
                  text: label,
                  style: labelTextStyle,
                ),
                textDirection: TextDirection.ltr,
                ellipsis: '.',
              )
                // - 10 to have space between the label and the line
                ..layout(maxWidth: size.width - 10)
                ..paint(canvas, labelOffset);
            }
            labelOffset =
                Offset(labelOffset.dx, labelOffset.dy + intervalExtent);
            dateTime = dateTime.add(intervalDuration);
          }*/
        } else {
          // paint children
          defaultPaint(context, offset);

          // paint labels
          final labelOffset = offset;
          var count = 0;
          while (count <= sizeVec) {
            final label = labelBuilder(count);

            if (label != null) {
              final parts = label.split(' ');
              final date = parts[0];
              final hour = parts.sublist(1).join(' ');

              // Dibujar la fecha
              final fechaTextPainter = TextPainter(
                text: TextSpan(
                  text: date,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
                textDirection: TextDirection.ltr,
                ellipsis: '.',
              );
              fechaTextPainter.layout(maxWidth: size.width - 10);
              canvas.save();
              canvas.translate(10 + labelOffset.dx + count * pixels - 10, labelOffset.dy + 35);
              canvas.rotate(-35 * 3.1415927 / 180);
              fechaTextPainter.paint(canvas, Offset.zero);
              canvas.restore();

              
              final horaTextPainter = TextPainter(
                text: TextSpan(
                  text: hour,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
                textDirection: TextDirection.ltr,
                ellipsis: '.',
              );
              horaTextPainter.layout(maxWidth: size.width - 10);
              canvas.save();
              canvas.translate(10 + labelOffset.dx + count * pixels + 16, labelOffset.dy + 38); // Ajustar la posición de la hora
              canvas.rotate(-35 * 3.1415927 / 180);
              horaTextPainter.paint(canvas, Offset.zero);
              canvas.restore();

  
              canvas.drawLine(
                Offset(
                  10 + labelOffset.dx + count * pixels,
                  labelOffset.dy + 65, // Ajustar la posición de la línea
                ),
                Offset(
                  10 + labelOffset.dx + count * pixels,
                  labelOffset.dy + size.height - 12,
                ),
                Paint()
                  ..color = Colors.black
                  ..strokeWidth = 1
                  ..style = PaintingStyle.stroke,
              );
            }
            count++;
          }
        }
      },
    );
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return size.width;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return size.width;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return size.height;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return size.height;
  }
}
