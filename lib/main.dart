/*
 * 
 * Created Date: Friday, January 22nd 2021, 11:12:20 am
 * Author: Ahmed S.Omer
 * 
 * Copyright (c) 2021 SafePass
 */
import 'package:domain/domain.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passem/theme/bloc/theme_bloc.dart';

import 'app.dart';
import 'di/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initializing firebase app to it services.
  await Firebase.initializeApp();
  // Initializing dependency injector with all of our required dependencies.
  await initDI();

  runApp(
    // Blocs injected here are global blocs lives throughout the
    // entire app life.
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<ThemeBloc>()
            ..add(
              ThemeLoadStarted(),
            ),
        ),
        BlocProvider(
          create: (_) => sl<AuthenticationBloc>(),
        ),
      ],
      child: App(),
    ),
  );
}
