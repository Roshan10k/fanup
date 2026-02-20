import 'package:dartz/dartz.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/features/dashboard/domain/entities/home_feed_entity.dart';

abstract interface class IDashboardRepository {
  Future<Either<Failure, HomeFeedEntity>> getHomeFeed();
}
