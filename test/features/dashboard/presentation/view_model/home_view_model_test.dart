import 'package:dartz/dartz.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/features/dashboard/domain/entities/home_feed_entity.dart';
import 'package:fanup/features/dashboard/domain/entities/home_match_entity.dart';
import 'package:fanup/features/dashboard/domain/usecases/get_home_feed_usecase.dart';
import 'package:fanup/features/dashboard/presentation/state/home_state.dart';
import 'package:fanup/features/dashboard/presentation/view_model/home_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetHomeFeedUsecase extends Mock implements GetHomeFeedUsecase {}

void main() {
  late MockGetHomeFeedUsecase mockGetHomeFeedUsecase;
  late ProviderContainer container;

  final tMatch = HomeMatchEntity(
    id: 'match-1',
    league: 'NPL',
    startTime: DateTime(2026, 11, 4, 15, 15),
    status: 'completed',
    teamAShortName: 'IND',
    teamBShortName: 'AUS',
    hasExistingEntry: false,
  );

  late HomeFeedEntity tHomeFeed;

  setUp(() {
    mockGetHomeFeedUsecase = MockGetHomeFeedUsecase();
    tHomeFeed = HomeFeedEntity(matches: [tMatch]);
    container = ProviderContainer(
      overrides: [
        getHomeFeedUsecaseProvider.overrideWithValue(mockGetHomeFeedUsecase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test(
    'loadHomeData should emit loaded state with matches on success',
    () async {
      when(
        () => mockGetHomeFeedUsecase(),
      ).thenAnswer((_) async => Right(tHomeFeed));

      await container.read(homeViewModelProvider.notifier).loadHomeData();

      final state = container.read(homeViewModelProvider);
      expect(state.status, HomeStatus.loaded);
      expect(state.matches, [tMatch]);
      expect(state.errorMessage, isNull);
      verify(() => mockGetHomeFeedUsecase()).called(1);
    },
  );

  test('loadHomeData should emit error state on failure', () async {
    const failure = ApiFailure(message: 'Unable to load home feed');
    when(
      () => mockGetHomeFeedUsecase(),
    ).thenAnswer((_) async => const Left(failure));

    await container.read(homeViewModelProvider.notifier).loadHomeData();

    final state = container.read(homeViewModelProvider);
    expect(state.status, HomeStatus.error);
    expect(state.matches, isEmpty);
    expect(state.errorMessage, 'Unable to load home feed');
    verify(() => mockGetHomeFeedUsecase()).called(1);
  });
}
