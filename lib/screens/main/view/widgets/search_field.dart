/*
 * Created Date: 2/22/21 9:16 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class SearchField extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'Search Field',
      child: TextField(
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 15.0,
        ),
        autofocus: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xfff3f3f4),
          contentPadding: EdgeInsetsDirectional.only(
            start: 22,
            top: 10,
            bottom: 10,
            end: 10,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          /*enabledBorder: OutlineInputBorder(
      borderSide: BorderSide.none,
    ),*/
          hintText: "Search",
          suffixIcon: Icon(
            // Feather.search,
            Icons.search_rounded,
            color: Theme.of(context).primaryColor,
          ),
          hintStyle: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.normal,
            color: Theme.of(context).primaryColor.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}
