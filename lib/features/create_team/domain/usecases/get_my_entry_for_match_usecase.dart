import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fanup/app/app_usecase.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/features/create_team/data/repositories/create_team_repository.dart';
import 'package:fanup/features/create_team/domain/entities/contest_entry_entity.dart';
import 'package:fanup/features/create_team/domain/repositories/create_team_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetMyEntryForMatchParams extends Equatable {
  final String matchId;

  const GetMyEntryForMatchParams({required this.matchId});

  @override
  List<Object?> get props => [matchId];
}

final getMyEntryForMatchUsecaseProvider = Provider<GetMyEntryForMatchUsecase>((
  ref,
) {
  return GetMyEntryForMatchUsecase(
    createTeamRepository: ref.read(createTeamRepositoryProvider),
  );
});

class GetMyEntryForMatchUsecase
    implements
        UsecaseWithParams<
          ExistingContestEntryEntity?,
          GetMyEntryForMatchParams
        > {
  final ICreateTeamRepository _createTeamRepository;

  GetMyEntryForMatchUsecase({
    required ICreateTeamRepository createTeamRepository,
  }) : _createTeamRepository = createTeamRepository;

  @override
  Future<Either<Failure, ExistingContestEntryEntity?>> call(
    GetMyEntryForMatchParams params,
  ) {
    return _createTeamRepository.getMyEntryForMatch(params.matchId);
  }
}
