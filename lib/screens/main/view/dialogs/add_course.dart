/*
 * Created Date: 3/12/21 1:34 AM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:passem/di/di.dart';
import 'package:passem/generated/l10n.dart';

import '../../../../widgets/widget.dart';
import '../widgets/widgets.dart';

class AddCourse extends StatelessWidget {
  final ProgressButtonController _progressButtonController =
      ProgressButtonController();

  AddCourse();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return AddCourseBloc(sl());
      },
      child: Builder(
        builder: (context) {
          // ignore: close_sinks
          final AddCourseBloc addCBloc = context.read<AddCourseBloc>();

          return FormBlocListener<AddCourseBloc, String, String>(
            onSubmitting: (context, state) {
              _progressButtonController
                  .setButtonState(ProgressButtonState.inProgress);
            },
            onFailure: (context, state) {
              _progressButtonController
                  .setButtonState(ProgressButtonState.error);
            },
            onSuccess: (context, state) {
              Navigator.pop<String>(context, state.successResponse);
            },
            child: Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Container(
                    height: 60,
                    alignment: AlignmentDirectional.centerEnd,
                    child: IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  MyTextFieldBlocBuilder(
                    hintText: S.of(context).course_name_hint,
                    textFieldBloc: addCBloc.courseName,
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ProgressButton(
                      child: Text(S.of(context).add_course,
                          style: TextStyle(color: Colors.white)),
                      controller: _progressButtonController,
                      onPressed: () {
                        addCBloc.submit();
                      }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
