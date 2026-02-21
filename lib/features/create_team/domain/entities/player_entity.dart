import 'package:equatable/equatable.dart';

enum TeamRole { wk, bat, ar, bowl }

extension TeamRoleX on TeamRole {
  String get label {
    switch (this) {
      case TeamRole.wk:
        return 'WK';
      case TeamRole.bat:
        return 'BAT';
      case TeamRole.ar:
        return 'AR';
      case TeamRole.bowl:
        return 'BOWL';
    }
  }

  static TeamRole fromBackend(String value) {
    switch (value) {
      case 'wicket_keeper':
        return TeamRole.wk;
      case 'batsman':
        return TeamRole.bat;
      case 'all_rounder':
        return TeamRole.ar;
      default:
        return TeamRole.bowl;
    }
  }
}

class PlayerEntity extends Equatable {
  final String id;
  final String fullName;
  final String teamShortName;
  final TeamRole role;
  final double credit;
  final bool isPlaying;

  const PlayerEntity({
    required this.id,
    required this.fullName,
    required this.teamShortName,
    required this.role,
    required this.credit,
    required this.isPlaying,
  });

  @override
  List<Object?> get props => [
    id,
    fullName,
    teamShortName,
    role,
    credit,
    isPlaying,
  ];
}
