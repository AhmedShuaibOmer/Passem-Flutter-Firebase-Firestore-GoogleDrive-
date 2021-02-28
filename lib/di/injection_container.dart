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
import 'package:passem/screens/main/bloc/navigation_bloc.dart';
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
      collegeRepository: sl(),
      universityRepository: sl(),
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

  sl.registerFactory(
    () => NavigationBloc(),
  );

  //! Repositories
  sl.registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepositoryImpl(
            firestoreService: sl(),
            firebaseAuthService: sl(),
            googleAuthService: sl(),
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

  sl.registerLazySingleton<CollegeRepository>(
    () => CollegeRepositoryImpl(
      firestoreService: sl(),
    ),
  );

  sl.registerLazySingleton<CourseRepository>(
    () => CourseRepositoryImpl(
      firestoreService: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<StudyMaterialRepository>(
    () => StudyMaterialRepositoryImpl(
      firestoreService: sl(),
      networkInfo: sl(),
      googleDriveService: sl(),
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

  final googleDriveService = GoogleDriveService.instance;
  sl.registerLazySingleton(() => googleDriveService);

  final googleAuthService = GoogleAuthService.instance;
  sl.registerLazySingleton(() => googleAuthService);

  //! External
  sl.registerLazySingleton(() => DataConnectionChecker());
}
