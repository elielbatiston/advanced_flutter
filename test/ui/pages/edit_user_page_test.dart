import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/fakers.dart';

final class EditUserViewModel {
  bool isNaturalPerson;

  EditUserViewModel({
    required this.isNaturalPerson
  });
}

final class EditUserPage extends StatelessWidget {
  final Future<EditUserViewModel> Function() loadUserData;

  const EditUserPage({
    super.key,
    required this.loadUserData
  });

  @override
  Widget build(BuildContext context) {
    loadUserData();

    /* Exemplo com Radio
    return Scaffold(
      body: Row(
        children: [
          Radio(
            key: Key('pf'), //isso aqui é um codigo de teste em producao. Ele nao recomenda
            value: true,
            groupValue: true,
            onChanged: (value) {}
          ),
          Text('Pessoa física')
        ]
      )
    );
    */

    return FutureBuilder<EditUserViewModel>(
      future: loadUserData(),
      builder: (context, snapshot) {
        return Scaffold(
          body: Column(
            children: [
              RadioListTile(
                title: Text('Pessoa física'),
                value: true,
                groupValue: snapshot.data?.isNaturalPerson,
                onChanged: (value) {}
              ),
              RadioListTile(
                title: Text('Pessoa jurídica'),
                value: false,
                groupValue: snapshot.data?.isNaturalPerson,
                onChanged: (value) {}
              )
            ]
          )
        );
      }
    );
  }
}

final class LoadUserDataSpy {
  var isCalled = false;
  var response = EditUserViewModel(isNaturalPerson: anyBool());

  Future<EditUserViewModel> call() async {
    isCalled = true;
    return response;
  }
}

void main() {
  testWidgets('should load user data on page init', (tester) async {
    final loadUserData = LoadUserDataSpy();
    final sut = MaterialApp(home: EditUserPage(loadUserData: loadUserData.call));
    await tester.pumpWidget(sut);
    expect(loadUserData.isCalled, true);
  });

  testWidgets('should check natural person', (tester) async {
    final loadUserData = LoadUserDataSpy();
    loadUserData.response = EditUserViewModel(isNaturalPerson: true);
    final sut = MaterialApp(home: EditUserPage(loadUserData: loadUserData.call));
    await tester.pumpWidget(sut);
    await tester.pump();
    // expect(find.byKey(Key('pf')), findsOneWidget); isso aqui é um codigo de teste em producao. Ele nao recomenda
    /* Ele não terminou o codigo porque disse que o Radio não tem uma propriedade checked ou selected e a galera faz o teste validando
         se o campo está colorido  e ele prefere usar o RadioListTile
    expect(
      tester.widget<Radio>(find.descendant(of: find.ancestor(
        of: find.text('Pessoa física'), matching: find.byType(Row)),
        matching: find.byType(Radio<bool>
      ))).activeColor == 'xpto',
      findsOneWidget
    );
    */

    expect(
      tester.widget<RadioListTile>(find.ancestor(of: find.text('Pessoa física'), matching: find.byType(RadioListTile<bool>))).checked,
      true
    );
    expect(
      tester.widget<RadioListTile>(find.ancestor(of: find.text('Pessoa jurídica'), matching: find.byType(RadioListTile<bool>))).checked,
      false
    );
  });

  testWidgets('should check legal person', (tester) async {
    final loadUserData = LoadUserDataSpy();
    loadUserData.response = EditUserViewModel(isNaturalPerson: false);
    final sut = MaterialApp(home: EditUserPage(loadUserData: loadUserData.call));
    await tester.pumpWidget(sut);
    await tester.pump();
    expect(
      tester.widget<RadioListTile>(find.ancestor(of: find.text('Pessoa física'), matching: find.byType(RadioListTile<bool>))).checked,
      false
    );
    expect(
      tester.widget<RadioListTile>(find.ancestor(of: find.text('Pessoa jurídica'), matching: find.byType(RadioListTile<bool>))).checked,
      true
    );
  });
}
