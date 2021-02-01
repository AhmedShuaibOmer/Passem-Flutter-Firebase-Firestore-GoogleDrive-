/*
 * Created Date: 1/27/21 7:41 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021 SafePass
 *
 */

import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:safe_pass/theme/colors/my_colors.dart';

class FormTextField extends StatelessWidget {
  final IconData prefixIcon;

  final TextFieldBloc textFieldBloc;

  final TextInputType keyboardType;

  final String hintText;

  final BoxConstraints suffixIconConstraints;

  final SuffixButton suffixButton;

  final bool hasError;

  const FormTextField({
    Key key,
    @required this.prefixIcon,
    @required this.textFieldBloc,
    this.keyboardType,
    this.hintText,
    this.suffixIconConstraints,
    this.suffixButton,
    this.hasError = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 32),
      child: Material(
        elevation: 10.0,
        color: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: Padding(
          padding: EdgeInsets.only(
            left: 8,
            right: 16,
            bottom: hasError ? 10 : 0,
          ),
          child: TextFieldBlocBuilder(
            textFieldBloc: textFieldBloc,
            keyboardType: keyboardType,
            padding: EdgeInsets.zero,
            textAlignVertical: TextAlignVertical.center,
            suffixButton: suffixButton,
            obscureTextTrueIcon: Icon(
              Icons.visibility,
              size: 24.0,
              color: MyColors.primaryColor50,
            ),
            obscureTextFalseIcon: Icon(
              Icons.visibility_off,
              size: 24.0,
              color: MyColors.primaryColor50,
            ),
            style: TextStyle(
              color: MyColors.primaryColor,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 8,
              ),
              prefixIcon: Icon(
                prefixIcon,
                size: 24.0,
                color: MyColors.primaryColor50,
              ),
              suffixIconConstraints: suffixIconConstraints,
              errorText: hasError ? null : null,
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(
                color: Color(0xFFE1E1E1),
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
