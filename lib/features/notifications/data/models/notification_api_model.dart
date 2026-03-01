import 'package:fanup/features/notifications/domain/entities/notification_entity.dart';

class NotificationApiModel {
  final String id;
  final String type;
  final String title;
  final String message;
  final String? referenceId;
  final String? referenceType;
  final bool isRead;
  final DateTime createdAt;

  const NotificationApiModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.referenceId,
    required this.referenceType,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationApiModel.fromJson(Map<String, dynamic> json) {
    return NotificationApiModel(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? 'system',
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      referenceId: json['referenceId']?.toString(),
      referenceType: json['referenceType']?.toString(),
      isRead: json['isRead'] == true,
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'message': message,
      'referenceId': referenceId,
      'referenceType': referenceType,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      type: type,
      title: title,
      message: message,
      referenceId: referenceId,
      referenceType: referenceType,
      isRead: isRead,
      createdAt: createdAt,
    );
  }
}
