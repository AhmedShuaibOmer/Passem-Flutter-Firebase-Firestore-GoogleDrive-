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
import 'package:passem/utils/utils.dart';

import '../../../../di/di.dart';
import '../../../../generated/l10n.dart';
import '../../../../widgets/widget.dart';
import '../../view/widgets/widgets.dart';

class AddStudyMaterial extends StatelessWidget {
  final ProgressButtonController _progressButtonController =
      ProgressButtonController();
  final CourseEntity targetedCourse;

  AddStudyMaterial({@required this.targetedCourse});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return AddStudyMaterialBloc(sl());
      },
      child: Builder(
        builder: (context) {
          // ignore: close_sinks
          final AddStudyMaterialBloc addSMBloc =
              context.read<AddStudyMaterialBloc>();
          addSMBloc.course.updateItems([targetedCourse]);
          addSMBloc.course.updateValue(targetedCourse);

          return FormBlocListener<AddStudyMaterialBloc, String, String>(
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
                      textFieldBloc: addSMBloc.link,
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                      hintText: S.of(context).paste_link_here,
                      suffixIcon: addSMBloc.link.value.isEmpty
                          ? IconButton(
                              icon: Icon(Icons.paste_rounded),
                              onPressed: () async {
                                final String text = await pasteFromClipboard();
                                addSMBloc.link.updateValue(text);
                              },
                            )
                          : IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                addSMBloc.link.clear();
                              },
                            )),
                  SizedBox(
                    height: 10,
                  ),
                  MyTextFieldBlocBuilder(
                    textFieldBloc: addSMBloc.title,
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    hintText: S.of(context).type_short_title,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MyTextFieldBlocBuilder(
                    textFieldBloc: addSMBloc.description,
                    minLines: 5,
                    maxLines: 10,
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    hintText: S.of(context).add_description,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MyDropdownSearch<StudyMaterialType>(
                    label: S.of(context).category_of_file,
                    hint: S.of(context).pick_file_category,
                    items: addSMBloc.type.state.items,
                    itemAsString: (item) {
                      return getMaterialTypString(item, context);
                    },
                    onChanged: (item) {
                      addSMBloc.type.updateValue(item);
                    },
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
                        addSMBloc.submit();
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
