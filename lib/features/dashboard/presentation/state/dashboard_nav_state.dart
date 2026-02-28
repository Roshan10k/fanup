import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardTabIndexProvider = NotifierProvider<DashboardTabNotifier, int>(
  DashboardTabNotifier.new,
);

class DashboardTabNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setTab(int index) {
    state = index;
  }
}
