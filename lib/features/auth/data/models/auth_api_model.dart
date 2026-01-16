import 'package:fanup/features/auth/domain/entities/auth_entity.dart';

class AuthApiModel {
  final String? authId;
  final String fullName;
  final String email;
  final String password;
  final String? token;

  AuthApiModel({
    this.authId,
    required this.fullName,
    required this.email,
    required this.password,
    this.token,
  });

  //Convert API Model to JSON
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
      'confirmPassword': password,
    };
  }

  // Convert JSON to API Model
  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    // Handle both login and registration responses
    final userData = json['user'] ?? json['data'] ?? json;
    final token = json['token'];

    return AuthApiModel(
      authId: userData['_id'] as String?,
      fullName: userData['fullName'] as String,
      email: userData['email'] as String,
      password: '',
      token: token as String,
    );
  }

  // Convert API Model to Entity
  AuthEntity toEntity() {
    return AuthEntity(fullName: fullName, email: email, password: password);
  }

  // Convert Entity to API Model
  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      fullName: entity.fullName,
      email: entity.email,
      password: entity.password,
    );
  }

  // Convert List of API Models to List of Entities
  static List<AuthEntity> toEntityList(List<AuthApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
