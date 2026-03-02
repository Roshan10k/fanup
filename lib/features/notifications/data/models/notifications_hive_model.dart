import 'package:fanup/core/constants/hive_table_constant.dart';
import 'package:fanup/features/notifications/data/models/notification_api_model.dart';
import 'package:hive/hive.dart';

part 'notifications_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.notificationsHiveTypeId)
class NotificationsHiveModel extends HiveObject {
  @HiveField(0)
  final DateTime storedAt;

  @HiveField(1)
  final List<Map<String, dynamic>> itemsJson;

  @HiveField(2)
  final int unreadCount;

  NotificationsHiveModel({
    required this.storedAt,
    required this.itemsJson,
    required this.unreadCount,
  });

  factory NotificationsHiveModel.fromApiItems({
    required List<NotificationApiModel> items,
    required int unreadCount,
  }) {
    return NotificationsHiveModel(
      storedAt: DateTime.now(),
      itemsJson: items.map((item) => item.toJson()).toList(growable: false),
      unreadCount: unreadCount,
    );
  }

  List<NotificationApiModel> toApiItems() {
    return itemsJson
        .map(
          (item) =>
              NotificationApiModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList(growable: false);
  }

  NotificationsHiveModel copyWith({
    DateTime? storedAt,
    List<Map<String, dynamic>>? itemsJson,
    int? unreadCount,
  }) {
    return NotificationsHiveModel(
      storedAt: storedAt ?? this.storedAt,
      itemsJson: itemsJson ?? this.itemsJson,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
