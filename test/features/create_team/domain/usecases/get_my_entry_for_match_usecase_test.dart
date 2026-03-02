import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/features/create_team/domain/repositories/create_team_repository.dart';
import 'package:fanup/features/create_team/domain/usecases/get_my_entry_for_match_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateTeamRepository extends Mock implements ICreateTeamRepository {}

void main() {
  late GetMyEntryForMatchUsecase usecase;
  late MockCreateTeamRepository mockRepository;

  setUp(() {
    mockRepository = MockCreateTeamRepository();
    usecase = GetMyEntryForMatchUsecase(createTeamRepository: mockRepository);
  });

  const tMatchId = 'match-789';

  group('GetMyEntryForMatchUsecase', () {
    test('should return null when no entry exists', () async {
      when(() => mockRepository.getMyEntryForMatch(tMatchId))
          .thenAnswer((_) async => const Right(null));

      final result = await usecase(
          const GetMyEntryForMatchParams(matchId: tMatchId));

      expect(result.isRight(), true);
      result.fold((_) {}, (entry) => expect(entry, null));
      verify(() => mockRepository.getMyEntryForMatch(tMatchId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure on error', () async {
      const failure = ApiFailure(message: 'Server error');
      when(() => mockRepository.getMyEntryForMatch(tMatchId))
          .thenAnswer((_) async => const Left(failure));

      final result = await usecase(
          const GetMyEntryForMatchParams(matchId: tMatchId));

      expect(result, const Left(failure));
    });
  });

  group('GetMyEntryForMatchParams', () {
    test('two params with same matchId should be equal', () {
      const p1 = GetMyEntryForMatchParams(matchId: 'abc');
      const p2 = GetMyEntryForMatchParams(matchId: 'abc');
      expect(p1, p2);
    });
  });
}
