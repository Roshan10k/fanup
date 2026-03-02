import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fanup/app/app_usecase.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/features/notifications/data/repositories/notification_repository.dart';
import 'package:fanup/features/notifications/domain/repositories/notification_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MarkNotificationAsReadParams extends Equatable {
  final String notificationId;

  const MarkNotificationAsReadParams({required this.notificationId});

  @override
  List<Object?> get props => [notificationId];
}

final markNotificationAsReadUsecaseProvider =
    Provider<MarkNotificationAsReadUsecase>((ref) {
      final repository = ref.read(notificationRepositoryProvider);
      return MarkNotificationAsReadUsecase(repository: repository);
    });

class MarkNotificationAsReadUsecase
    implements UsecaseWithParams<void, MarkNotificationAsReadParams> {
  final INotificationRepository _repository;

  MarkNotificationAsReadUsecase({required INotificationRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, void>> call(MarkNotificationAsReadParams params) {
    return _repository.markAsRead(params.notificationId);
  }
}
