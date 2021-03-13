import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class PaginateChangeListener extends ChangeNotifier {}

class PaginateRefreshedChangeListener extends PaginateChangeListener {
  PaginateRefreshedChangeListener();

  bool _refreshed = false;

  set refreshed(bool value) {
    _refreshed = value;
    if (value) {
      notifyListeners();
    }
  }

  bool get refreshed {
    return _refreshed;
  }
}

class PaginateFilterChangeListener extends PaginateChangeListener {
  PaginateFilterChangeListener();

  String _filterTerm;

  set searchTerm(String value) {
    _filterTerm = value;
    if (value.isNotEmpty) {
      notifyListeners();
    }
  }

  String get searchTerm {
    return _filterTerm;
  }
}

class PaginateQueryChangeListener extends PaginateChangeListener {
  PaginateQueryChangeListener();

  Query _query;

  set query(Query query) {
    if (query != null && query != _query) {
      _query = query;
      notifyListeners();
    }
  }

  Query get query {
    return _query;
  }
}
