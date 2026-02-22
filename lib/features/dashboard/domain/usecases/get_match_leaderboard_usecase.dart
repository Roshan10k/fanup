import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/features/dashboard/data/repositories/dashboard_repository.dart'
    as dashboard_data;
import 'package:fanup/features/dashboard/domain/entities/leaderboard_payload_entity.dart';
import 'package:fanup/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getMatchLeaderboardUsecaseProvider = Provider<GetMatchLeaderboardUsecase>(
  (ref) {
    final dashboardRepository = ref.read(
      dashboard_data.dashboardRepositoryProvider,
    );
    return GetMatchLeaderboardUsecase(dashboardRepository: dashboardRepository);
  },
);

class GetMatchLeaderboardParams extends Equatable {
  final String matchId;

  const GetMatchLeaderboardParams({required this.matchId});

  @override
  List<Object?> get props => [matchId];
}

class GetMatchLeaderboardUsecase {
  final IDashboardRepository _dashboardRepository;

  GetMatchLeaderboardUsecase({
    required IDashboardRepository dashboardRepository,
  }) : _dashboardRepository = dashboardRepository;

  Future<Either<Failure, LeaderboardPayloadEntity>> call(
    GetMatchLeaderboardParams params,
  ) {
    return _dashboardRepository.getMatchLeaderboard(matchId: params.matchId);
  }
}
