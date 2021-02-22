/*
 * Created Date: 2/19/21 8:39 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:domain/domain.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passem/generated/l10n.dart';
import 'package:passem/widgets/progress_button.dart';
import 'package:passem/widgets/widget.dart';

class NewUserView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final newUserCubit = BlocProvider.of<NewUserCubit>(context);
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: BlocListener<NewUserCubit, NewUserState>(
        listener: (context, state) {
          switch (state.status) {
            case NewUserStatus.setupSuccess:
              // TODO: Handle this case.
              break;
            case NewUserStatus.setupFailure:
              OperationFailedAlert(
                context,
                message: S.of(context).new_user_setup_failure,
              ).show(context);
              break;
            case NewUserStatus.noConnectionFailure:
              NoConnectionAlert(
                context,
                specificMessage: S.of(context).new_user_no_internet_failure,
              ).show(context);
              break;
            case NewUserStatus.loading:
              // TODO: Handle this case.
              break;
            case NewUserStatus.unknown:
              break;
          }
        },
        child: Container(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: height,
                padding: EdgeInsets.symmetric(horizontal: 16),
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * .2,
                      ),
                      Builder(
                        builder: (context) {
                          final userPhoto = context.select(
                            (AuthenticationBloc bloc) =>
                                bloc.state.user.photoUrl,
                          );
                          return CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.transparent,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                maxHeightDiskCache: 300,
                                maxWidthDiskCache: 300,
                                imageUrl: userPhoto.substring(
                                        0, userPhoto.length - 15) +
                                    's600-c/photo.jpg',
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
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
                          ); // TODO /*$S.of(context).welcome*/
                          return Text(
                            'Welcome, $name',
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
                            (NewUserCubit c) => c.universities,
                          );
                          return DropdownSearch(
                            mode: Mode.BOTTOM_SHEET,
                            label: 'Which University do you study in?',
                            hint: 'Pick your University',
                            items: universities,
                            itemAsString: (university) => university.name,
                            showSearchBox: true,
                            showClearButton: true,
                            popupBackgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            onChanged: (university) {
                              print(university.name);
                              newUserCubit.selectedUniversity = university;
                            },
                            clearButton: const Icon(
                              Icons.clear,
                              size: 24,
                              color: Colors.white,
                            ),
                            dropDownButton: const Icon(
                              Icons.arrow_drop_down,
                              size: 24,
                              color: Colors.white,
                            ),
                            popupShape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0)),
                            ),
                            searchBoxDecoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                size: 24,
                                color: Theme.of(context).primaryColorLight,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 16,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(30.0)),
                              ),
                              labelStyle: TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                            dropdownSearchDecoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 16,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(30.0)),
                              ),
                              hintStyle: TextStyle(
                                color: Colors.white70,
                              ),
                              labelStyle: TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      ProgressButton(
                        defaultWidget: Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        progressWidget: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).accentColor),
                        ),
                        color: Colors.white,
                        height: 56,
                        borderRadius: 28,
                        type: ProgressButtonType.Raised,
                        onPressed: () async {
                          // After [onPressed], it will trigger animation running backwards, from end to beginning
                          await newUserCubit.submitDetails();
                          return () {
                            // Optional returns is returning a VoidCallback that will be called
                            // after the animation is stopped at the beginning.
                            // A best practice would be to do time-consuming task in [onPressed],
                            // and do page navigation in the returned VoidCallback.
                            // So that user won't missed out the reverse animation.
                          };
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
