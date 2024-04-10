import 'package:dynamic_timeline/dynamic_timeline.dart';
import 'package:flutter/material.dart';

/// {@template dynamic_timeline}
/// A widget that displays a timeline and positions its children using their
/// start and end date times.
///
/// Each child must be a [TimelineItem] that represents an event.
///
/// Each item must have a key in case of displaying dynamic data.
///
/// This widget has a fixed size, calculated using the extent properties.
/// {@endtemplate}
class DynamicTimeline extends MultiChildRenderObjectWidget {
  /// {@macro dynamic_timeline}
  DynamicTimeline({
    Key? key,
    required this.pixels,
    required this.windowsLenght,
    required this.firstDateTime,
    required this.lastDateTime,
    required this.labelBuilder,
    this.axis = Axis.horizontal,
    this.crossAxisCount = 1,
    this.maxCrossAxisIndicatorExtent = 60,
    this.maxCrossAxisItemExtent,
    this.crossAxisSpacing = 20,
    this.resizable = true,
    required this.items,
  })  : assert(
          maxCrossAxisItemExtent != double.infinity,
          "max cross axis item extent can't be infinite. ",
        ),
        assert(
          firstDateTime.isBefore(lastDateTime),
          'firstDateTime must be before lastDateTime:   '
          'firstDateTime: $firstDateTime --- lastDateTime: $lastDateTime',
        ),
        super(key: key, children: items);

  /// How long any Line is in pixels
  final double pixels;

  /// Width of actual windows
  final double windowsLenght;

  /// The axis of the line.
  final Axis axis;

  /// Items
  List<TimelineItem> items;

  /// The first date time in the timeline.
  final DateTime firstDateTime;

  /// The last datetime in the timeline.
  final DateTime lastDateTime;

  /// Called to build the label of each mark.
  ///
  /// Note: DateFormat can be used.
  final String? Function(int) labelBuilder;

  /// If true the items can be resized, dragging in the main axis extremes.
  final bool resizable;

  /// The number of items in the cross axis.
  ///
  /// If a child has a position greater than or equal [crossAxisCount]
  /// it will not be shown.
  final int crossAxisCount;

  /// The extent of the label and line.
  final double maxCrossAxisIndicatorExtent;

  /// It is used to calculate the cross axis extent of the timeline.
  final double? maxCrossAxisItemExtent;

  /// The number of logical pixels between each item along the cross axis.
  final double crossAxisSpacing;

  @override
  RenderObject createRenderObject(BuildContext context) {

    return RenderDynamicTimeline(
      pixels: pixels,
      windowsLenght: windowsLenght,
      sizeVec: items.length,
      firstDateTime: firstDateTime,
      lastDateTime: lastDateTime,
      labelBuilder: labelBuilder,
      axis: axis,
      crossAxisCount: crossAxisCount,
      maxCrossAxisIndicatorExtent: maxCrossAxisIndicatorExtent,
      maxCrossAxisItemExtent: maxCrossAxisItemExtent,
      crossAxisSpacing: crossAxisSpacing,
      resizable: resizable,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderDynamicTimeline renderObject,
  ) {
    print(Theme.of(context).textTheme.bodyText1);
    renderObject
    ..pixels
      ..windowsLenght = windowsLenght
      ..sizeVec = items.length
      ..firstDateTime = firstDateTime
      ..lastDateTime = lastDateTime
      ..labelBuilder = labelBuilder
      ..axis = axis
      ..crossAxisCount = crossAxisCount
      ..maxCrossAxisIndicatorExtent = maxCrossAxisIndicatorExtent
      ..maxCrossAxisItemExtent = maxCrossAxisItemExtent
      ..crossAxisSpacing = crossAxisSpacing
      ..resizable = resizable;
  }
}
