/*
 * Created Date: 2/17/21 10:12 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021 SafePass
 *
 */

import 'package:data/data.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:domain/domain.dart';
import 'package:get_it/get_it.dart';
import 'package:passem/theme/bloc/theme_bloc.dart';

GetIt sl = GetIt.instance;

Future<void> initDI() async {
  sl.registerFactory(
    () => ThemeBloc(
      sharedPrefService: sl(),
    ),
  );

  //! Features
  sl.registerFactory(
    () => AuthenticationBloc(
      authenticationRepository: sl(),
      userRepository: sl(),
    ),
  );

  sl.registerFactory(
    () => LoginCubit(
      authenticationRepository: sl(),
    ),
  );

  sl.registerFactory(
    () => NewUserCubit(
      universityRepository: sl(),
      userRepository: sl(),
    ),
  );

  //! Repositories
  sl.registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepositoryImpl(
            firestoreService: sl(),
            firebaseAuthService: sl(),
            networkInfo: sl(),
          ));

  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      firestoreService: sl(),
      firebaseAuthService: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<UniversityRepository>(
    () => UniversityRepositoryImpl(
      firestoreService: sl(),
    ),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      dataConnectionChecker: sl(),
    ),
  );

  //! Services
  final sharedPrefsService = await SharedPreferencesService.instance;
  sl.registerLazySingleton(() => sharedPrefsService);

  final firestoreService = FirestoreService.instance;
  sl.registerLazySingleton(() => firestoreService);

  final firebaseAuthService = FirebaseAuthService.instance;
  sl.registerLazySingleton(() => firebaseAuthService);

  //! External
  sl.registerLazySingleton(() => DataConnectionChecker());
}
