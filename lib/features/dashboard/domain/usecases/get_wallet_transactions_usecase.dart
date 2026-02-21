import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/features/dashboard/data/repositories/dashboard_repository.dart'
    as dashboard_data;
import 'package:fanup/features/dashboard/domain/entities/wallet_transaction_entity.dart';
import 'package:fanup/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getWalletTransactionsUsecaseProvider =
    Provider<GetWalletTransactionsUsecase>((ref) {
      final dashboardRepository = ref.read(
        dashboard_data.dashboardRepositoryProvider,
      );
      return GetWalletTransactionsUsecase(
        dashboardRepository: dashboardRepository,
      );
    });

class GetWalletTransactionsParams extends Equatable {
  final int page;
  final int size;

  const GetWalletTransactionsParams({this.page = 1, this.size = 20});

  @override
  List<Object?> get props => [page, size];
}

class GetWalletTransactionsUsecase {
  final IDashboardRepository _dashboardRepository;

  GetWalletTransactionsUsecase({
    required IDashboardRepository dashboardRepository,
  }) : _dashboardRepository = dashboardRepository;

  Future<Either<Failure, List<WalletTransactionEntity>>> call(
    GetWalletTransactionsParams params,
  ) {
    return _dashboardRepository.getWalletTransactions(
      page: params.page,
      size: params.size,
    );
  }
}
