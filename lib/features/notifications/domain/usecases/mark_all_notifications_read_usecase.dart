import 'package:dartz/dartz.dart';
import 'package:fanup/app/app_usecase.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/features/notifications/data/repositories/notification_repository.dart';
import 'package:fanup/features/notifications/domain/repositories/notification_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final markAllNotificationsReadUsecaseProvider =
    Provider<MarkAllNotificationsReadUsecase>((ref) {
      final repository = ref.read(notificationRepositoryProvider);
      return MarkAllNotificationsReadUsecase(repository: repository);
    });

class MarkAllNotificationsReadUsecase implements UsecaseWithoutParams<void> {
  final INotificationRepository _repository;

  MarkAllNotificationsReadUsecase({required INotificationRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, void>> call() {
    return _repository.markAllAsRead();
  }
}
