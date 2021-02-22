/*
 * Created Date: 1/28/21 4:41 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021 SafePass
 *
 */

import 'package:flutter/material.dart';
import 'package:passem/theme/theme.dart';

class LoginBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var width = size.width;
    var height = size.height;
    var ratio = size.aspectRatio;

    var paint = Paint();

    paint.color = MyColors.primaryColor;
    paint.style = PaintingStyle.fill;

    var path = Path();

    var firstPoint = Offset(0.0, height * .05);
    var thirdPoint = Offset(0.0, height * .95);
    var secondPoint = Offset((thirdPoint.dy - firstPoint.dy) / 2,
        ((thirdPoint.dy - firstPoint.dy) / 2) + firstPoint.dy);
    var forthPoint = Offset(0.0, height * .75);
    var sixthPoint = Offset(0.0, height * .25);
    var fifthPoint = Offset((forthPoint.dy - sixthPoint.dy) / 2,
        ((forthPoint.dy - sixthPoint.dy) / 2) + sixthPoint.dy);

    path.moveTo(firstPoint.dx, firstPoint.dy);
    path.lineTo(secondPoint.dx, secondPoint.dy);
    path.lineTo(thirdPoint.dx, thirdPoint.dy);
    path.lineTo(forthPoint.dx, forthPoint.dy);
    path.lineTo(fifthPoint.dx, fifthPoint.dy);
    path.lineTo(sixthPoint.dx, sixthPoint.dy);

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class SignUpBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var width = size.width;
    var height = size.height;
    var ratio = size.aspectRatio;

    var paint = Paint();

    paint.color = MyColors.primaryColor;
    paint.style = PaintingStyle.fill;

    var path = Path();

    var firstPoint = Offset(width, height * .05);

    var secondPoint = Offset(width - height * .05, 0.0);
    var thirdPoint = Offset(width - height * .20, 0.0);
    var forthPoint = Offset(width - height * .20, height);
    var fifthPoint = Offset(width - height * .05, height);
    var sixthPoint = Offset(width, height * .95);
    var seventhPoint = Offset(width, height * .75);
    var eighthPoint = Offset(width - height * .05, height * .80);
    var ninthPoint = Offset(width - height * .05, height * .2);
    var tenthPoint = Offset(width, height * .25);

    path.moveTo(firstPoint.dx, firstPoint.dy);
    path.lineTo(secondPoint.dx, secondPoint.dy);
    path.lineTo(thirdPoint.dx, thirdPoint.dy);
    path.lineTo(forthPoint.dx, forthPoint.dy);
    path.lineTo(fifthPoint.dx, fifthPoint.dy);
    path.lineTo(sixthPoint.dx, sixthPoint.dy);
    path.lineTo(seventhPoint.dx, seventhPoint.dy);
    path.lineTo(eighthPoint.dx, eighthPoint.dy);
    path.lineTo(ninthPoint.dx, ninthPoint.dy);
    path.lineTo(tenthPoint.dx, tenthPoint.dy);

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
