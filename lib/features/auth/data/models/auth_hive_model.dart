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

  AuthHiveModel({
    String? userId,
    required this.fullName,
    required this.email,
    required this.password,
  }) : authId = userId ?? Uuid().v4();

  // Convert Hive Model to User Entity
  AuthEntity toEntity() {
    return AuthEntity(
      fullName: fullName,
      email: email,
      password: password,
    );
  }

  // Convert User Entity to Hive Model
  factory AuthHiveModel.fromEntity(AuthEntity entity) {
    return AuthHiveModel(
      fullName: entity.fullName,
      email: entity.email,
      password: entity.password,
    );
  }

  // Convert List of Models to List of Entities
  static List<AuthEntity> toEntityList(List<AuthHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
