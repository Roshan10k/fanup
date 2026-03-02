import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:fanup/features/dashboard/domain/usecases/get_home_feed_usecase.dart';
import 'package:fanup/features/dashboard/domain/entities/home_feed_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockDashboardRepository extends Mock implements IDashboardRepository {}

void main() {
  late GetHomeFeedUsecase usecase;
  late MockDashboardRepository mockRepository;

  setUp(() {
    mockRepository = MockDashboardRepository();
    usecase = GetHomeFeedUsecase(dashboardRepository: mockRepository);
  });

  group('GetHomeFeedUsecase', () {
    test('should return HomeFeedEntity on success', () async {
      const tFeed = HomeFeedEntity(
        matches: [],
        entries: [],
      );

      when(() => mockRepository.getHomeFeed())
          .thenAnswer((_) async => Right(tFeed));

      final result = await usecase();

      expect(result, Right(tFeed));
      verify(() => mockRepository.getHomeFeed()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ApiFailure on server error', () async {
      const failure = ApiFailure(message: 'Server error', statusCode: 500);
      when(() => mockRepository.getHomeFeed())
          .thenAnswer((_) async => const Left(failure));

      final result = await usecase();

      expect(result, const Left(failure));
    });

    test('should return NetworkFailure when offline', () async {
      const failure = NetworkFailure();
      when(() => mockRepository.getHomeFeed())
          .thenAnswer((_) async => const Left(failure));

      final result = await usecase();

      expect(result, const Left(failure));
    });
  });
}
