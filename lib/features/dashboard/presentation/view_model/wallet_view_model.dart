import 'package:fanup/features/dashboard/domain/entities/wallet_summary_entity.dart';
import 'package:fanup/features/dashboard/domain/usecases/claim_daily_bonus_usecase.dart';
import 'package:fanup/features/dashboard/domain/usecases/get_wallet_summary_usecase.dart';
import 'package:fanup/features/dashboard/domain/usecases/get_wallet_transactions_usecase.dart';
import 'package:fanup/features/dashboard/presentation/state/wallet_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final walletViewModelProvider = NotifierProvider<WalletViewModel, WalletState>(
  WalletViewModel.new,
);

class WalletViewModel extends Notifier<WalletState> {
  late final GetWalletSummaryUsecase _getWalletSummaryUsecase;
  late final GetWalletTransactionsUsecase _getWalletTransactionsUsecase;
  late final ClaimDailyBonusUsecase _claimDailyBonusUsecase;

  @override
  WalletState build() {
    _getWalletSummaryUsecase = ref.read(getWalletSummaryUsecaseProvider);
    _getWalletTransactionsUsecase = ref.read(
      getWalletTransactionsUsecaseProvider,
    );
    _claimDailyBonusUsecase = ref.read(claimDailyBonusUsecaseProvider);
    return const WalletState();
  }

  Future<void> loadWallet({bool showLoading = true}) async {
    if (showLoading) {
      state = state.copyWith(
        status: WalletStatus.loading,
        clearErrorMessage: true,
      );
    } else {
      state = state.copyWith(clearErrorMessage: true);
    }

    final summaryResult = await _getWalletSummaryUsecase();
    final transactionsResult = await _getWalletTransactionsUsecase(
      const GetWalletTransactionsParams(page: 1, size: 20),
    );

    summaryResult.fold(
      (failure) {
        state = state.copyWith(
          status: WalletStatus.error,
          errorMessage: failure.message,
        );
      },
      (summary) {
        transactionsResult.fold(
          (failure) {
            state = state.copyWith(
              status: WalletStatus.error,
              errorMessage: failure.message,
            );
          },
          (transactions) {
            state = state.copyWith(
              status: WalletStatus.loaded,
              summary: summary,
              transactions: transactions,
              clearErrorMessage: true,
            );
          },
        );
      },
    );
  }

  Future<void> claimDailyBonus() async {
    if (state.isClaimingBonus) {
      return;
    }

    state = state.copyWith(
      isClaimingBonus: true,
      clearErrorMessage: true,
      clearInfoMessage: true,
    );

    final result = await _claimDailyBonusUsecase();

    await result.fold(
      (failure) async {
        state = state.copyWith(
          isClaimingBonus: false,
          errorMessage: failure.message,
        );
      },
      (bonusResult) async {
        state = state.copyWith(
          summary: _mergeSummary(bonusResult.summary),
          infoMessage: bonusResult.message,
        );
        await loadWallet(showLoading: false);
        state = state.copyWith(isClaimingBonus: false);
      },
    );
  }

  WalletSummaryEntity _mergeSummary(WalletSummaryEntity summary) {
    return WalletSummaryEntity(
      balance: summary.balance,
      totalCredit: summary.totalCredit,
      totalDebit: summary.totalDebit,
      transactionCount: summary.transactionCount,
      lastTransactionAt: summary.lastTransactionAt,
    );
  }
}
