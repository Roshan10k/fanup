import 'package:equatable/equatable.dart';

class HomeMatchEntity extends Equatable {
  final String id;
  final String league;
  final DateTime startTime;
  final String status;
  final String teamAShortName;
  final String teamBShortName;
  final bool hasExistingEntry;

  const HomeMatchEntity({
    required this.id,
    required this.league,
    required this.startTime,
    required this.status,
    required this.teamAShortName,
    required this.teamBShortName,
    required this.hasExistingEntry,
  });

  String get createLabel => hasExistingEntry ? 'Edit Team' : 'Create Team';

  @override
  List<Object?> get props => [
    id,
    league,
    startTime,
    status,
    teamAShortName,
    teamBShortName,
    hasExistingEntry,
  ];
}
