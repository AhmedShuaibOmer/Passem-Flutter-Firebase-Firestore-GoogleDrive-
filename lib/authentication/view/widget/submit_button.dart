/*
 * Created Date: 1/28/21 5:04 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021 SafePass
 *
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safe_pass/theme/colors/my_colors.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;

  final String label;

  final bool isSubmitting;

  const SubmitButton({Key key, this.onPressed, this.label, this.isSubmitting})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 32),
      child: RaisedButton(
        elevation: 10,
        padding: const EdgeInsets.symmetric(vertical: 14),
        disabledColor: Colors.white,
        onPressed: isSubmitting ? null : onPressed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: isSubmitting
                ? CircularProgressIndicator()
                : Text(
                    label,
                    style: TextStyle(
                      color: MyColors.primaryColor,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
