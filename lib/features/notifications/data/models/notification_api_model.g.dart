// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationApiModel _$NotificationApiModelFromJson(
        Map<String, dynamic> json) =>
    NotificationApiModel(
      id: json['id'] == null
          ? ''
          : NotificationApiModel._toRequiredString(json['id']),
      type: json['type'] == null
          ? 'system'
          : NotificationApiModel._toRequiredString(json['type']),
      title: json['title'] == null
          ? ''
          : NotificationApiModel._toRequiredString(json['title']),
      message: json['message'] == null
          ? ''
          : NotificationApiModel._toRequiredString(json['message']),
      referenceId: NotificationApiModel._toNullableString(json['referenceId']),
      referenceType:
          NotificationApiModel._toNullableString(json['referenceType']),
      isRead: json['isRead'] == null
          ? false
          : NotificationApiModel._parseBool(json['isRead']),
      createdAt: NotificationApiModel._parseDateTime(json['createdAt']),
    );

Map<String, dynamic> _$NotificationApiModelToJson(
        NotificationApiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      'message': instance.message,
      'referenceId': instance.referenceId,
      'referenceType': instance.referenceType,
      'isRead': instance.isRead,
      'createdAt': instance.createdAt.toIso8601String(),
    };
