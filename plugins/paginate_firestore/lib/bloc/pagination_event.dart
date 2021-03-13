/*
 * Created Date: 3/11/21 11:36 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class PaginationEvent {}

class PaginationFilterListRequested extends PaginationEvent {
  final String filterTerm;

  PaginationFilterListRequested(this.filterTerm);
}

class PaginationRefreshListRequested extends PaginationEvent {}

class PaginationFetchListRequested extends PaginationEvent {
  final Query query;

  PaginationFetchListRequested({this.query});
}
