import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:fanup/features/dashboard/domain/usecases/get_wallet_summary_usecase.dart';
import 'package:fanup/features/dashboard/domain/entities/wallet_summary_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockDashboardRepository extends Mock implements IDashboardRepository {}

void main() {
  late GetWalletSummaryUsecase usecase;
  late MockDashboardRepository mockRepository;

  setUp(() {
    mockRepository = MockDashboardRepository();
    usecase = GetWalletSummaryUsecase(dashboardRepository: mockRepository);
  });

  group('GetWalletSummaryUsecase', () {
    test('should return WalletSummaryEntity on success', () async {
      final tSummary = WalletSummaryEntity(
        balance: 150,
        totalCredit: 200,
        totalDebit: 50,
        transactionCount: 10,
        lastTransactionAt: DateTime(2024, 1, 1),
      );

      when(() => mockRepository.getWalletSummary())
          .thenAnswer((_) async => Right(tSummary));

      final result = await usecase();

      expect(result, Right(tSummary));
      verify(() => mockRepository.getWalletSummary()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure on error', () async {
      const failure = ApiFailure(message: 'Failed to load wallet');
      when(() => mockRepository.getWalletSummary())
          .thenAnswer((_) async => const Left(failure));

      final result = await usecase();

      expect(result, const Left(failure));
    });
  });
}
