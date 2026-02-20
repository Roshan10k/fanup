import 'package:equatable/equatable.dart';
import 'package:fanup/features/dashboard/domain/entities/home_match_entity.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<HomeMatchEntity> matches;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.matches = const [],
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<HomeMatchEntity>? matches,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      matches: matches ?? this.matches,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, matches, errorMessage];
}
