import 'package:fanup/features/create_team/domain/entities/player_entity.dart';

class PlayerApiModel {
  final String id;
  final String fullName;
  final String teamShortName;
  final String role;
  final double credit;
  final bool isPlaying;

  const PlayerApiModel({
    required this.id,
    required this.fullName,
    required this.teamShortName,
    required this.role,
    required this.credit,
    required this.isPlaying,
  });

  factory PlayerApiModel.fromJson(Map<String, dynamic> json) {
    return PlayerApiModel(
      id: (json['_id'] ?? '').toString(),
      fullName: (json['fullName'] ?? 'Player').toString(),
      teamShortName: (json['teamShortName'] ?? '').toString(),
      role: (json['role'] ?? 'bowler').toString(),
      credit: (json['credit'] is num)
          ? (json['credit'] as num).toDouble()
          : double.tryParse((json['credit'] ?? '0').toString()) ?? 0,
      isPlaying: json['isPlaying'] == true,
    );
  }

  PlayerEntity toEntity() {
    return PlayerEntity(
      id: id,
      fullName: fullName,
      teamShortName: teamShortName,
      role: TeamRoleX.fromBackend(role),
      credit: credit,
      isPlaying: isPlaying,
    );
  }
}
