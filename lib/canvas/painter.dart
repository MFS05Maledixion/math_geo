import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

class LinePainter extends ChangeNotifier implements CustomPainter {
  late List<Offset> qPoints;
  var strokes = <List<Offset>>[];
  var points = <Offset>[];
  List<String> alphabet = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];
  bool hitTest(Offset position) => true;

  void startStroke(Offset position) {
    strokes.add([position]);
    points.add(position);
    notifyListeners();
  }

  void deletePoint() {
    if (strokes.isNotEmpty && points.isNotEmpty) {
      strokes.removeLast();
      points.removeLast();
      notifyListeners();
    }
  }

  // Distance function::
  distance(Offset point1, Offset point2) {
    var getDistance = math.pow((point2.dx - point1.dx), 2) +
        math.pow((point2.dy - point1.dy), 2);
    return math.sqrt(getDistance).toInt();
  }

  // calculating midpoint function
  midPoint(Offset point1, Offset point2) {
    double midP1 = (point1.dx + point2.dx) / 2;
    double midP2 = (point1.dy + point2.dy) / 2;
    return Offset(midP1, midP2);
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint strokePaint = Paint();
    strokePaint.color = Colors.teal;
    strokePaint.style = PaintingStyle.stroke;
    strokePaint.strokeWidth = 2;

    Paint pointPaint = Paint();
    pointPaint.strokeWidth = 10;
    pointPaint.color = Colors.teal;
    pointPaint.strokeCap = StrokeCap.round;

    for (var stroke in strokes) {
      canvas.drawPoints(PointMode.points, stroke, pointPaint);
      Path strokePath = Path();
      strokePath.addPolygon(points, true);
      canvas.drawPath(strokePath, strokePaint);
    }

    //Questions List

    //Path qPath = Path();
    //qPath.addPolygon(qPoints, true);
    //canvas.drawPath(qPath, strokePaint);

    var counter = 0;

    for (var point in points) {
      //debug logging the getSides() method

      // displaying point value
      TextSpan span = TextSpan(
          style: TextStyle(color: Colors.red[900]),
          text:
              '${alphabet[counter]}(${point.dx.toInt()}, ${point.dy.toInt()})');
      TextPainter tp = TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
          textScaleFactor: .8);
      tp.layout();
      tp.paint(canvas, Offset(point.dx, point.dy));

      // debug logs
      // ignore: avoid_print
      print('Distance:  ${distance(points[counter], points[counter + 1])}');
      // distance will only show if there are more than 1 point(s)
      if (points.length > 1) {
        TextSpan span = TextSpan(
            style: TextStyle(color: Colors.red[900]),
            text: '${distance(points[counter], points[counter + 1])}cm');
        TextPainter tp = TextPainter(
            text: span,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
            textScaleFactor: 1.0);
        tp.layout();
        tp.paint(canvas, midPoint(points[counter], points[counter + 1]));
      }

      // indexer
      ++counter;
    }

    //////////paint question points
    for (var qp in qPoints) {
      Path path = Path();
      path.addPolygon(qPoints, true);
      canvas.drawPath(path, strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;

  @override
  // TODO: implement semanticsBuilder
  SemanticsBuilderCallback? get semanticsBuilder => null;
}
