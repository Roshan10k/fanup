import 'package:dartz/dartz.dart';
import 'package:fanup/app/app_usecase.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/features/notifications/data/repositories/notification_repository.dart';
import 'package:fanup/features/notifications/domain/repositories/notification_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getUnreadNotificationCountUsecaseProvider =
    Provider<GetUnreadNotificationCountUsecase>((ref) {
      final repository = ref.read(notificationRepositoryProvider);
      return GetUnreadNotificationCountUsecase(repository: repository);
    });

class GetUnreadNotificationCountUsecase implements UsecaseWithoutParams<int> {
  final INotificationRepository _repository;

  GetUnreadNotificationCountUsecase({
    required INotificationRepository repository,
  }) : _repository = repository;

  @override
  Future<Either<Failure, int>> call() {
    return _repository.getUnreadCount();
  }
}
