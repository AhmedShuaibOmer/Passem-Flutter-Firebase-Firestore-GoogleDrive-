import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'pagination_event.dart';

part 'pagination_state.dart';

class PaginationBloc extends Bloc<PaginationEvent, PaginationState> {
  PaginationBloc(
    this._limit,
    this._startAfterDocument, {
    this.isLive = false,
  }) : super(PaginationInitial());

  DocumentSnapshot _lastDocument;
  final int _limit;
  final DocumentSnapshot _startAfterDocument;
  final bool isLive;
  Query _query;

  @override
  Stream<PaginationState> mapEventToState(PaginationEvent event) async* {
    if (event is PaginationFetchListRequested) {
      yield* _mapPaginationFetchListRequestedToState(event);
    } else if (event is PaginationRefreshListRequested) {
      yield* _mapPaginationRefreshListRequestedToState(event);
    } else if (event is PaginationFilterListRequested) {
      yield* _mapPaginationFilterListRequestedToState(event);
    }
  }

  Stream<PaginationState> _mapPaginationFetchListRequestedToState(
      PaginationFetchListRequested event) async* {
    var oldQuery = _query;
    if (event.query != null) {
      _query = event.query;
    }
    var newQuery = _query;

    try {
      if (state is PaginationInitial) {
        debugPrint('Pagination bloc: initial state to loaded');
        add(PaginationRefreshListRequested());
      } else if (state is PaginationLoaded && newQuery != oldQuery) {
        debugPrint('Pagination bloc: loaded state to initial');
        yield PaginationInitial();
        add(PaginationRefreshListRequested());
      } else if (state is PaginationLoaded) {
        final localQuery = query;
        final loadedState = state as PaginationLoaded;
        if (loadedState.hasReachedEnd) return;
        if (isLive) {
          yield* localQuery.snapshots().map((querySnapshot) {
            return _mapSnapshotsToState(
              querySnapshot.docs,
              previousList:
                  loadedState.documentSnapshots as List<QueryDocumentSnapshot>,
            );
          });
        } else {
          final querySnapshot = await localQuery.get();
          yield _mapSnapshotsToState(
            querySnapshot.docs,
            previousList:
                loadedState.documentSnapshots as List<QueryDocumentSnapshot>,
          );
        }
      }
    } on PlatformException catch (exception) {
      print(exception);
      rethrow;
    }
  }

  Stream<PaginationState> _mapPaginationRefreshListRequestedToState(
      PaginationRefreshListRequested event) async* {
    _lastDocument = null;
    final localQuery = query;
    if (isLive) {
      yield* localQuery.snapshots().map((querySnapshot) {
        return _mapSnapshotsToState(querySnapshot.docs);
      });
    } else {
      final querySnapshot = await localQuery.get();
      yield _mapSnapshotsToState(querySnapshot.docs);
    }
  }

  Stream<PaginationState> _mapPaginationFilterListRequestedToState(
      PaginationFilterListRequested event) async* {
    if (state is PaginationLoaded) {
      final loadedState = state as PaginationLoaded;

      final filteredList = loadedState.documentSnapshots
          .where((document) => document
              .data()
              .toString()
              .toLowerCase()
              .contains(event.filterTerm.toLowerCase()))
          .toList();

      yield loadedState.copyWith(
        documentSnapshots: filteredList,
        hasReachedEnd: loadedState.hasReachedEnd,
      );
    }
  }

  PaginationState _mapSnapshotsToState(
    List<QueryDocumentSnapshot> newList, {
    List<QueryDocumentSnapshot> previousList = const [],
  }) {
    print('Pagination bloc : received new list-length = ${newList.length}');
    _lastDocument = newList.isNotEmpty ? newList.last : null;
    return PaginationLoaded(
      documentSnapshots: previousList + newList,
      hasReachedEnd: newList.isEmpty,
    );
  }

  Query get query {
    var localQuery = (_lastDocument != null)
        ? _query.startAfterDocument(_lastDocument)
        : _startAfterDocument != null
            ? _query.startAfterDocument(_startAfterDocument)
            : _query;
    localQuery = localQuery.limit(_limit);
    return localQuery;
  }
}
