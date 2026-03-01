import 'package:fanup/features/notifications/domain/entities/notification_entity.dart';
import 'package:fanup/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:fanup/features/notifications/domain/usecases/get_unread_notification_count_usecase.dart';
import 'package:fanup/features/notifications/domain/usecases/mark_all_notifications_read_usecase.dart';
import 'package:fanup/features/notifications/domain/usecases/mark_notification_as_read_usecase.dart';
import 'package:fanup/features/notifications/presentation/state/notification_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationViewModelProvider =
    NotifierProvider<NotificationViewModel, NotificationState>(
      NotificationViewModel.new,
    );

class NotificationViewModel extends Notifier<NotificationState> {
  late final GetNotificationsUsecase _getNotificationsUsecase;
  late final GetUnreadNotificationCountUsecase _getUnreadCountUsecase;
  late final MarkNotificationAsReadUsecase _markAsReadUsecase;
  late final MarkAllNotificationsReadUsecase _markAllReadUsecase;

  @override
  NotificationState build() {
    _getNotificationsUsecase = ref.read(getNotificationsUsecaseProvider);
    _getUnreadCountUsecase = ref.read(
      getUnreadNotificationCountUsecaseProvider,
    );
    _markAsReadUsecase = ref.read(markNotificationAsReadUsecaseProvider);
    _markAllReadUsecase = ref.read(markAllNotificationsReadUsecaseProvider);
    return const NotificationState();
  }

  Future<void> load() async {
    state = state.copyWith(
      status: NotificationStatus.loading,
      errorMessage: null,
    );

    final notificationsResult = await _getNotificationsUsecase(
      const GetNotificationsParams(),
    );
    final unreadCountResult = await _getUnreadCountUsecase();

    notificationsResult.fold(
      (failure) {
        state = state.copyWith(
          status: NotificationStatus.error,
          errorMessage: failure.message,
        );
      },
      (items) {
        final unreadCount = unreadCountResult.fold((_) => 0, (count) => count);
        state = state.copyWith(
          status: NotificationStatus.loaded,
          items: items,
          unreadCount: unreadCount,
          errorMessage: null,
        );
      },
    );
  }

  Future<void> refreshUnreadCount() async {
    final result = await _getUnreadCountUsecase();
    result.fold((_) {}, (count) {
      state = state.copyWith(unreadCount: count);
    });
  }

  Future<void> markAllAsRead() async {
    final result = await _markAllReadUsecase();
    result.fold((_) {}, (_) {
      final updated = state.items.map(_asRead).toList(growable: false);
      state = state.copyWith(items: updated, unreadCount: 0);
    });
  }

  Future<void> markAsRead(String notificationId) async {
    final result = await _markAsReadUsecase(
      MarkNotificationAsReadParams(notificationId: notificationId),
    );
    result.fold((_) {}, (_) {
      final updated = state.items
          .map((item) => item.id == notificationId ? _asRead(item) : item)
          .toList(growable: false);

      final unread = updated.where((item) => !item.isRead).length;
      state = state.copyWith(items: updated, unreadCount: unread);
    });
  }

  NotificationEntity _asRead(NotificationEntity item) {
    return NotificationEntity(
      id: item.id,
      type: item.type,
      title: item.title,
      message: item.message,
      referenceId: item.referenceId,
      referenceType: item.referenceType,
      isRead: true,
      createdAt: item.createdAt,
    );
  }
}
