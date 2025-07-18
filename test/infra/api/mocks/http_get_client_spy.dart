import 'package:advanced_flutter/infra/api/clients/http_get_client.dart';
import 'package:advanced_flutter/infra/types/json.dart';

import '../../../mocks/fakers.dart';

final class HttpGetClientSpy implements HttpGetClient {
  String? url;
  int callsCount = 0;
  Json? headers;
  Json? params;
  Json? queryString;
  dynamic response = anyJson();
  Error? error;

  @override
  Future<dynamic> get({ required String url, Json? headers, Json? params, Json? queryString }) async {
    this.url = url;
    this.headers = headers;
    this.params = params;
    this.queryString = queryString;
    callsCount++;
    if (error != null) throw error!;
    return response;
  }
}
