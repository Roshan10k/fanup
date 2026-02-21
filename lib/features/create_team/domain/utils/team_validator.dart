import 'package:fanup/features/create_team/domain/entities/player_entity.dart';

class RoleRule {
  final int min;
  final int max;

  const RoleRule({required this.min, required this.max});
}

class TeamValidatorResult {
  final bool isValid;
  final String? message;
  final Map<TeamRole, int> roleCounts;
  final double usedCredits;
  final double creditLeft;

  const TeamValidatorResult({
    required this.isValid,
    this.message,
    required this.roleCounts,
    required this.usedCredits,
    required this.creditLeft,
  });
}

class TeamValidator {
  TeamValidator._();

  static const int maxPlayers = 11;
  static const double maxCredits = 100;

  static const Map<TeamRole, RoleRule> roleRules = {
    TeamRole.wk: RoleRule(min: 1, max: 2),
    TeamRole.bat: RoleRule(min: 3, max: 4),
    TeamRole.ar: RoleRule(min: 1, max: 4),
    TeamRole.bowl: RoleRule(min: 3, max: 4),
  };

  static Map<TeamRole, int> getRoleCounts(List<PlayerEntity> players) {
    return {
      TeamRole.wk: players.where((p) => p.role == TeamRole.wk).length,
      TeamRole.bat: players.where((p) => p.role == TeamRole.bat).length,
      TeamRole.ar: players.where((p) => p.role == TeamRole.ar).length,
      TeamRole.bowl: players.where((p) => p.role == TeamRole.bowl).length,
    };
  }

  static double getUsedCredits(List<PlayerEntity> players) {
    return players.fold(0.0, (sum, p) => sum + p.credit);
  }

  static String? validateAddPlayer({
    required List<PlayerEntity> currentPlayers,
    required PlayerEntity player,
  }) {
    if (currentPlayers.any((p) => p.id == player.id)) {
      return null;
    }

    if (currentPlayers.length >= maxPlayers) {
      return 'You can only select 11 players';
    }

    final currentRoleCount = currentPlayers
        .where((p) => p.role == player.role)
        .length;
    final maxAllowedForRole = roleRules[player.role]?.max ?? maxPlayers;

    if (currentRoleCount >= maxAllowedForRole) {
      return 'Maximum $maxAllowedForRole ${player.role.label} players allowed';
    }

    final nextCredits = getUsedCredits(currentPlayers) + player.credit;
    if (nextCredits > maxCredits) {
      return 'Credit limit exceeded (max 100)';
    }

    return null;
  }

  static TeamValidatorResult validateSubmission({
    required List<PlayerEntity> selectedPlayers,
    required String teamName,
    required String captainId,
    required String viceCaptainId,
  }) {
    final roleCounts = getRoleCounts(selectedPlayers);
    final usedCredits = getUsedCredits(selectedPlayers);

    if (teamName.trim().isEmpty) {
      return TeamValidatorResult(
        isValid: false,
        message: 'Team name is required',
        roleCounts: roleCounts,
        usedCredits: usedCredits,
        creditLeft: maxCredits - usedCredits,
      );
    }

    if (selectedPlayers.length != maxPlayers) {
      return TeamValidatorResult(
        isValid: false,
        message: 'Select exactly 11 players',
        roleCounts: roleCounts,
        usedCredits: usedCredits,
        creditLeft: maxCredits - usedCredits,
      );
    }

    for (final entry in roleRules.entries) {
      final roleCount = roleCounts[entry.key] ?? 0;
      if (roleCount < entry.value.min || roleCount > entry.value.max) {
        return TeamValidatorResult(
          isValid: false,
          message:
              '${entry.key.label} requires ${entry.value.min}-${entry.value.max} players',
          roleCounts: roleCounts,
          usedCredits: usedCredits,
          creditLeft: maxCredits - usedCredits,
        );
      }
    }

    if (usedCredits > maxCredits) {
      return TeamValidatorResult(
        isValid: false,
        message: 'Credit limit exceeded',
        roleCounts: roleCounts,
        usedCredits: usedCredits,
        creditLeft: maxCredits - usedCredits,
      );
    }

    if (captainId.isEmpty || viceCaptainId.isEmpty) {
      return TeamValidatorResult(
        isValid: false,
        message: 'Please select captain and vice-captain',
        roleCounts: roleCounts,
        usedCredits: usedCredits,
        creditLeft: maxCredits - usedCredits,
      );
    }

    if (captainId == viceCaptainId) {
      return TeamValidatorResult(
        isValid: false,
        message: 'Captain and vice-captain must be different players',
        roleCounts: roleCounts,
        usedCredits: usedCredits,
        creditLeft: maxCredits - usedCredits,
      );
    }

    return TeamValidatorResult(
      isValid: true,
      roleCounts: roleCounts,
      usedCredits: usedCredits,
      creditLeft: maxCredits - usedCredits,
    );
  }
}
