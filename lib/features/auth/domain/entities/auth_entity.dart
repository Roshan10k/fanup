import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? id; 
  final String fullName;
  final String email;
  final String password;
  final String? profilePicture;
  final String? phone;
  final double balance;

  const AuthEntity({
    this.id,
    required this.fullName,
    required this.email,
    required this.password,
    this.profilePicture,
    this.phone,
    this.balance = 0.0,
  });

  AuthEntity copyWith({
    String? id,
    String? fullName,
    String? email,
    String? password,
    String? profilePicture,
    String? phone,
    double? balance,
  }) {
    return AuthEntity(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      profilePicture: profilePicture ?? this.profilePicture,
      phone: phone ?? this.phone,
      balance: balance ?? this.balance,
    );
  }

  @override
  List<Object?> get props => [id, fullName, email, password, profilePicture, phone, balance];
}
