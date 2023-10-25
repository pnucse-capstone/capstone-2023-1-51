import 'dart:math';
import 'package:flutter/material.dart';

class PieChart extends CustomPainter{
  double percentage = 0;
  double textScaleFactor = 1.0;
  PieChart({required this.percentage, required this.textScaleFactor});

  @override
  void paint(Canvas canvas, Size size){
    Paint paint = Paint()
        ..color = Colors.white60
        ..strokeWidth = 27.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.butt;

    // 원의 반지름을 구함. 선의 굵기에 영향을 받지 않게 보정함.

    double radius = min(size.width / 2 - paint.strokeWidth / 2 , size.height / 2 - paint.strokeWidth/2);
    Offset center= Offset(size.width/2, size.height/2);

    canvas.drawCircle(center, radius, paint); // 원을 그림.

    double arcAngle = 2 * pi * (percentage / 100); // 호(arc)의 각도를 정함. 정해진 각도만큼만 그리도록 함.
    paint..color = Colors.red[700]!;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, arcAngle, false, paint); // 호(arc)를 그림.

    drawText(canvas, size, "$percentage %"); // 텍스트를 화면에 표시함.
  }

  // 원의 중앙에 텍스트를 적음.
  void drawText(Canvas canvas, Size size, String text) {
    double fontSize = getFontSize(size, text);

    TextSpan sp = TextSpan(style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.black), text: text); // TextSpan은 Text위젯과 거의 동일하다.
    TextPainter tp = TextPainter(text: sp, textDirection: TextDirection.ltr);

    tp.layout(); // 필수! 텍스트 페인터에 그려질 텍스트의 크기와 방향를 정함.
    double dx = size.width / 2 - tp.width / 2;
    double dy = size.height / 2 - tp.height / 2;

    Offset offset = Offset(dx, dy);
    tp.paint(canvas, offset);
  }
  // 화면 크기에 비례하도록 텍스트 폰트 크기를 정함.
  double getFontSize(Size size, String text) {
    return size.width / text.length * textScaleFactor;
  }

  @override
  bool shouldRepaint(PieChart old) {
    return old.percentage != percentage;
  }



}