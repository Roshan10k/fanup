import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:fanup/core/constants/hive_table_constant.dart';
import 'package:fanup/features/auth/data/models/auth_hive_model.dart';
import 'package:fanup/features/dashboard/data/models/dashboard_home_hive_model.dart';
import 'package:fanup/features/dashboard/data/models/dashboard_wallet_hive_model.dart';
import 'package:fanup/features/dashboard/data/models/wallet_summary_api_model.dart';
import 'package:fanup/features/dashboard/data/models/wallet_transaction_api_model.dart';
import 'package:fanup/features/notifications/data/models/notifications_hive_model.dart';
import 'package:fanup/features/notifications/data/models/notification_api_model.dart';
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
    if (!Hive.isAdapterRegistered(HiveTableConstant.dashboardHomeHiveTypeId)) {
      Hive.registerAdapter(DashboardHomeHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(
      HiveTableConstant.dashboardWalletHiveTypeId,
    )) {
      Hive.registerAdapter(DashboardWalletHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.notificationsHiveTypeId)) {
      Hive.registerAdapter(NotificationsHiveModelAdapter());
    }
  }

  // Open all boxes
  Future<void> _openBoxes() async {
    await Hive.openBox<AuthHiveModel>(HiveTableConstant.authTable);
    await Hive.openBox(HiveTableConstant.appDataTable);
    await Hive.openBox<DashboardHomeHiveModel>(
      HiveTableConstant.dashboardHomeTable,
    );
    await Hive.openBox<DashboardWalletHiveModel>(
      HiveTableConstant.dashboardWalletTable,
    );
    await Hive.openBox<NotificationsHiveModel>(
      HiveTableConstant.notificationsTable,
    );
  }

  // Close all boxes
  Future<void> close() async {
    await Hive.close();
  }

  // ==================== Auth CRUD Operations ====================
  Box<AuthHiveModel> get _authBox =>
      Hive.box<AuthHiveModel>(HiveTableConstant.authTable);

  Box get _appDataBox => Hive.box(HiveTableConstant.appDataTable);
  Box<DashboardHomeHiveModel> get _dashboardHomeBox =>
      Hive.box<DashboardHomeHiveModel>(HiveTableConstant.dashboardHomeTable);
  Box<DashboardWalletHiveModel> get _dashboardWalletBox =>
      Hive.box<DashboardWalletHiveModel>(
        HiveTableConstant.dashboardWalletTable,
      );
  Box<NotificationsHiveModel> get _notificationsBox =>
      Hive.box<NotificationsHiveModel>(HiveTableConstant.notificationsTable);

  Future<AuthHiveModel> registerUser(AuthHiveModel model) async {
    await _authBox.put(model.authId, model);
    return model;
  }

  //Login
  Future<AuthHiveModel?> loginUser(String email, String password) async {
    final auths = _authBox.values.where(
      (auth) => auth.email == email && auth.password == password,
    );
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

  Future<void> putAppData(String key, dynamic value) async {
    await _appDataBox.put(key, value);
  }

  T? getAppData<T>(String key) {
    final value = _appDataBox.get(key);
    if (value is T) {
      return value;
    }
    return null;
  }

  Future<void> deleteAppData(String key) async {
    await _appDataBox.delete(key);
  }

  Future<void> saveDashboardHome(DashboardHomeHiveModel home) async {
    await _dashboardHomeBox.put('latest', home);
  }

  DashboardHomeHiveModel? getDashboardHome() {
    return _dashboardHomeBox.get('latest');
  }

  Future<void> saveDashboardWalletSummary(WalletSummaryApiModel summary) async {
    final existing = _dashboardWalletBox.get('latest');
    final updated =
        (existing ?? DashboardWalletHiveModel(storedAt: DateTime.now()))
            .copyWith(storedAt: DateTime.now(), summaryJson: summary.toJson());
    await _dashboardWalletBox.put('latest', updated);
  }

  Future<void> saveDashboardWalletTransactions(
    List<WalletTransactionApiModel> items,
  ) async {
    final existing = _dashboardWalletBox.get('latest');
    final updated =
        (existing ?? DashboardWalletHiveModel(storedAt: DateTime.now()))
            .copyWith(
              storedAt: DateTime.now(),
              transactionsJson: items
                  .map((e) => e.toJson())
                  .toList(growable: false),
            );
    await _dashboardWalletBox.put('latest', updated);
  }

  WalletSummaryApiModel? getDashboardWalletSummary() {
    return _dashboardWalletBox.get('latest')?.toSummary();
  }

  List<WalletTransactionApiModel>? getDashboardWalletTransactions() {
    final wallet = _dashboardWalletBox.get('latest');
    if (wallet == null) return null;
    return wallet.toTransactions();
  }

  Future<void> saveNotifications({
    required List<NotificationApiModel> items,
    required int unreadCount,
  }) async {
    final notifications = NotificationsHiveModel.fromApiItems(
      items: items,
      unreadCount: unreadCount,
    );
    await _notificationsBox.put('latest', notifications);
  }

  NotificationsHiveModel? getNotifications() {
    return _notificationsBox.get('latest');
  }

  Future<void> updateNotificationReadState({
    String? notificationId,
    bool markAll = false,
  }) async {
    final existing = _notificationsBox.get('latest');
    if (existing == null) return;

    final updatedItems = existing
        .toApiItems()
        .map((item) {
          if (markAll) {
            return NotificationApiModel(
              id: item.id,
              type: item.type,
              title: item.title,
              message: item.message,
              referenceId: item.referenceId,
              referenceType: item.referenceType,
              isRead: true,
              createdAt: item.createdAt,
            );
          }
          if (notificationId != null && item.id == notificationId) {
            return NotificationApiModel(
              id: item.id,
              type: item.type,
              title: item.title,
              message: item.message,
              referenceId: item.referenceId,
              referenceType: item.referenceType,
              isRead: true,
              createdAt: item.createdAt,
            );
          }
          return item;
        })
        .toList(growable: false);

    final unreadCount = updatedItems.where((item) => !item.isRead).length;
    final updated = NotificationsHiveModel.fromApiItems(
      items: updatedItems,
      unreadCount: unreadCount,
    );
    await _notificationsBox.put('latest', updated);
  }
}
