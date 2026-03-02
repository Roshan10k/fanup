import 'package:fanup/features/notifications/domain/entities/notification_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_api_model.g.dart';

@JsonSerializable()
class NotificationApiModel {
  @JsonKey(fromJson: _toRequiredString, defaultValue: '')
  final String id;

  @JsonKey(fromJson: _toRequiredString, defaultValue: 'system')
  final String type;

  @JsonKey(fromJson: _toRequiredString, defaultValue: '')
  final String title;

  @JsonKey(fromJson: _toRequiredString, defaultValue: '')
  final String message;

  @JsonKey(fromJson: _toNullableString)
  final String? referenceId;

  @JsonKey(fromJson: _toNullableString)
  final String? referenceType;

  @JsonKey(fromJson: _parseBool, defaultValue: false)
  final bool isRead;

  @JsonKey(fromJson: _parseDateTime)
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

  factory NotificationApiModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationApiModelToJson(this);

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

  static String _toRequiredString(dynamic value) => value?.toString() ?? '';

  static String? _toNullableString(dynamic value) => value?.toString();

  static bool _parseBool(dynamic value) => value == true;

  static DateTime _parseDateTime(dynamic value) =>
      DateTime.tryParse(value?.toString() ?? '') ?? DateTime.now();
}
