import 'package:hive/hive.dart';
import 'package:fanup/core/constants/hive_table_constant.dart';
import 'package:fanup/features/auth/data/models/auth_hive_model.dart';
import 'package:path_provider/path_provider.dart';

class HiveServices {
  // Initialize Hive
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/${HiveTableConstant.dbName}';
    Hive.init(path);
    _registerAdapters();
    await _openBoxes();
  }

  // Register all type adapters
  void _registerAdapters() {
    if (!Hive.isAdapterRegistered(HiveTableConstant.authTypeId)) {
      Hive.registerAdapter(AuthHiveModelAdapter());
    }
    //will Add more adapters here in the future
  }

  // Open all boxes
  Future<void> _openBoxes() async {
    await Hive.openBox<AuthHiveModel>(HiveTableConstant.authTable);
  }

  // Close all boxes
  Future<void> close() async {
    await Hive.close();
  }

  // ==================== Auth CRUD Operations ====================
  Box<AuthHiveModel> get _authBox =>
      Hive.box<AuthHiveModel>(HiveTableConstant.authTable);

  Future<AuthHiveModel> registerUser(AuthHiveModel auth) async {
    await _authBox.put(auth.authId, auth);
    return auth;
  }

  //Login 
  Future<AuthHiveModel?> loginUser(String email, String password) async {
    final auths = _authBox.values.where((auth) =>
        auth.email == email && auth.password == password);
    if (auths.isNotEmpty) {
      return auths.first;
    }
    return null;
  }

  //logout
  Future<void> logoutUser(String authId) async {
    await _authBox.delete(authId);
}

  // Get Current User
  Future<AuthHiveModel?> getCurrentUser(String authId) async {
    return _authBox.get(authId);
  }

 
}
