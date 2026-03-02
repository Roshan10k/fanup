import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:fanup/features/dashboard/domain/usecases/get_wallet_transactions_usecase.dart';
import 'package:fanup/features/dashboard/domain/entities/wallet_transaction_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockDashboardRepository extends Mock implements IDashboardRepository {}

void main() {
  late GetWalletTransactionsUsecase usecase;
  late MockDashboardRepository mockRepository;

  setUp(() {
    mockRepository = MockDashboardRepository();
    usecase =
        GetWalletTransactionsUsecase(dashboardRepository: mockRepository);
  });

  group('GetWalletTransactionsUsecase', () {
    test('should return list of transactions on success', () async {
      final tTransactions = <WalletTransactionEntity>[];

      when(() => mockRepository.getWalletTransactions(page: 1, size: 20))
          .thenAnswer((_) async => Right(tTransactions));

      final result = await usecase(
          const GetWalletTransactionsParams(page: 1, size: 20));

      expect(result, Right(tTransactions));
      verify(() => mockRepository.getWalletTransactions(page: 1, size: 20))
          .called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should pass correct page and size', () async {
      when(() => mockRepository.getWalletTransactions(page: 2, size: 10))
          .thenAnswer((_) async => const Right([]));

      await usecase(const GetWalletTransactionsParams(page: 2, size: 10));

      verify(() => mockRepository.getWalletTransactions(page: 2, size: 10))
          .called(1);
    });

    test('should return failure on error', () async {
      const failure = ApiFailure(message: 'Failed');
      when(() => mockRepository.getWalletTransactions(page: 1, size: 20))
          .thenAnswer((_) async => const Left(failure));

      final result = await usecase(const GetWalletTransactionsParams());

      expect(result, const Left(failure));
    });
  });

  group('GetWalletTransactionsParams', () {
    test('should have default values', () {
      const params = GetWalletTransactionsParams();
      expect(params.page, 1);
      expect(params.size, 20);
    });

    test('two params with same values should be equal', () {
      const p1 = GetWalletTransactionsParams(page: 1, size: 20);
      const p2 = GetWalletTransactionsParams(page: 1, size: 20);
      expect(p1, p2);
    });
  });
}
