import 'package:equatable/equatable.dart';
import 'package:fanup/features/dashboard/domain/entities/contest_entry_entity.dart';
import 'package:fanup/features/dashboard/domain/entities/home_match_entity.dart';

class HomeFeedEntity extends Equatable {
  final List<HomeMatchEntity> matches;
  final List<ContestEntryEntity> entries;

  const HomeFeedEntity({
    required this.matches,
    this.entries = const [],
  });

  @override
  List<Object?> get props => [matches, entries];
}
