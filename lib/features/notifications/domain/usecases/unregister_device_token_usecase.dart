import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fanup/app/app_usecase.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/features/notifications/data/repositories/notification_repository.dart';
import 'package:fanup/features/notifications/domain/repositories/notification_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UnregisterDeviceTokenParams extends Equatable {
  final String token;

  const UnregisterDeviceTokenParams({required this.token});

  @override
  List<Object?> get props => [token];
}

final unregisterDeviceTokenUsecaseProvider =
    Provider<UnregisterDeviceTokenUsecase>((ref) {
      final repository = ref.read(notificationRepositoryProvider);
      return UnregisterDeviceTokenUsecase(repository: repository);
    });

class UnregisterDeviceTokenUsecase
    implements UsecaseWithParams<void, UnregisterDeviceTokenParams> {
  final INotificationRepository _repository;

  UnregisterDeviceTokenUsecase({required INotificationRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, void>> call(UnregisterDeviceTokenParams params) {
    return _repository.unregisterDeviceToken(params.token);
  }
}
