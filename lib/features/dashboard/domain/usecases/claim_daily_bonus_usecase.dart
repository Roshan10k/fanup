import 'package:dartz/dartz.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/features/dashboard/data/repositories/dashboard_repository.dart'
    as dashboard_data;
import 'package:fanup/features/dashboard/domain/entities/wallet_daily_bonus_result_entity.dart';
import 'package:fanup/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final claimDailyBonusUsecaseProvider = Provider<ClaimDailyBonusUsecase>((ref) {
  final dashboardRepository = ref.read(
    dashboard_data.dashboardRepositoryProvider,
  );
  return ClaimDailyBonusUsecase(dashboardRepository: dashboardRepository);
});

class ClaimDailyBonusUsecase {
  final IDashboardRepository _dashboardRepository;

  ClaimDailyBonusUsecase({required IDashboardRepository dashboardRepository})
    : _dashboardRepository = dashboardRepository;

  Future<Either<Failure, WalletDailyBonusResultEntity>> call() {
    return _dashboardRepository.claimDailyBonus();
  }
}
