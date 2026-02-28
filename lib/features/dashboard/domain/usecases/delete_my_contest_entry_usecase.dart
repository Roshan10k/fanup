import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fanup/app/app_usecase.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/features/dashboard/data/repositories/dashboard_repository.dart'
    as dashboard_data;
import 'package:fanup/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteMyContestEntryParams extends Equatable {
  final String matchId;

  const DeleteMyContestEntryParams({required this.matchId});

  @override
  List<Object?> get props => [matchId];
}

final deleteMyContestEntryUsecaseProvider =
    Provider<DeleteMyContestEntryUsecase>((ref) {
      final repository = ref.read(dashboard_data.dashboardRepositoryProvider);
      return DeleteMyContestEntryUsecase(dashboardRepository: repository);
    });

class DeleteMyContestEntryUsecase
    implements UsecaseWithParams<void, DeleteMyContestEntryParams> {
  final IDashboardRepository _dashboardRepository;

  DeleteMyContestEntryUsecase({
    required IDashboardRepository dashboardRepository,
  }) : _dashboardRepository = dashboardRepository;

  @override
  Future<Either<Failure, void>> call(DeleteMyContestEntryParams params) {
    return _dashboardRepository.deleteMyContestEntry(matchId: params.matchId);
  }
}
