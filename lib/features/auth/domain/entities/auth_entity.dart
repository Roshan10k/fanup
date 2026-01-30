import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? id; 
  final String fullName;
  final String email;
  final String password;
  final String? profileImageUrl;

  const AuthEntity({
    this.id,
    required this.fullName,
    required this.email,
    required this.password,
    this.profileImageUrl,
  });

  AuthEntity copyWith({
    String? id,
    String? fullName,
    String? email,
    String? password,
    String? profileImageUrl,
  }) {
    return AuthEntity(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }

  @override
  List<Object?> get props => [id, fullName, email, password, profileImageUrl];
}
