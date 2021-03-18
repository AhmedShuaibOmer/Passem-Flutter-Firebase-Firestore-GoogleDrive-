/*
 * Created Date: 2/26/21 12:36 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class CourseEntity extends Equatable {
  final String id;
  final String name;
  final String deepLink;

  CourseEntity({
    @required this.id,
    @required this.name,
    @required this.deepLink,
  }) : assert(id != null && name != null && deepLink != null);

  @override
  List<Object> get props => [
        id,
        name,
        deepLink,
      ];
}
