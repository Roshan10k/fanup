import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fanup/app/app_usecase.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/features/notifications/data/repositories/notification_repository.dart';
import 'package:fanup/features/notifications/domain/entities/notification_entity.dart';
import 'package:fanup/features/notifications/domain/repositories/notification_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetNotificationsParams extends Equatable {
  final int page;
  final int size;

  const GetNotificationsParams({this.page = 1, this.size = 30});

  @override
  List<Object?> get props => [page, size];
}

final getNotificationsUsecaseProvider = Provider<GetNotificationsUsecase>((
  ref,
) {
  final repository = ref.read(notificationRepositoryProvider);
  return GetNotificationsUsecase(repository: repository);
});

class GetNotificationsUsecase
    implements
        UsecaseWithParams<List<NotificationEntity>, GetNotificationsParams> {
  final INotificationRepository _repository;

  GetNotificationsUsecase({required INotificationRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, List<NotificationEntity>>> call(
    GetNotificationsParams params,
  ) {
    return _repository.getNotifications(page: params.page, size: params.size);
  }
}
