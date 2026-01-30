import 'package:fanup/features/auth/domain/entities/auth_entity.dart';

class AuthApiModel {
  final String? authId;
  final String? fullName;
  final String? email;
  final String password;
  final String? token;
  final String? profileImageUrl;

  AuthApiModel({
    this.authId,
    this.fullName,
    this.email,
    required this.password,
    this.token,
    this.profileImageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
      'confirmPassword': password,
    };
  }

  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    final userData = json['data'] ?? json['user'] ?? {};

    return AuthApiModel(
      authId: userData['_id']?.toString(),
      fullName: userData['fullName']?.toString(),
      email: userData['email']?.toString(),
      password: '',
      token: json['token']?.toString(),
      profileImageUrl: userData['profileImageUrl']?.toString(),
    );
  }

  AuthEntity toEntity() {
    return AuthEntity(
      fullName: fullName ?? '',
      email: email ?? '',
      password: password,
      profileImageUrl: profileImageUrl,
    );
  }

  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      fullName: entity.fullName,
      email: entity.email,
      password: entity.password,
      profileImageUrl: entity.profileImageUrl,
    );
  }
}
