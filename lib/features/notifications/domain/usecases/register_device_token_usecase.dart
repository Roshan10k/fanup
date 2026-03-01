import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fanup/app/app_usecase.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/features/notifications/data/repositories/notification_repository.dart';
import 'package:fanup/features/notifications/domain/repositories/notification_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterDeviceTokenParams extends Equatable {
  final String token;
  final String platform;
  final String? deviceId;
  final String? appVersion;

  const RegisterDeviceTokenParams({
    required this.token,
    required this.platform,
    this.deviceId,
    this.appVersion,
  });

  @override
  List<Object?> get props => [token, platform, deviceId, appVersion];
}

final registerDeviceTokenUsecaseProvider = Provider<RegisterDeviceTokenUsecase>(
  (ref) {
    final repository = ref.read(notificationRepositoryProvider);
    return RegisterDeviceTokenUsecase(repository: repository);
  },
);

class RegisterDeviceTokenUsecase
    implements UsecaseWithParams<void, RegisterDeviceTokenParams> {
  final INotificationRepository _repository;

  RegisterDeviceTokenUsecase({required INotificationRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, void>> call(RegisterDeviceTokenParams params) {
    return _repository.registerDeviceToken(
      token: params.token,
      platform: params.platform,
      deviceId: params.deviceId,
      appVersion: params.appVersion,
    );
  }
}
