import 'package:dartz/dartz.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/features/dashboard/data/repositories/dashboard_repository.dart'
    as dashboard_data;
import 'package:fanup/features/dashboard/domain/entities/wallet_summary_entity.dart';
import 'package:fanup/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getWalletSummaryUsecaseProvider = Provider<GetWalletSummaryUsecase>((
  ref,
) {
  final dashboardRepository = ref.read(
    dashboard_data.dashboardRepositoryProvider,
  );
  return GetWalletSummaryUsecase(dashboardRepository: dashboardRepository);
});

class GetWalletSummaryUsecase {
  final IDashboardRepository _dashboardRepository;

  GetWalletSummaryUsecase({required IDashboardRepository dashboardRepository})
    : _dashboardRepository = dashboardRepository;

  Future<Either<Failure, WalletSummaryEntity>> call() {
    return _dashboardRepository.getWalletSummary();
  }
}
