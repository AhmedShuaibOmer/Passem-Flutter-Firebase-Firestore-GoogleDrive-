/*
 * Created Date: 3/8/21 7:13 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class MyDropdownSearch<T> extends StatelessWidget {
  final InputDecoration dropdownSearchDecoration;

  final Mode popupMode;

  final String Function(T) itemAsString;

  const MyDropdownSearch({
    Key key,
    this.label,
    this.hint,
    this.onChanged,
    this.items,
    this.dropdownSearchDecoration,
    this.popupMode,
    this.itemAsString,
    this.selectedItem,
  }) : super(key: key);

  final String label;
  final String hint;
  final ValueChanged<T> onChanged;
  final List<T> items;
  final T selectedItem;

  @override
  Widget build(BuildContext context) {
    return DropdownSearch(
      selectedItem: selectedItem,
      mode: popupMode ?? Mode.BOTTOM_SHEET,
      label: label,
      hint: hint,
      items: items,
      itemAsString: itemAsString ?? (item) => item.name,
      showSearchBox: true,
      showClearButton: true,
      popupBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
      onChanged: onChanged,
      clearButton: const Icon(
        Icons.clear,
        size: 24,
        color: Colors.white,
      ),
      dropDownButton: const Icon(
        Icons.arrow_drop_down,
        size: 24,
        color: Colors.white,
      ),
      popupShape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
      ),
      searchBoxDecoration: InputDecoration(
        prefixIcon: Icon(
          Icons.search_rounded,
          size: 24,
          color: Theme.of(context).primaryColorLight,
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        ),
        labelStyle: TextStyle(
          color: Colors.white70,
        ),
      ),
      dropdownSearchDecoration: dropdownSearchDecoration ??
          InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.white,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            ),
            hintStyle: TextStyle(
              color: Colors.white70,
            ),
            labelStyle: TextStyle(
              color: Colors.white70,
            ),
          ),
    );
  }
}

class MyDropdownFieldBlocBuilder<T> extends StatelessWidget {
  final InputDecoration decoration;

  final SelectFieldBloc<T, Object> selectFieldBloc;

  final String Function(BuildContext, T) itemBuilder;

  const MyDropdownFieldBlocBuilder({
    Key key,
    this.label,
    this.hint,
    this.decoration,
    this.selectFieldBloc,
    this.itemBuilder,
  }) : super(key: key);

  final String label;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return DropdownFieldBlocBuilder<T>(
      selectFieldBloc: selectFieldBloc,
      itemBuilder: itemBuilder,
      decoration: decoration ??
          InputDecoration(
            labelText: label,
            hintText: hint,
            contentPadding: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.white,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            ),
            hintStyle: TextStyle(
              color: Colors.white70,
            ),
            labelStyle: TextStyle(
              color: Colors.white70,
            ),
          ),
    );
  }
}
