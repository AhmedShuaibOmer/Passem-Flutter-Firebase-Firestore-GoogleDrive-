/*
 * Created Date: 3/12/21 11:17 AM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import '../../../../di/di.dart';
import '../../../../generated/l10n.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/widget.dart';
import '../../view/widgets/widgets.dart';

class AddExternalStudyMaterial extends StatelessWidget {
  final ProgressButtonController _progressButtonController =
      ProgressButtonController();
  final CourseEntity targetedCourse;

  AddExternalStudyMaterial({@required this.targetedCourse});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return AddExternalMaterialBloc(sl());
      },
      child: Builder(
        builder: (context) {
          // ignore: close_sinks
          final AddExternalMaterialBloc addExMBloc =
              context.read<AddExternalMaterialBloc>();
          addExMBloc.course.updateItems([targetedCourse]);
          addExMBloc.course.updateValue(targetedCourse);
          return FormBlocListener<AddExternalMaterialBloc, String, String>(
            onSubmitting: (context, state) {
              _progressButtonController
                  .setButtonState(ProgressButtonState.inProgress);
            },
            onFailure: (context, state) {
              _progressButtonController
                  .setButtonState(ProgressButtonState.error);
            },
            onSuccess: (context, state) {
              Navigator.pop(context, state.successResponse);
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
                      textFieldBloc: addExMBloc.link,
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                      hintText: S.of(context).paste_link_here,
                      suffixIcon: addExMBloc.link.value.isEmpty
                          ? IconButton(
                              icon: Icon(Icons.paste_rounded),
                              onPressed: () async {
                                final String text = await pasteFromClipboard();
                                addExMBloc.link.updateValue(text);
                              },
                            )
                          : IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                addExMBloc.link.clear();
                              },
                            )),
                  SizedBox(
                    height: 10,
                  ),
                  MyTextFieldBlocBuilder(
                    textFieldBloc: addExMBloc.title,
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    hintText: S.of(context).type_short_title,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MyTextFieldBlocBuilder(
                    textFieldBloc: addExMBloc.description,
                    minLines: 5,
                    maxLines: 10,
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    hintText: S.of(context).add_description,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ProgressButton(
                      child: Text(
                        S.of(context).add,
                        style: TextStyle(color: Colors.white),
                      ),
                      controller: _progressButtonController,
                      onPressed: () {
                        addExMBloc.submit();
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
