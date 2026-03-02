import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:fanup/features/dashboard/domain/usecases/claim_daily_bonus_usecase.dart';
import 'package:fanup/features/dashboard/domain/entities/wallet_daily_bonus_result_entity.dart';
import 'package:fanup/features/dashboard/domain/entities/wallet_summary_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockDashboardRepository extends Mock implements IDashboardRepository {}

void main() {
  late ClaimDailyBonusUsecase usecase;
  late MockDashboardRepository mockRepository;

  setUp(() {
    mockRepository = MockDashboardRepository();
    usecase = ClaimDailyBonusUsecase(dashboardRepository: mockRepository);
  });

  group('ClaimDailyBonusUsecase', () {
    test('should return WalletDailyBonusResultEntity on success', () async {
      final tResult = WalletDailyBonusResultEntity(
        created: true,
        amount: 10,
        message: 'Bonus claimed!',
        summary: WalletSummaryEntity(
          balance: 160,
          totalCredit: 210,
          totalDebit: 50,
          transactionCount: 11,
          lastTransactionAt: DateTime(2024, 1, 2),
        ),
      );

      when(() => mockRepository.claimDailyBonus())
          .thenAnswer((_) async => Right(tResult));

      final result = await usecase();

      expect(result, Right(tResult));
      verify(() => mockRepository.claimDailyBonus()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when bonus already claimed', () async {
      const failure = ApiFailure(
          message: 'Daily bonus already claimed', statusCode: 409);
      when(() => mockRepository.claimDailyBonus())
          .thenAnswer((_) async => const Left(failure));

      final result = await usecase();

      expect(result, const Left(failure));
    });

    test('should return NetworkFailure when offline', () async {
      const failure = NetworkFailure();
      when(() => mockRepository.claimDailyBonus())
          .thenAnswer((_) async => const Left(failure));

      final result = await usecase();

      expect(result, const Left(failure));
    });
  });
}
