import 'package:dartz/dartz.dart';
import 'package:fanup/app/app_usecase.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/features/create_team/data/repositories/create_team_repository.dart';
import 'package:fanup/features/create_team/domain/entities/contest_entry_entity.dart';
import 'package:fanup/features/create_team/domain/repositories/create_team_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final submitContestEntryUsecaseProvider = Provider<SubmitContestEntryUsecase>((
  ref,
) {
  return SubmitContestEntryUsecase(
    createTeamRepository: ref.read(createTeamRepositoryProvider),
  );
});

class SubmitContestEntryUsecase
    implements UsecaseWithParams<bool, ContestEntryEntity> {
  final ICreateTeamRepository _createTeamRepository;

  SubmitContestEntryUsecase({
    required ICreateTeamRepository createTeamRepository,
  }) : _createTeamRepository = createTeamRepository;

  @override
  Future<Either<Failure, bool>> call(ContestEntryEntity params) {
    return _createTeamRepository.submitContestEntry(params);
  }
}
