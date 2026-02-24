import 'package:fanup/core/constants/hive_table_constant.dart';
import 'package:fanup/features/auth/domain/entities/auth_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.authTypeId)
class AuthHiveModel extends HiveObject {
  @HiveField(0)
  final String? authId;

  @HiveField(1)
  final String fullName;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String password;

  @HiveField(4)
  final String? profilePicture;

  @HiveField(5)
  final String? phone;

  // FIXED: Changed parameter name from 'userId' to 'authId' for consistency
  AuthHiveModel({
    String? authId,
    required this.fullName,
    required this.email,
    required this.password,
    this.profilePicture,
    this.phone,
  }) : authId = authId ?? const Uuid().v4();

  // Convert Hive Model to User Entity
  AuthEntity toEntity() {
    return AuthEntity(
      id: authId,
      fullName: fullName,
      email: email,
      password: password,
      profilePicture: profilePicture,
      phone: phone,
    );
  }

  // Convert User Entity to Hive Model
  factory AuthHiveModel.fromEntity(AuthEntity entity) {
    return AuthHiveModel(
      authId: entity.id,
      fullName: entity.fullName,
      email: entity.email,
      password: entity.password,
      profilePicture: entity.profilePicture,
      phone: entity.phone,
    );
  }

  // Convert List of Models to List of Entities
  static List<AuthEntity> toEntityList(List<AuthHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
  
  // Helper method to create a copy with updated fields
  AuthHiveModel copyWith({
    String? authId,
    String? fullName,
    String? email,
    String? password,
    String? profilePicture,
    String? phone,
  }) {
    return AuthHiveModel(
      authId: authId ?? this.authId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      profilePicture: profilePicture ?? this.profilePicture,
      phone: phone ?? this.phone,
    );
  }
}