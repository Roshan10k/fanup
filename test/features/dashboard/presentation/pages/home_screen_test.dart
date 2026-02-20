import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/features/dashboard/domain/entities/home_feed_entity.dart';
import 'package:fanup/features/dashboard/domain/entities/home_match_entity.dart';
import 'package:fanup/features/dashboard/domain/usecases/get_home_feed_usecase.dart';
import 'package:fanup/features/dashboard/presentation/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetHomeFeedUsecase extends Mock implements GetHomeFeedUsecase {}

void main() {
  late MockGetHomeFeedUsecase mockGetHomeFeedUsecase;

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

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        getHomeFeedUsecaseProvider.overrideWithValue(mockGetHomeFeedUsecase),
      ],
      child: const MaterialApp(home: HomeScreen()),
    );
  }

  setUp(() {
    mockGetHomeFeedUsecase = MockGetHomeFeedUsecase();
    tHomeFeed = HomeFeedEntity(matches: [tMatch]);
  });

  testWidgets('shows loading indicator while fetching data', (tester) async {
    final completer = Completer<Either<Failure, HomeFeedEntity>>();
    when(() => mockGetHomeFeedUsecase()).thenAnswer((_) => completer.future);

    await tester.pumpWidget(createTestWidget());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    completer.complete(Right(tHomeFeed));
    await tester.pumpAndSettle();
  });

  testWidgets('shows matches when data load succeeds', (tester) async {
    when(
      () => mockGetHomeFeedUsecase(),
    ).thenAnswer((_) async => Right(tHomeFeed));

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('IND'), findsOneWidget);
    expect(find.text('AUS'), findsOneWidget);
    expect(find.text('Create Team'), findsOneWidget);
  });

  testWidgets('shows error and retry button when data load fails', (
    tester,
  ) async {
    const failure = ApiFailure(message: 'Failed to fetch home');
    when(
      () => mockGetHomeFeedUsecase(),
    ).thenAnswer((_) async => const Left(failure));

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('Failed to fetch home'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });
}
