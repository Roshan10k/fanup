import 'package:fanup/features/dashboard/domain/usecases/get_home_feed_usecase.dart';
import 'package:fanup/features/dashboard/presentation/state/home_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeViewModelProvider = NotifierProvider<HomeViewModel, HomeState>(
  HomeViewModel.new,
);

class HomeViewModel extends Notifier<HomeState> {
  late final GetHomeFeedUsecase _getHomeFeedUsecase;

  @override
  HomeState build() {
    _getHomeFeedUsecase = ref.read(getHomeFeedUsecaseProvider);
    return const HomeState();
  }

  Future<void> loadHomeData() async {
    state = state.copyWith(status: HomeStatus.loading, errorMessage: null);

    final result = await _getHomeFeedUsecase();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: HomeStatus.error,
          errorMessage: failure.message,
        );
      },
      (homeFeed) {
        state = state.copyWith(
          status: HomeStatus.loaded,
          matches: homeFeed.matches,
          entries: homeFeed.entries,
          errorMessage: null,
        );
      },
    );
  }
}
