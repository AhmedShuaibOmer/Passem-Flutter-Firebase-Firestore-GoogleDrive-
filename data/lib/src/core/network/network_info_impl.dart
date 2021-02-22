/*
 * Created Date: 2/8/21 11:41 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021 SafePass
 *
 */
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:domain/domain.dart';
import 'package:meta/meta.dart';

class NetworkInfoImpl implements NetworkInfo {
  final DataConnectionChecker dataConnectionChecker;

  NetworkInfoImpl({@required this.dataConnectionChecker});

  @override
  Future<bool> get isConnected => dataConnectionChecker.hasConnection;
}
