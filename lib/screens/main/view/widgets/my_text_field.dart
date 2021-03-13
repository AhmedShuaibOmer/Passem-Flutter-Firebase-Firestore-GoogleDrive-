/*
 * Created Date: 2/22/21 9:16 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:meta/meta.dart';

class MyTextField extends StatefulWidget {
  final Color fillColor;
  final String hintText;
  final Icon prefixIcon;
  final Function(String) onChanged;

  final int minLines;
  final int maxLines;

  final Widget suffixIcon;
  final FocusNode focusNode;

  MyTextField(
      {Key key,
      this.controller,
      this.fillColor,
      this.hintText,
      this.prefixIcon,
      this.onChanged,
      this.minLines,
      this.maxLines,
      this.suffixIcon,
      this.focusNode})
      : super(key: key);

  final TextEditingController controller;
  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 500, maxHeight: 100),
      child: TextField(
        focusNode: widget.focusNode,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 16.0,
        ),
        onChanged: widget.onChanged,
        controller: widget.controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: widget.fillColor,
          contentPadding: EdgeInsetsDirectional.only(
            start: 22,
            top: 16,
            bottom: 16,
            end: 16,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          hintText: widget.hintText,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          hintStyle: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
            color: Theme.of(context).primaryColor.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}

class MyTextFieldBlocBuilder extends StatefulWidget {
  final Color fillColor;
  final String hintText;
  final Icon prefixIcon;
  final Function(String) onChanged;

  final int minLines;
  final int maxLines;

  final Widget suffixIcon;

  final TextFieldBloc<Object> textFieldBloc;

  final bool isEnabled;

  MyTextFieldBlocBuilder(
      {Key key,
      this.fillColor,
      this.hintText,
      this.prefixIcon,
      this.onChanged,
      this.minLines,
      this.maxLines,
      this.suffixIcon,
      @required this.textFieldBloc,
      this.isEnabled = true})
      : super(key: key);
  @override
  _MyTextFieldBlocBuilderState createState() => _MyTextFieldBlocBuilderState();
}

class _MyTextFieldBlocBuilderState extends State<MyTextFieldBlocBuilder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 500, maxHeight: 100),
      child: TextFieldBlocBuilder(
        isEnabled: widget.isEnabled,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 16.0,
        ),
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: widget.fillColor,
          contentPadding: EdgeInsetsDirectional.only(
            start: 22,
            top: 16,
            bottom: 16,
            end: 16,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          hintText: widget.hintText,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          hintStyle: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
            color: Theme.of(context).primaryColor.withOpacity(0.5),
          ),
        ),
        textFieldBloc: widget.textFieldBloc,
      ),
    );
  }
}
