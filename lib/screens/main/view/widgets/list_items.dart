/*
 * Created Date: 3/9/21 1:18 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../di/di.dart';
import '../../../../generated/l10n.dart';
import '../../../../router/router.dart';

TextButton courseListItem(
  CourseEntity courseEntity,
  BuildContext context,
) {
  return TextButton(
    style: TextButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
    ),
    child: Container(
      constraints: BoxConstraints(
        minWidth: 100,
        minHeight: 50,
        maxHeight: 500,
        maxWidth: 500,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.all(8),
            constraints: BoxConstraints(maxWidth: 56, maxHeight: 56),
            child: AspectRatio(
              aspectRatio: 1,
              child: Icon(
                Icons.my_library_books_rounded,
                size: 48,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    courseEntity.name,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Container(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Builder(builder: (ctx) {
                      bool isSubscribed = ctx
                          .select(
                              (AuthenticationBloc ab) => ab.state.user.courses)
                          .contains(courseEntity.id);
                      return TextButton.icon(
                        label: Text(isSubscribed
                            ? S.of(context).remove_from_my_courses
                            : S.of(context).add_to_my_courses),
                        onPressed: () {
                          if (isSubscribed) {
                            sl<UserRepository>()
                                .unsubscribeFromCourse(courseEntity.id);
                          } else {
                            sl<UserRepository>()
                                .subscribeToCourse(courseEntity.id);
                          }
                        },
                        icon: Icon(
                          isSubscribed
                              ? Icons.remove_circle_outline_rounded
                              : Icons.add_circle_outline_outlined,
                          color: isSubscribed ? Colors.red : Colors.green,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    onPressed: () {
      ExtendedNavigator.root.push(
        Routes.courseScreen,
        arguments: CourseScreenArguments(course: courseEntity),
      );
    },
  );
}
