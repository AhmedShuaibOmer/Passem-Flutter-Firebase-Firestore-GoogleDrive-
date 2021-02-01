/*
 * Created Date: 1/27/21 2:22 AM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021 SafePass
 *
 */

import 'package:flutter/material.dart';

class MyColors {
  // This class is not meant to be instantiated or extended; this constructor
  // prevents instantiation and extension.
  // ignore: unused_element
  MyColors._();

  static Color primaryLightColor = Color(0xff5030bc);
  static Color primaryColor50 = primaryColor.withAlpha(50);

  static const Color primaryColor = Color(0xff00008b);

  static Color primaryDarkColor = Color(0xff00005d);

  static const Color secondaryColor = Colors.cyanAccent;

  static Color secondaryLightColor = Colors.cyanAccent.shade100;

  static Color secondaryDarkColor = Colors.cyan.shade700;

  static const Color primaryTextColor = Color(0xffffffff);

  static const Color secondaryTextColor = Color(0xff000000);
}
