import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

final class EditUserPage extends StatelessWidget {
  final Future<void> Function() loadUserData;

  const EditUserPage({
    super.key,
    required this.loadUserData
  });

  @override
  Widget build(BuildContext context) {
    loadUserData();
    return Container();
  }
}

final class LoadUserDataMock {
  bool isCalled = false;

  Future<void> call() async {
    isCalled = true;
  }
}

void main() {
  testWidgets('should load user data on page init', (tester) async {
    final loadUserData = LoadUserDataMock();
    final sut = EditUserPage(loadUserData: loadUserData.call);
    await tester.pumpWidget(sut);
    expect(loadUserData.isCalled, true);
  });
}
