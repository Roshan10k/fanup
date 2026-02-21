import 'package:fanup/features/create_team/domain/entities/player_entity.dart';
import 'package:fanup/features/create_team/domain/utils/team_validator.dart';
import 'package:flutter_test/flutter_test.dart';

PlayerEntity _player({
  required String id,
  required TeamRole role,
  required double credit,
}) {
  return PlayerEntity(
    id: id,
    fullName: 'Player $id',
    teamShortName: 'IND',
    role: role,
    credit: credit,
    isPlaying: true,
  );
}

void main() {
  test('validateAddPlayer blocks adding more than 11 players', () {
    final selected = List.generate(
      11,
      (index) => _player(id: '$index', role: TeamRole.bat, credit: 8),
    );

    final message = TeamValidator.validateAddPlayer(
      currentPlayers: selected,
      player: _player(id: '12', role: TeamRole.wk, credit: 9),
    );

    expect(message, 'You can only select 11 players');
  });

  test('validateSubmission succeeds with valid team composition', () {
    final selected = [
      _player(id: '1', role: TeamRole.wk, credit: 9),
      _player(id: '2', role: TeamRole.bat, credit: 9),
      _player(id: '3', role: TeamRole.bat, credit: 9),
      _player(id: '4', role: TeamRole.bat, credit: 8),
      _player(id: '5', role: TeamRole.ar, credit: 9),
      _player(id: '6', role: TeamRole.ar, credit: 8),
      _player(id: '7', role: TeamRole.bowl, credit: 9),
      _player(id: '8', role: TeamRole.bowl, credit: 8),
      _player(id: '9', role: TeamRole.bowl, credit: 8),
      _player(id: '10', role: TeamRole.wk, credit: 8),
      _player(id: '11', role: TeamRole.bat, credit: 8),
    ];

    final result = TeamValidator.validateSubmission(
      selectedPlayers: selected,
      teamName: 'My XI',
      captainId: '1',
      viceCaptainId: '2',
    );

    expect(result.isValid, true);
    expect(result.message, isNull);
  });
}
