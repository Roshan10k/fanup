import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? id; 
  final String fullName;
  final String email;
  final String password;
  final String? profilePicture; 

  const AuthEntity({
    this.id,
    required this.fullName,
    required this.email,
    required this.password,
    this.profilePicture,
  });

  AuthEntity copyWith({
    String? id,
    String? fullName,
    String? email,
    String? password,
    String? profilePicture,
  }) {
    return AuthEntity(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }

  @override
  List<Object?> get props => [id, fullName, email, password, profilePicture];
}
