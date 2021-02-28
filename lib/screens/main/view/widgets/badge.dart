/*
 * Created Date: 2/22/21 9:35 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:flutter/material.dart';

class IconBadge extends StatefulWidget {
  final IconData icon;
  final String badgeText;

  final Function onPressed;

  final Color iconColor;
  final Color badgeColor;
  final Color onBadgeColor;

  IconBadge(
      {Key key,
      @required this.icon,
      this.badgeText,
      @required this.onPressed,
      this.iconColor,
      this.badgeColor, this.onBadgeColor})
      : super(key: key);

  @override
  _IconBadgeState createState() => _IconBadgeState();
}

class _IconBadgeState extends State<IconBadge> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        IconButton(
          icon: Icon(
            widget.icon,
            color: widget.iconColor,
          ),
          onPressed: widget.onPressed,
        ),
        Positioned.directional(
          textDirection: Directionality.of(context),
          end: 4,
          bottom: 4,
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: widget.badgeColor ?? Theme.of(context).accentColor,
              borderRadius: BorderRadius.circular(6),
            ),
            constraints: BoxConstraints(
              minWidth: 13,
              minHeight: 13,
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 1),
              child: Text(
                widget.badgeText,
                style: TextStyle(
                  color:
                      widget.onBadgeColor ?? Colors.white,
                  fontSize: 8,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
