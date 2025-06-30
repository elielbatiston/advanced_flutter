import 'package:advanced_flutter/domain/entities/errors.dart';
import 'package:advanced_flutter/domain/entities/next_event.dart';
import 'package:advanced_flutter/infra/api/repositories/load_next_event_api_repo.dart';

import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/fakers.dart';
import '../../mocks/mapper_spy.dart';
import '../mocks/http_get_client_spy.dart';

void main() {
  late String groupId;
  late String url;
  late HttpGetClientSpy httpClient;
  late MapperSpy<NextEvent> mapper;
  late LoadNextEventApiRepository sut;

  setUp(() {
    groupId = anyString();
    url = anyString();
    httpClient = HttpGetClientSpy();
    mapper = MapperSpy(toDtoOutput: anyNextEvent());
    sut = LoadNextEventApiRepository(httpClient: httpClient, url: url, mapper: mapper);
  });

  test('should call HttpClient with correct input', () async {
    await sut.loadNextEvent(groupId: groupId);
    expect(httpClient.url, url);
    expect(httpClient.params, {"groupId": groupId});
    expect(httpClient.callsCount, 1);
  });

  test('should request NextEvent on success', () async {
    final event = await sut.loadNextEvent(groupId: groupId);
    expect(event, mapper.toDtoOutput);
    expect(mapper.toDtoInput, httpClient.response);
    expect(mapper.toDtoInputCallsCount, 1);
  });

  test('should rethrow on error', () async {
    final error = Error();
    httpClient.error = error;
    final future = sut.loadNextEvent(groupId: groupId);
    expect(future, throwsA(error));
  });

  test('should throw UnexpectedError on null response', () async {
    httpClient.response = null;
    final future = sut.loadNextEvent(groupId: groupId);
    expect(future, throwsA(isA<UnexpectedError>()));
  });
}
