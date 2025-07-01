import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/fakers.dart';

final class EditUserViewModel {
  bool isNaturalPerson;
  bool showCpf;
  bool showCnpj;
  String? cpf;

  EditUserViewModel({
    required this.isNaturalPerson,
    required this.showCpf,
    required this.showCnpj,
    this.cpf
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
              ),
              if (snapshot.data?.showCpf == true) TextFormField(
                keyboardType: TextInputType.numberWithOptions(),
                initialValue: snapshot.data?.cpf,
                decoration: InputDecoration(
                  labelText: 'CPF'
                )
              ),
              if (snapshot.data?.showCnpj == true) TextFormField(
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  labelText: 'CNPJ'
                )
              )
            ]
          )
        );
      }
    );
  }
}

final class LoadUserDataSpy {
  var callsCount = 0;
  var _response = EditUserViewModel(isNaturalPerson: anyBool(), showCpf: anyBool(), showCnpj: anyBool(), cpf: anyString());

  void modkResponse({ bool? isNaturalPerson, bool? showCpf, bool? showCnpj, String? cpf }) {
    _response = EditUserViewModel(
      isNaturalPerson: isNaturalPerson ?? anyBool(),
      showCpf: showCpf ?? anyBool(),
      showCnpj: showCnpj ?? anyBool(),
      cpf: cpf
    );
  }

  Future<EditUserViewModel> call() async {
    callsCount++;
    return _response;
  }
}

void main() {
  late String cpf;
  late LoadUserDataSpy loadUserData;
  late Widget sut;

  setUp(() {
    cpf = anyString();
    loadUserData = LoadUserDataSpy();
    sut = MaterialApp(home: EditUserPage(loadUserData: loadUserData.call));
  });

  testWidgets('should load user data on page init', (tester) async {
    await tester.pumpWidget(sut);
    expect(loadUserData.callsCount, 1);
  });

  testWidgets('should check natural person', (tester) async {
    loadUserData.modkResponse(isNaturalPerson: true);
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
    loadUserData.modkResponse(isNaturalPerson: false);
    await tester.pumpWidget(sut);
    await tester.pump();
    expect(tester.naturalPersonRadio.checked, false);
    expect(tester.legalPersonRadio.checked, true);
  });

  testWidgets('should show CPF', (tester) async {
    loadUserData.modkResponse(showCpf: true);
    await tester.pumpWidget(sut);
    await tester.pump();
    expect(tester.cpfFinder, findsOneWidget);
  });

  testWidgets('should hide CPF', (tester) async {
    loadUserData.modkResponse(showCpf: false);
    await tester.pumpWidget(sut);
    await tester.pump();
    expect(tester.cpfFinder, findsNothing);
  });

  testWidgets('should show CNPJ', (tester) async {
    loadUserData.modkResponse(showCnpj: true);
    await tester.pumpWidget(sut);
    await tester.pump();
    expect(tester.cnpjFinder, findsOneWidget);
  });

  testWidgets('should hide CNPJ', (tester) async {
    loadUserData.modkResponse(showCnpj: false);
    await tester.pumpWidget(sut);
    await tester.pump();
    expect(tester.cnpjFinder, findsNothing);
  });

  testWidgets('should fill CPF', (tester) async {
    loadUserData.modkResponse(cpf: cpf, showCpf: true);
    await tester.pumpWidget(sut);
    await tester.pump();
    expect(tester.cpfTextField.initialValue, cpf);
  });

  testWidgets('should clear CPF', (tester) async {
    loadUserData.modkResponse(cpf: null, showCpf: true);
    await tester.pumpWidget(sut);
    await tester.pump();
    expect(tester.cpfTextField.initialValue, isEmpty);
  });
}

extension EditUserPageExtension on WidgetTester {
  Finder get naturalPersonFinder => find.ancestor(of: find.text('Pessoa física'), matching: find.byType(RadioListTile<bool>));
  Finder get legalPersonFinder => find.ancestor(of: find.text('Pessoa jurídica'), matching: find.byType(RadioListTile<bool>));
  Finder get cpfFinder => find.ancestor(of: find.text('CPF'), matching: find.byType(TextFormField));
  Finder get cnpjFinder => find.text('CNPJ');
  RadioListTile get naturalPersonRadio => widget(naturalPersonFinder);
  RadioListTile get legalPersonRadio => widget(legalPersonFinder);
  TextFormField get cpfTextField => widget(cpfFinder);
}
