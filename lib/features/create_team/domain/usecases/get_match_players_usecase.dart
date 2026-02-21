import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fanup/app/app_usecase.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/features/create_team/data/repositories/create_team_repository.dart';
import 'package:fanup/features/create_team/domain/entities/player_entity.dart';
import 'package:fanup/features/create_team/domain/repositories/create_team_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetMatchPlayersParams extends Equatable {
  final String teamA;
  final String teamB;

  const GetMatchPlayersParams({required this.teamA, required this.teamB});

  @override
  List<Object?> get props => [teamA, teamB];
}

final getMatchPlayersUsecaseProvider = Provider<GetMatchPlayersUsecase>((ref) {
  return GetMatchPlayersUsecase(
    createTeamRepository: ref.read(createTeamRepositoryProvider),
  );
});

class GetMatchPlayersUsecase
    implements UsecaseWithParams<List<PlayerEntity>, GetMatchPlayersParams> {
  final ICreateTeamRepository _createTeamRepository;

  GetMatchPlayersUsecase({required ICreateTeamRepository createTeamRepository})
    : _createTeamRepository = createTeamRepository;

  @override
  Future<Either<Failure, List<PlayerEntity>>> call(
    GetMatchPlayersParams params,
  ) {
    return _createTeamRepository.getPlayers(
      teamA: params.teamA,
      teamB: params.teamB,
    );
  }
}
