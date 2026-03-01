import 'package:dartz/dartz.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/features/notifications/domain/entities/notification_entity.dart';

abstract interface class INotificationRepository {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({
    int page,
    int size,
  });

  Future<Either<Failure, void>> markAsRead(String notificationId);

  Future<Either<Failure, void>> markAllAsRead();

  Future<Either<Failure, void>> registerDeviceToken({
    required String token,
    required String platform,
    String? deviceId,
    String? appVersion,
  });

  Future<Either<Failure, void>> unregisterDeviceToken(String token);

  Future<Either<Failure, int>> getUnreadCount();
}
