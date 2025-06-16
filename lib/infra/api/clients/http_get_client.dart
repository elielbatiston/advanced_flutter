import 'package:advanced_flutter/infra/types/api.dart';

abstract class HttpGetClient {
  Future<T> get<T>({required String url, Json? params});
}
