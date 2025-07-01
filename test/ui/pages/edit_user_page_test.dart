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
  late LoadUserDataSpy loadUserData;
  late Widget sut;

  setUp(() {
    loadUserData = LoadUserDataSpy();
    sut = MaterialApp(home: EditUserPage(loadUserData: loadUserData.call));
  });

  testWidgets('should load user data on page init', (tester) async {
    await tester.pumpWidget(sut);
    expect(loadUserData.isCalled, true);
  });

  testWidgets('should check natural person', (tester) async {
    loadUserData.response = EditUserViewModel(isNaturalPerson: true);
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

    /* Exemplo de simplificacao usando o extension
    expect(
      tester.widget<RadioListTile>(find.ancestor(of: find.text('Pessoa física'), matching: find.byType(RadioListTile<bool>))).checked,
      true
    );
    expect(
      tester.widget<RadioListTile>(find.ancestor(of: find.text('Pessoa jurídica'), matching: find.byType(RadioListTile<bool>))).checked,
      false
    );
    */

    expect(tester.naturalPersonRadio.checked, true);
    expect(tester.legalPersonRadio.checked, false);
  });

  testWidgets('should check legal person', (tester) async {
    loadUserData.response = EditUserViewModel(isNaturalPerson: false);
    await tester.pumpWidget(sut);
    await tester.pump();
    expect(tester.naturalPersonRadio.checked, false);
    expect(tester.legalPersonRadio.checked, true);
  });
}

extension EditUserPageExtension on WidgetTester {
  Finder get naturalPersonFinder => find.ancestor(of: find.text('Pessoa física'), matching: find.byType(RadioListTile<bool>));
  Finder get legalPersonFinder => find.ancestor(of: find.text('Pessoa jurídica'), matching: find.byType(RadioListTile<bool>));
  RadioListTile get naturalPersonRadio => widget(naturalPersonFinder);
  RadioListTile get legalPersonRadio => widget(legalPersonFinder);
}
