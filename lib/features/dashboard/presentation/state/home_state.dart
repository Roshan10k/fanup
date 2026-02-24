import 'package:equatable/equatable.dart';
import 'package:fanup/features/dashboard/domain/entities/contest_entry_entity.dart';
import 'package:fanup/features/dashboard/domain/entities/home_match_entity.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<HomeMatchEntity> matches;
  final List<ContestEntryEntity> entries;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.matches = const [],
    this.entries = const [],
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<HomeMatchEntity>? matches,
    List<ContestEntryEntity>? entries,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      matches: matches ?? this.matches,
      entries: entries ?? this.entries,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, matches, entries, errorMessage];
}
