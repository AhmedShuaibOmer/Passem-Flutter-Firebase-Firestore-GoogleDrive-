/*
 * Created Date: 2/26/21 9:49 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:http/http.dart';

class GoogleAuthClient extends BaseClient {
  final Map<String, String> _headers;

  final Client _client = new Client();

  GoogleAuthClient(this._headers);

  Future<StreamedResponse> send(BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}
