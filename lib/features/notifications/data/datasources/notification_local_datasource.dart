import 'package:fanup/core/services/hive/hive_service.dart';
import 'package:fanup/features/notifications/data/models/notification_api_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationLocalDatasourceProvider =
    Provider<INotificationLocalDataSource>((ref) {
      return NotificationLocalDatasource(
        hiveService: ref.read(hiveServiceProvider),
      );
    });

abstract interface class INotificationLocalDataSource {
  Future<void> saveNotifications({
    required List<NotificationApiModel> items,
    required int unreadCount,
  });

  Future<List<NotificationApiModel>> getNotifications();

  Future<int> getUnreadCount();

  Future<void> markAsRead(String notificationId);

  Future<void> markAllAsRead();
}

class NotificationLocalDatasource implements INotificationLocalDataSource {
  final HiveService _hiveService;

  NotificationLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<void> saveNotifications({
    required List<NotificationApiModel> items,
    required int unreadCount,
  }) async {
    await _hiveService.saveNotifications(
      items: items,
      unreadCount: unreadCount,
    );
  }

  @override
  Future<List<NotificationApiModel>> getNotifications() async {
    final local = _hiveService.getNotifications();
    if (local == null) return const [];
    return local.toApiItems();
  }

  @override
  Future<int> getUnreadCount() async {
    final local = _hiveService.getNotifications();
    return local?.unreadCount ?? 0;
  }

  @override
  Future<void> markAsRead(String notificationId) {
    return _hiveService.updateNotificationReadState(
      notificationId: notificationId,
    );
  }

  @override
  Future<void> markAllAsRead() {
    return _hiveService.updateNotificationReadState(markAll: true);
  }
}
