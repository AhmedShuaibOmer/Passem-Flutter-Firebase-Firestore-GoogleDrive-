/*
 * Created Date: 2/28/21 1:01 AM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class CollegeEntity extends Equatable {
  const CollegeEntity({
    @required this.id,
    @required this.name,
  })  : assert(id != null),
        assert(name != null);

  final String id;

  final String name;

  /// Empty course.
  static const empty = CollegeEntity(
    id: '',
    name: '',
  );

  @override
  List<Object> get props => [id, name];
}
