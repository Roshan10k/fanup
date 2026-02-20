import 'package:dartz/dartz.dart';
import 'package:fanup/app/app_usecase.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/features/dashboard/data/repositories/dashboard_repository.dart'
    as dashboard_data;
import 'package:fanup/features/dashboard/domain/entities/home_feed_entity.dart'
    as dashboard_entities;
import 'package:fanup/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getHomeFeedUsecaseProvider = Provider<GetHomeFeedUsecase>((ref) {
  final dashboardRepository =
      ref.read(dashboard_data.dashboardRepositoryProvider);
  return GetHomeFeedUsecase(dashboardRepository: dashboardRepository);
});

class GetHomeFeedUsecase
    implements UsecaseWithoutParams<dashboard_entities.HomeFeedEntity> {
  final IDashboardRepository _dashboardRepository;

  GetHomeFeedUsecase({required IDashboardRepository dashboardRepository})
    : _dashboardRepository = dashboardRepository;

  @override
  Future<Either<Failure, dashboard_entities.HomeFeedEntity>> call() {
    return _dashboardRepository.getHomeFeed();
  }
}
