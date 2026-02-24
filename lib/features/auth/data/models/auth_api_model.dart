import 'package:fanup/features/auth/domain/entities/auth_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_api_model.g.dart';

@JsonSerializable(createToJson: false)
class AuthApiModel {
  @JsonKey(
    name: '_id',
    readValue: _readUserValue,
    fromJson: _toNullableString,
  )
  final String? authId;

  @JsonKey(readValue: _readUserValue, fromJson: _toNullableString)
  final String? fullName;

  @JsonKey(readValue: _readUserValue, fromJson: _toNullableString)
  final String? email;

  @JsonKey(fromJson: _toRequiredString, defaultValue: '')
  final String password;

  @JsonKey(readValue: _readTokenValue, fromJson: _toNullableString)
  final String? token;

  @JsonKey(readValue: _readUserValue, fromJson: _toNullableString)
  final String? profilePicture;

  @JsonKey(readValue: _readUserValue, fromJson: _toNullableString)
  final String? phone;

  @JsonKey(readValue: _readUserValue, fromJson: _toDouble)
  final double balance;

  AuthApiModel({
    this.authId,
    this.fullName,
    this.email,
    required this.password,
    this.token,
    this.profilePicture,
    this.phone,
    this.balance = 0.0,
  });

  factory AuthApiModel.fromJson(Map<String, dynamic> json) =>
      _$AuthApiModelFromJson(json);

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
      'confirmPassword': password,
    };
  }

  AuthEntity toEntity() {
    return AuthEntity(
      id: authId,
      fullName: fullName ?? '',
      email: email ?? '',
      password: password,
      profilePicture: profilePicture,
      phone: phone,
      balance: balance,
    );
  }

  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      fullName: entity.fullName,
      email: entity.email,
      password: entity.password,
      profilePicture: entity.profilePicture,
      phone: entity.phone,
      balance: entity.balance,
    );
  }

  static Object? _readUserValue(Map map, String key) {
    final userData = map['data'] ?? map['user'];
    if (userData is Map) {
      return userData[key];
    }
    return null;
  }

  static Object? _readTokenValue(Map map, String key) {
    return map[key];
  }

  static String? _toNullableString(dynamic value) {
    if (value == null) {
      return null;
    }
    return value.toString();
  }

  static String _toRequiredString(dynamic value) {
    return value?.toString() ?? '';
  }

  static double _toDouble(dynamic value) {
    if (value == null) {
      return 0.0;
    }
    if (value is double) {
      return value;
    }
    if (value is int) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }
}
