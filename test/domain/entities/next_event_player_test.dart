import 'package:advanced_flutter/domain/entities/next_event_player.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  // sut = system under test
  String initialsOf(String name) => NextEventPlayer(id: '', name: name, isConfirmed: true).initials;

  test('should return the first letter of the first and last names', () {
    expect(initialsOf('Eliel Batiston'), 'EB');
    expect(initialsOf('Pedro Carvalho'), 'PC');
    expect(initialsOf('Ingrid Mota da Silva'), 'IS');
  });

  test('should return the first letter of the first name', () {
    expect(initialsOf('Eliel'), 'EL');
    expect(initialsOf('E'), 'E');
  });

  test('should return "-" when name is empty', () {
    expect(initialsOf(''), '-');
  });

  test('should convert to uppercase', () {
    expect(initialsOf('eliel batiston'), 'EB');
    expect(initialsOf('pedro'), 'PE');
    expect(initialsOf('e'), 'E');
  });

  test('should ignore extra whitespaces', () {
    expect(initialsOf('Eliel Batiston '), 'EB');
    expect(initialsOf(' Eliel Batiston'), 'EB');
    expect(initialsOf('Eliel  Batiston'), 'EB');
    expect(initialsOf(' Eliel  Batiston '), 'EB');
    expect(initialsOf(' Eliel '), 'EL');
    expect(initialsOf(' E '), 'E');
    expect(initialsOf(' '), '-');
    expect(initialsOf('  '), '-');
  });
}
