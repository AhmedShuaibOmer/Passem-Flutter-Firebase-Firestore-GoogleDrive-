/*
 * Created Date: 2/19/21 8:39 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import '../../../di/di.dart';
import '../../../generated/l10n.dart';
import '../../../router/router.dart';
import '../../../widgets/widget.dart';

class NewUserView extends StatelessWidget {
  final ProgressButtonController _progressButtonController =
      ProgressButtonController();

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final newUserBloc = BlocProvider.of<NewUserBloc>(context);
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            ExtendedNavigator.of(context).pushAndRemoveUntil(
              Routes.mainScreen,
              (route) => false,
            );
          }
        },
        child: FormBlocListener<NewUserBloc, String, String>(
          onSubmitting: (context, state) {
            _progressButtonController
                .setButtonState(ProgressButtonState.inProgress);
          },
          onFailure: (context, state) {
            _progressButtonController.setButtonState(ProgressButtonState.error);
            OperationFailedAlert(
              context,
              message: S.of(context).new_user_setup_failure,
            ).show(context);
          },
          child: BlocBuilder<NewUserBloc, FormBlocState>(
            buildWhen: (previous, current) =>
                previous.runtimeType != current.runtimeType ||
                previous is FormBlocLoading && current is FormBlocLoading,
            builder: (context, state) {
              if (state is FormBlocLoading) {
                return Scaffold(
                    backgroundColor: Theme.of(context).primaryColor,
                    body: Center(child: CircularProgressIndicator()));
              } else if (state is FormBlocLoadFailed) {
                return LoadFailed(
                  onTryAgain: () => newUserBloc.reload(),
                );
              } else
                return buildLoadedView(height, newUserBloc, context);
            },
          ),
        ),
      ),
    );
  }

  ListView buildLoadedView(
      double height, NewUserBloc newUserBloc, BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 32),
      physics: BouncingScrollPhysics(),
      children: [
        SizedBox(
          height: height * .2,
        ),
        Builder(
          builder: (context) {
            final userPhoto = context.select(
              (AuthenticationBloc bloc) => bloc.state.user.photoUrl,
            );
            return CircleAvatar(
              radius: 60,
              backgroundColor: Colors.transparent,
              child: ClipOval(
                  child: ProfileImage(
                userPhotoUrl: userPhoto,
                scale: 600,
              )),
            );
          },
        ),
        SizedBox(
          height: 30,
        ),
        Builder(
          builder: (context) {
            final name = context.select(
              (AuthenticationBloc c) => c.state.user.name,
            );
            return Text(
              '${S.of(context).welcome}, $name',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            );
          },
        ),
        SizedBox(
          height: 80,
        ),
        Builder(
          builder: (context) {
            final universities = context.select(
              (NewUserBloc c) => c.university.state.items,
            );
            return MyDropdownSearch<UniversityEntity>(
              label: S.of(context).pick_university_label,
              hint: S.of(context).pick_university_hint,
              items: universities,
              selectedItem: newUserBloc.university.value,
              onChanged: (university) {
                print(university.name);
                newUserBloc.university.updateValue(university);
              },
            );
          },
        ),
        SizedBox(
          height: 30,
        ),
        Builder(
          builder: (context) {
            final colleges = context.select(
              (NewUserBloc c) => c.college.state.items,
            );
            return MyDropdownSearch<CollegeEntity>(
              label: S.of(context).pick_college_label,
              hint: S.of(context).pick_college_hint,
              items: colleges,
              selectedItem: newUserBloc.college.value,
              onChanged: (college) {
                print(college.name);
                newUserBloc.college.updateValue(college);
              },
            );
          },
        ),
        SizedBox(
          height: 40,
        ),
        ProgressButton(
          child: Text(
            S.of(context).continue_text,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          onPressed: () async {
            final NetworkInfo networkInfo = sl<NetworkInfo>();
            if (await networkInfo.isConnected) {
              newUserBloc.submit();
            } else {
              NoConnectionAlert(
                context,
                specificMessage: S.of(context).new_user_no_internet_failure,
              ).show(context);
            }
          },
          controller: _progressButtonController,
          progressColor: Theme.of(context).primaryColor,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
      ],
    );
  }
}
