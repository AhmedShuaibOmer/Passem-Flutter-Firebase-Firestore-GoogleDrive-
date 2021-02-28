/*
 * Created Date: 2/26/21 2:32 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

part of 'my_courses_bloc.dart';

abstract class MyCoursesState extends Equatable {
  const MyCoursesState();
}

class MyCoursesInitial extends MyCoursesState {
  @override
  List<Object> get props => [];
}
