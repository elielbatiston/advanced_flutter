import 'package:advanced_flutter/domain/entities/next_event_player.dart';
import 'package:advanced_flutter/infra/mappers/mapper.dart';
import 'package:advanced_flutter/infra/types/json.dart';

final class NextEventPlayerMapper extends ListMapper<NextEventPlayer> {
  @override
  NextEventPlayer toDto(dynamic json) => NextEventPlayer(
    id: json['id'],
    name: json['name'],
    position: json['position'],
    photo: json['photo'],
    isConfirmed: json['isConfirmed'],
    confirmationDate: DateTime.tryParse(json['confirmationDate'] ?? '')
  );

  @override
  Json toJson(NextEventPlayer player) => {
    'id': player.id,
    'name': player.name,
    'position': player.position,
    'photo': player.photo,
    'isConfirmed': player.isConfirmed,
    'confirmationDate': player.confirmationDate?.toIso8601String()
  };
}
