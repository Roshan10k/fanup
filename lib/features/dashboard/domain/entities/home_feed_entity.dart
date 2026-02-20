import 'package:equatable/equatable.dart';
import 'package:fanup/features/dashboard/domain/entities/home_match_entity.dart';

class HomeFeedEntity extends Equatable {
  final List<HomeMatchEntity> matches;

  const HomeFeedEntity({required this.matches});

  @override
  List<Object?> get props => [matches];
}
