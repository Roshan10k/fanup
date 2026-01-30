import 'package:fanup/features/auth/domain/entities/auth_entity.dart';

class AuthApiModel {
  final String? authId;
  final String? fullName;
  final String? email;
  final String password;
  final String? token;
  final String? profilePicture; 

  AuthApiModel({
    this.authId,
    this.fullName,
    this.email,
    required this.password,
    this.token,
    this.profilePicture,
  });

  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    final userData = json['data'] ?? json['user'] ?? {};

    return AuthApiModel(
      authId: userData['_id']?.toString(),
      fullName: userData['fullName']?.toString(),
      email: userData['email']?.toString(),
      password: '',
      token: json['token']?.toString(),
      profilePicture: userData['profilePicture']?.toString(), 
    );
  }

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
    );
  }

  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      fullName: entity.fullName,
      email: entity.email,
      password: entity.password,
      profilePicture: entity.profilePicture,
    );
  }
}
