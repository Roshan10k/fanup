import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/features/notifications/domain/entities/notification_entity.dart';
import 'package:fanup/features/notifications/domain/repositories/notification_repository.dart';
import 'package:fanup/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:fanup/features/notifications/domain/usecases/mark_all_notifications_read_usecase.dart';
import 'package:fanup/features/notifications/domain/usecases/mark_notification_as_read_usecase.dart';
import 'package:fanup/features/notifications/domain/usecases/get_unread_notification_count_usecase.dart';
import 'package:fanup/features/notifications/domain/usecases/register_device_token_usecase.dart';
import 'package:fanup/features/notifications/domain/usecases/unregister_device_token_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationRepository extends Mock
    implements INotificationRepository {}

void main() {
  late MockNotificationRepository mockRepository;

  setUp(() {
    mockRepository = MockNotificationRepository();
  });

  // ---------------------------------------------------------------------------
  // GetNotificationsUsecase
  // ---------------------------------------------------------------------------
  group('GetNotificationsUsecase', () {
    late GetNotificationsUsecase usecase;

    setUp(() {
      usecase = GetNotificationsUsecase(repository: mockRepository);
    });

    test('should return list of notifications on success', () async {
      when(() => mockRepository.getNotifications(page: 1, size: 30))
          .thenAnswer((_) async => const Right(<NotificationEntity>[]));

      final result =
          await usecase(const GetNotificationsParams(page: 1, size: 30));

      expect(result, const Right(<NotificationEntity>[]));
      verify(() => mockRepository.getNotifications(page: 1, size: 30))
          .called(1);
    });

    test('should return failure on error', () async {
      const failure = ApiFailure(message: 'Failed');
      when(() => mockRepository.getNotifications(page: 1, size: 30))
          .thenAnswer((_) async => const Left(failure));

      final result = await usecase(const GetNotificationsParams());

      expect(result, const Left(failure));
    });
  });

  // ---------------------------------------------------------------------------
  // MarkAllNotificationsReadUsecase
  // ---------------------------------------------------------------------------
  group('MarkAllNotificationsReadUsecase', () {
    late MarkAllNotificationsReadUsecase usecase;

    setUp(() {
      usecase = MarkAllNotificationsReadUsecase(repository: mockRepository);
    });

    test('should return void on success', () async {
      when(() => mockRepository.markAllAsRead())
          .thenAnswer((_) async => const Right(null));

      final result = await usecase();

      expect(result.isRight(), true);
      verify(() => mockRepository.markAllAsRead()).called(1);
    });

    test('should return failure on error', () async {
      const failure = ApiFailure(message: 'Failed');
      when(() => mockRepository.markAllAsRead())
          .thenAnswer((_) async => const Left(failure));

      final result = await usecase();

      expect(result, const Left(failure));
    });
  });

  // ---------------------------------------------------------------------------
  // MarkNotificationAsReadUsecase
  // ---------------------------------------------------------------------------
  group('MarkNotificationAsReadUsecase', () {
    late MarkNotificationAsReadUsecase usecase;

    setUp(() {
      usecase = MarkNotificationAsReadUsecase(repository: mockRepository);
    });

    test('should return void on success', () async {
      when(() => mockRepository.markAsRead('notif-1'))
          .thenAnswer((_) async => const Right(null));

      final result = await usecase(
          const MarkNotificationAsReadParams(notificationId: 'notif-1'));

      expect(result.isRight(), true);
      verify(() => mockRepository.markAsRead('notif-1')).called(1);
    });

    test('should pass correct notificationId', () async {
      when(() => mockRepository.markAsRead(any()))
          .thenAnswer((_) async => const Right(null));

      await usecase(
          const MarkNotificationAsReadParams(notificationId: 'notif-xyz'));

      verify(() => mockRepository.markAsRead('notif-xyz')).called(1);
    });
  });

  // ---------------------------------------------------------------------------
  // GetUnreadNotificationCountUsecase
  // ---------------------------------------------------------------------------
  group('GetUnreadNotificationCountUsecase', () {
    late GetUnreadNotificationCountUsecase usecase;

    setUp(() {
      usecase = GetUnreadNotificationCountUsecase(repository: mockRepository);
    });

    test('should return count on success', () async {
      when(() => mockRepository.getUnreadCount())
          .thenAnswer((_) async => const Right(5));

      final result = await usecase();

      expect(result, const Right(5));
      verify(() => mockRepository.getUnreadCount()).called(1);
    });

    test('should return failure on error', () async {
      const failure = ApiFailure(message: 'Failed');
      when(() => mockRepository.getUnreadCount())
          .thenAnswer((_) async => const Left(failure));

      final result = await usecase();

      expect(result, const Left(failure));
    });
  });

  // ---------------------------------------------------------------------------
  // RegisterDeviceTokenUsecase
  // ---------------------------------------------------------------------------
  group('RegisterDeviceTokenUsecase', () {
    late RegisterDeviceTokenUsecase usecase;

    setUp(() {
      usecase = RegisterDeviceTokenUsecase(repository: mockRepository);
    });

    test('should return void on success', () async {
      when(() => mockRepository.registerDeviceToken(
            token: any(named: 'token'),
            platform: any(named: 'platform'),
            deviceId: any(named: 'deviceId'),
            appVersion: any(named: 'appVersion'),
          )).thenAnswer((_) async => const Right(null));

      final result = await usecase(const RegisterDeviceTokenParams(
        token: 'fcm-token',
        platform: 'android',
        deviceId: 'device-123',
        appVersion: '1.0.0',
      ));

      expect(result.isRight(), true);
      verify(() => mockRepository.registerDeviceToken(
            token: 'fcm-token',
            platform: 'android',
            deviceId: 'device-123',
            appVersion: '1.0.0',
          )).called(1);
    });

    test('should return failure on error', () async {
      const failure = ApiFailure(message: 'Failed');
      when(() => mockRepository.registerDeviceToken(
            token: any(named: 'token'),
            platform: any(named: 'platform'),
            deviceId: any(named: 'deviceId'),
            appVersion: any(named: 'appVersion'),
          )).thenAnswer((_) async => const Left(failure));

      final result = await usecase(const RegisterDeviceTokenParams(
        token: 'token',
        platform: 'ios',
      ));

      expect(result, const Left(failure));
    });
  });

  // ---------------------------------------------------------------------------
  // UnregisterDeviceTokenUsecase
  // ---------------------------------------------------------------------------
  group('UnregisterDeviceTokenUsecase', () {
    late UnregisterDeviceTokenUsecase usecase;

    setUp(() {
      usecase = UnregisterDeviceTokenUsecase(repository: mockRepository);
    });

    test('should return void on success', () async {
      when(() => mockRepository.unregisterDeviceToken('fcm-token'))
          .thenAnswer((_) async => const Right(null));

      final result = await usecase(
          const UnregisterDeviceTokenParams(token: 'fcm-token'));

      expect(result.isRight(), true);
      verify(() => mockRepository.unregisterDeviceToken('fcm-token'))
          .called(1);
    });

    test('should return failure on error', () async {
      const failure = ApiFailure(message: 'Token not found');
      when(() => mockRepository.unregisterDeviceToken('invalid'))
          .thenAnswer((_) async => const Left(failure));

      final result = await usecase(
          const UnregisterDeviceTokenParams(token: 'invalid'));

      expect(result, const Left(failure));
    });
  });

  // ---------------------------------------------------------------------------
  // Params equality
  // ---------------------------------------------------------------------------
  group('Params equality', () {
    test('GetNotificationsParams', () {
      const p1 = GetNotificationsParams(page: 1, size: 30);
      const p2 = GetNotificationsParams(page: 1, size: 30);
      expect(p1, p2);
    });

    test('MarkNotificationAsReadParams', () {
      const p1 = MarkNotificationAsReadParams(notificationId: 'a');
      const p2 = MarkNotificationAsReadParams(notificationId: 'a');
      expect(p1, p2);
    });

    test('RegisterDeviceTokenParams', () {
      const p1 =
          RegisterDeviceTokenParams(token: 't', platform: 'ios');
      const p2 =
          RegisterDeviceTokenParams(token: 't', platform: 'ios');
      expect(p1, p2);
    });

    test('UnregisterDeviceTokenParams', () {
      const p1 = UnregisterDeviceTokenParams(token: 't');
      const p2 = UnregisterDeviceTokenParams(token: 't');
      expect(p1, p2);
    });
  });
}
