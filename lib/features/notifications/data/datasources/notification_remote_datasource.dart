import 'package:fanup/core/api/api_client.dart';
import 'package:fanup/core/api/api_endpoints.dart';
import 'package:fanup/features/notifications/data/models/notification_api_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationRemoteDatasourceProvider =
    Provider<INotificationRemoteDataSource>((ref) {
      return NotificationRemoteDatasource(
        apiClient: ref.read(apiClientProvider),
      );
    });

abstract interface class INotificationRemoteDataSource {
  Future<List<NotificationApiModel>> getNotifications({int page, int size});

  Future<void> markAsRead(String notificationId);

  Future<void> markAllAsRead();

  Future<void> registerDeviceToken({
    required String token,
    required String platform,
    String? deviceId,
    String? appVersion,
  });

  Future<void> unregisterDeviceToken(String token);

  Future<int> getUnreadCount();
}

class NotificationRemoteDatasource implements INotificationRemoteDataSource {
  final ApiClient _apiClient;

  NotificationRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<List<NotificationApiModel>> getNotifications({
    int page = 1,
    int size = 30,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.notifications,
      queryParameters: {'page': page, 'size': size},
    );

    final rows = (response.data['data']?['rows'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(NotificationApiModel.fromJson)
        .toList(growable: false);

    return rows;
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await _apiClient.patch(
      '${ApiEndpoints.notifications}/$notificationId/read',
    );
  }

  @override
  Future<void> markAllAsRead() async {
    await _apiClient.patch('${ApiEndpoints.notifications}/read-all');
  }

  @override
  Future<void> registerDeviceToken({
    required String token,
    required String platform,
    String? deviceId,
    String? appVersion,
  }) async {
    await _apiClient.post(
      ApiEndpoints.registerDeviceToken,
      data: {
        'token': token,
        'platform': platform,
        'deviceId': deviceId,
        'appVersion': appVersion,
      },
    );
  }

  @override
  Future<void> unregisterDeviceToken(String token) async {
    await _apiClient.delete(ApiEndpoints.unregisterDeviceToken(token));
  }

  @override
  Future<int> getUnreadCount() async {
    final response = await _apiClient.get(
      ApiEndpoints.notificationsUnreadCount,
    );
    final count = response.data['data']?['count'];
    return int.tryParse('$count') ?? 0;
  }
}
