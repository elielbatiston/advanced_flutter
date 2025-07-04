import 'package:flutter/material.dart';

final class PlayerStatus extends StatelessWidget {
  final bool? isConfirmed;

  const PlayerStatus({
    this.isConfirmed,
    super.key
  });

  Color getColor() => switch(isConfirmed) {
    true => Colors.teal,
    false => Colors.pink,
    null => Colors.blueGrey
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: getColor(),
      ),
    );
  }
}
