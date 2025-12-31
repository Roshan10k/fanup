import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? id; 
  // optional: null during signup, required after login

  final String fullName;
  final String email;

  const AuthEntity({
    this.id,
    required this.fullName,
    required this.email,
  });

  @override
  List<Object?> get props => [id, fullName, email];
}
