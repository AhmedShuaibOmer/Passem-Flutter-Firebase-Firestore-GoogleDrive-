/*
 * Created Date: 2/25/21 2:47 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */
import 'package:flutter/material.dart';

enum RoundedUnderlinedIndicatorSize {
  tiny,
  normal,
  full,
}

class RoundedUnderlinedIndicator extends Decoration {
  final double indicatorHeight;
  final Color indicatorColor;
  final RoundedUnderlinedIndicatorSize indicatorSize;

  const RoundedUnderlinedIndicator(
      {@required this.indicatorHeight,
      @required this.indicatorColor,
      @required this.indicatorSize});

  @override
  _MD2Painter createBoxPainter([VoidCallback onChanged]) {
    return new _MD2Painter(this, onChanged);
  }
}

class _MD2Painter extends BoxPainter {
  final RoundedUnderlinedIndicator decoration;

  _MD2Painter(this.decoration, VoidCallback onChanged)
      : assert(decoration != null),
        super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration != null);
    assert(configuration.size != null);

    Rect rect;
    if (decoration.indicatorSize == RoundedUnderlinedIndicatorSize.full) {
      rect = Offset(offset.dx,
              (configuration.size.height - decoration.indicatorHeight ?? 3)) &
          Size(configuration.size.width, decoration.indicatorHeight ?? 3);
    } else if (decoration.indicatorSize ==
        RoundedUnderlinedIndicatorSize.normal) {
      rect = Offset(offset.dx + 6,
              (configuration.size.height - decoration.indicatorHeight ?? 3)) &
          Size(configuration.size.width - 12, decoration.indicatorHeight ?? 3);
    } else if (decoration.indicatorSize ==
        RoundedUnderlinedIndicatorSize.tiny) {
      rect = Offset(offset.dx + configuration.size.width / 2 - 8,
              (configuration.size.height - decoration.indicatorHeight ?? 3)) &
          Size(16, decoration.indicatorHeight ?? 3);
    }

    final Paint paint = Paint();
    paint.color = decoration.indicatorColor ?? Color(0xff1967d2);
    paint.style = PaintingStyle.fill;
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          rect,
          topRight: Radius.circular(8),
          topLeft: Radius.circular(8),
        ),
        paint);
  }
}
