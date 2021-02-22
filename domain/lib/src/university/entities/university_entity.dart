/*
 * Created Date: 2/19/21 8:28 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class UniversityEntity extends Equatable {
  const UniversityEntity({
    @required this.id,
    @required this.name,
    this.logoUrl,
  })  : assert(id != null),
        assert(name != null);

  final String id;

  final String name;

  final String logoUrl;

  @override
  List<Object> get props => [id, name, logoUrl];
}
