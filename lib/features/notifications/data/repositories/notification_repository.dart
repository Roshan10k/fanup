import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/core/services/connectivity/network_info.dart';
import 'package:fanup/features/notifications/data/datasources/notification_local_datasource.dart';
import 'package:fanup/features/notifications/data/datasources/notification_remote_datasource.dart';
import 'package:fanup/features/notifications/domain/entities/notification_entity.dart';
import 'package:fanup/features/notifications/domain/repositories/notification_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationRepositoryProvider = Provider<INotificationRepository>((ref) {
  return NotificationRepository(
    localDataSource: ref.read(notificationLocalDatasourceProvider),
    remoteDataSource: ref.read(notificationRemoteDatasourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

class NotificationRepository implements INotificationRepository {
  final INotificationLocalDataSource _localDataSource;
  final INotificationRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  NotificationRepository({
    required INotificationLocalDataSource localDataSource,
    required INotificationRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({
    int page = 1,
    int size = 30,
  }) async {
    if (!await _networkInfo.isConnected) {
      final localItems = await _localDataSource.getNotifications();
      return Right(
        localItems.map((item) => item.toEntity()).toList(growable: false),
      );
    }

    try {
      final rows = await _remoteDataSource.getNotifications(
        page: page,
        size: size,
      );
      final unreadCount = rows.where((item) => !item.isRead).length;
      await _localDataSource.saveNotifications(
        items: rows,
        unreadCount: unreadCount,
      );
      return Right(rows.map((item) => item.toEntity()).toList(growable: false));
    } on DioException catch (e) {
      final localItems = await _localDataSource.getNotifications();
      if (localItems.isNotEmpty) {
        return Right(
          localItems.map((item) => item.toEntity()).toList(growable: false),
        );
      }
      return Left(
        ApiFailure(
          message:
              e.response?.data['message']?.toString() ??
              e.message ??
              'Failed to load notifications',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String notificationId) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDataSource.markAsRead(notificationId);
      await _localDataSource.markAsRead(notificationId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              e.response?.data['message']?.toString() ??
              e.message ??
              'Failed to mark notification as read',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead() async {
    if (!await _networkInfo.isConnected) {
      await _localDataSource.markAllAsRead();
      return const Right(null);
    }

    try {
      await _remoteDataSource.markAllAsRead();
      await _localDataSource.markAllAsRead();
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              e.response?.data['message']?.toString() ??
              e.message ??
              'Failed to mark all notifications as read',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> registerDeviceToken({
    required String token,
    required String platform,
    String? deviceId,
    String? appVersion,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDataSource.registerDeviceToken(
        token: token,
        platform: platform,
        deviceId: deviceId,
        appVersion: appVersion,
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              e.response?.data['message']?.toString() ??
              e.message ??
              'Failed to register device token',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> unregisterDeviceToken(String token) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDataSource.unregisterDeviceToken(token);
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              e.response?.data['message']?.toString() ??
              e.message ??
              'Failed to unregister device token',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    if (!await _networkInfo.isConnected) {
      final localUnreadCount = await _localDataSource.getUnreadCount();
      return Right(localUnreadCount);
    }

    try {
      final count = await _remoteDataSource.getUnreadCount();
      final localItems = await _localDataSource.getNotifications();
      if (localItems.isNotEmpty) {
        await _localDataSource.saveNotifications(
          items: localItems,
          unreadCount: count,
        );
      }
      return Right(count);
    } on DioException {
      final localUnreadCount = await _localDataSource.getUnreadCount();
      return Right(localUnreadCount);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
