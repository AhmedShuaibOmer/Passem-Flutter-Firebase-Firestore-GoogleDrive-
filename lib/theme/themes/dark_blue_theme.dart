/*
 * Created Date: 1/27/21 1:58 AM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021 SafePass
 *
 */

import 'package:flutter/material.dart';

import '../../theme/colors/my_colors.dart';

class DarkBlueTheme {
  // This class is not meant to be instantiated or extended; this constructor
  // prevents instantiation and extension.
  // ignore: unused_element
  DarkBlueTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: MyColors.primaryColor,
      primaryColorDark: MyColors.primaryDarkColor,
      primaryColorLight: MyColors.primaryLightColor,
      primaryColorBrightness: Brightness.dark,
      accentColorBrightness: Brightness.light,
      accentColor: MyColors.secondaryColor,
      scaffoldBackgroundColor: Colors.white,
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: MyColors.primaryColor,
          padding: EdgeInsets.symmetric(horizontal: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          textStyle: TextStyle(
            color: MyColors.primaryColor,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.accent,
        buttonColor: Colors.white,
      ),
    );
  }

  static ThemeData get darkTheme {
    return lightTheme;
  }
}
