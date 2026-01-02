import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:fanup/core/constants/hive_table_constant.dart';
import 'package:fanup/features/auth/data/models/auth_hive_model.dart';
import 'package:path_provider/path_provider.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class HiveService {
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
    // Open a simple box for storing current user ID
    await Hive.openBox('app_data');
  }

  // Close all boxes
  Future<void> close() async {
    await Hive.close();
  }

  // ==================== Auth CRUD Operations ====================
  Box<AuthHiveModel> get _authBox =>
      Hive.box<AuthHiveModel>(HiveTableConstant.authTable);
  
  Box get _appDataBox => Hive.box('app_data');

  Future<AuthHiveModel> registerUser(AuthHiveModel model) async {
    await _authBox.put(model.authId, model);
    return model;
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
  Future<void> logoutUser() async {
    // Remove the current user ID reference
    await _appDataBox.delete('current_user_id');
  }

  // Save Current User ID 
  Future<void> saveCurrentUser(AuthHiveModel user) async {
    // Store only the user ID as reference
    await _appDataBox.put('current_user_id', user.authId);
  }

  // Get Current User by retrieving from the stored ID
  Future<AuthHiveModel?> getCurrentUser() async {
    final currentUserId = _appDataBox.get('current_user_id');
    if (currentUserId == null) return null;
    
    // Get the actual user object from authBox using the ID
    return _authBox.get(currentUserId);
  }

  //is email registered
  Future<bool> isEmailRegistered(String email) async {
    final users = _authBox.values.where((auth) => auth.email == email);
    return users.isNotEmpty;  
  }
}