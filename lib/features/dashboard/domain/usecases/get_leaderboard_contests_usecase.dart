import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/features/dashboard/data/repositories/dashboard_repository.dart'
    as dashboard_data;
import 'package:fanup/features/dashboard/domain/entities/leaderboard_contest_entity.dart';
import 'package:fanup/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getLeaderboardContestsUsecaseProvider =
    Provider<GetLeaderboardContestsUsecase>((ref) {
      final dashboardRepository = ref.read(
        dashboard_data.dashboardRepositoryProvider,
      );
      return GetLeaderboardContestsUsecase(
        dashboardRepository: dashboardRepository,
      );
    });

class GetLeaderboardContestsParams extends Equatable {
  final String status;

  const GetLeaderboardContestsParams({required this.status});

  @override
  List<Object?> get props => [status];
}

class GetLeaderboardContestsUsecase {
  final IDashboardRepository _dashboardRepository;

  GetLeaderboardContestsUsecase({
    required IDashboardRepository dashboardRepository,
  }) : _dashboardRepository = dashboardRepository;

  Future<Either<Failure, List<LeaderboardContestEntity>>> call(
    GetLeaderboardContestsParams params,
  ) {
    return _dashboardRepository.getLeaderboardContests(status: params.status);
  }
}
