// import 'package:advanced_flutter/domain/entities/next_event_player.dart';

import 'package:flutter_test/flutter_test.dart';

class NextEventPlayer {
  final String id;
  final String name;
  final String? photo;
  final String? position;
  final bool isConfirmed;
  final DateTime? confirmationDate;

  NextEventPlayer({
    required this.id,
    required this.name,
    required this.isConfirmed,
    this.photo,
    this.position,
    this.confirmationDate,
  });

  String getInitials() {
    final names = name.split(' ');
    final firstChar = names.first[0];
    final lastChar = names.last[0];
    return '$firstChar$lastChar';
  }
}

void main() {
  // sut = system under test
  NextEventPlayer makeSut(String name) =>
      NextEventPlayer(id: '', name: name, isConfirmed: true);

  test('should return the first letter of the first and last names', () {
    expect(makeSut('Eliel Batiston').getInitials(), 'EB');
    expect(makeSut('Pedro Carvalho').getInitials(), 'PC');
    expect(makeSut('Ingrid Mota da Silva').getInitials(), 'IS');
  });
}
