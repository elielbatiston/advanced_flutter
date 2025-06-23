/*
  foi adicionado essa diretiva pois o teste 'should emit correct events on reload with error' falha, o teste fica em loOpacity
  aguardando o resultado e o timeout é de 30 segundos.
  Para diminuir o timeout, podemos colocar o timeout direto no teste dessa forma:

  test('should emit correct events on reload with error', () async {
    ... seu teste aqui
  }, timeout: const Timeout(Duration(seconds: 1)));

  ou você mantem o teste sem o timeout e coloca a diretiva que servirá para todos os testes
*/
@Timeout(Duration(seconds: 1))
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

import '../../helpers/fakers.dart';

final class NextEventRxPresenter {
  final Future<void> Function({ required String groupId }) nextEventLoader;
  final nextEventSubject = BehaviorSubject();
  final isBusySubject = BehaviorSubject<bool>();

  NextEventRxPresenter({ required this.nextEventLoader });

  Stream get nextEventStream => nextEventSubject.stream;
  Stream<bool> get isBusyStream => isBusySubject.stream;

  Future<void> loadNextEvent({ required String groupId, bool isReload = false }) async {
    try {
      if (isReload) isBusySubject.add(true);
      await nextEventLoader(groupId: groupId);
    } catch (error) {
      nextEventSubject.addError(error);
    } finally {
      if (isReload) isBusySubject.add(false);
    }
  }
}

final class NextEventLoaderSpy {
  int callsCount = 0;
  String? groupId;
  Error? error;

  Future<void> call({ required String groupId }) async {
    this.groupId = groupId;
    callsCount++;
    if (error != null) throw error!;
  }
}

void main() {
  late NextEventLoaderSpy nextEventLoader;
  late String groupId;
  late NextEventRxPresenter sut;

  setUp(() {
    nextEventLoader = NextEventLoaderSpy();
    groupId = anyString();
    sut = NextEventRxPresenter(nextEventLoader: nextEventLoader.call);
  });

  test('should get event data', () async {
    await sut.loadNextEvent(groupId: groupId);
    expect(nextEventLoader.groupId, groupId);
    expect(nextEventLoader.callsCount, 1);
  });

  test('should emit correct events on reload with error', () async {
    nextEventLoader.error = Error();
    // A instrução abaixo é igual a expectLater. O expectLater é um syntactic sugar
    // sut.nextEventStream.listen(null, onError: (error) {
    //   expect(error, nextEventLoader.error);
    // });
    expectLater(sut.nextEventStream, emitsError(nextEventLoader.error));
    expectLater(sut.isBusyStream, emitsInOrder([true, false]));
    await sut.loadNextEvent(groupId: groupId, isReload: true);
    expect(nextEventLoader.groupId, groupId);
    expect(nextEventLoader.callsCount, 1);
  });

  test('should emit correct events on load with error', () async {
    nextEventLoader.error = Error();
    expectLater(sut.nextEventStream, emitsError(nextEventLoader.error));
    sut.isBusyStream.listen(neverCalled);
    await sut.loadNextEvent(groupId: groupId);
    expect(nextEventLoader.groupId, groupId);
    expect(nextEventLoader.callsCount, 1);
  });

  test('should emit correct events on reload with success', () async {
    expectLater(sut.isBusyStream, emitsInOrder([true, false]));
    await sut.loadNextEvent(groupId: groupId, isReload: true);
    expect(nextEventLoader.groupId, groupId);
    expect(nextEventLoader.callsCount, 1);
  });

  test('should emit correct events on load with success', () async {
    sut.isBusyStream.listen(neverCalled);
    await sut.loadNextEvent(groupId: groupId);
    expect(nextEventLoader.groupId, groupId);
    expect(nextEventLoader.callsCount, 1);
  });
}
