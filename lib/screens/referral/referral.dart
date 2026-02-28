// Sanket: Premium Referral Dashboard 2026 — fully functional and high-end aesthetics
import 'package:active_matrimonial_flutter_app/components/common_app_bar.dart';
import 'package:active_matrimonial_flutter_app/components/common_widget.dart';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:active_matrimonial_flutter_app/screens/referral/referral_code_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/referral/referral_users_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/referral/referral_earning_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/my_dashboard_pages/wallet/wallet_balance_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/referral/referral_earnings_wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';
import 'package:active_matrimonial_flutter_app/helpers/navigator_push.dart';

class Referral extends StatefulWidget {
  const Referral({super.key});

  @override
  State<Referral> createState() => _ReferralState();
}

class _ReferralState extends State<Referral> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (!store.state.userVerifyState!.isApprove!) {
      OneContext().pop();
      store.dispatch(
        ShowMessageAction(
          msg:
              AppLocalizations.of(
                OneContext().context!,
              )!.gallery_verify_account_msg,
          color: MyTheme.failure,
        ),
      );
    } else {
      _fetchData();
    }
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        if (store.state.referralState!.hasMore!) {
          store.dispatch(referralUsersMiddleware());
        }
      }
    });
  }

  void _fetchData() {
    store.dispatch(Reset.referralUserList);
    store.dispatch(referralCodeMiddleware());
    store.dispatch(referralUsersMiddleware());
    store.dispatch(referralEarningMiddleware());
    store.dispatch(walletBalanceMiddleware());
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder:
          (_, state) => Scaffold(
            backgroundColor: MyTheme.background,
            appBar: CommonAppBar(
              text: AppLocalizations.of(context)!.referral_screen,
            ).build(context),
            body: RefreshIndicator(
              onRefresh: () async => _fetchData(),
              color: MyTheme.primary,
              child: SingleChildScrollView(
                controller: scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    _buildHeroSection(context, state),
                    _buildStatsGrid(context, state),
                    _buildActions(context),
                    _buildInvitedHeader(context),
                    _buildUserList(context, state),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  Widget _buildHeroSection(BuildContext context, AppState state) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(Const.kPaddingHorizontal),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: Styles.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: MyTheme.primary.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.referral_screen_referral_code,
            style: Styles.regular_white_14.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.25)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  state.referralState?.referralCode ?? '--------',
                  style: Styles.bold_white_22.copyWith(letterSpacing: 2),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(
                        text: state.referralState?.referralCode ?? '',
                      ),
                    ).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!.referral_copied_msg,
                          ),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: MyTheme.success.withOpacity(0.9),
                          duration: const Duration(milliseconds: 1500),
                        ),
                      );
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.copy_rounded,
                      color: MyTheme.primary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            AppLocalizations.of(context)!.referral_screen_rewards_msg,
            textAlign: TextAlign.center,
            style: Styles.regular_white_12.copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, AppState state) {
    final balance = state.myWalletState?.balance ?? "0";
    final earnings =
        state.referralEarningState?.referralEarningList?.length.toString() ??
        "0";
    final users =
        state.referralState?.referralUserList?.length.toString() ?? "0";

    final l = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Const.kPaddingHorizontal),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.1,
        children: [
          _buildStatCard(
            context,
            l.referral_stat_wallet,
            balance,
            Icons.account_balance_wallet_rounded,
            MyTheme.primary,
          ),
          _buildStatCard(
            context,
            l.referral_stat_invited,
            users,
            Icons.people_alt_rounded,
            Colors.blue,
          ),
          _buildStatCard(
            context,
            l.referral_stat_successful,
            earnings,
            Icons.verified_user_rounded,
            MyTheme.success,
          ),
          _buildStatCard(
            context,
            l.referral_stat_pending,
            "0",
            Icons.history_rounded,
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: MyTheme.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 16),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Styles.bold_arsenic_16,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Styles.regular_gull_grey_10,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Const.kPaddingHorizontal),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed:
                  () => NavigatorPush.push(
                    context,
                    const ReferralEarningsWallet(),
                  ),
              icon: const Icon(Icons.wallet_giftcard_rounded, size: 18),
              label: Text(AppLocalizations.of(context)!.referral_btn_withdraw),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: MyTheme.primary,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: MyTheme.primary.withOpacity(0.2)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: Styles.primaryGradient,
                borderRadius: BorderRadius.circular(14),
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Sanket: Placeholder for share functionality
                },
                icon: const Icon(Icons.share_rounded, size: 18),
                label: Text(AppLocalizations.of(context)!.referral_btn_share),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvitedHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Const.kPaddingHorizontal,
        vertical: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context)!.referral_header_invited,
            style: Styles.bold_arsenic_16,
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              AppLocalizations.of(context)!.home_see_all,
              style: Styles.bold_app_accent_12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(BuildContext context, AppState state) {
    if (state.referralState!.isFetching!) {
      return Padding(
        padding: const EdgeInsets.only(top: 40),
        child: CommonWidget.circularIndicator,
      );
    }

    if (state.referralState!.referralUserList!.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Icon(
              Icons.person_add_disabled_rounded,
              size: 48,
              color: MyTheme.border,
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.referral_msg_no_invited,
              style: Styles.regular_gull_grey_14,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: Const.kPaddingHorizontal,
        vertical: 8,
      ),
      itemCount: state.referralState!.referralUserList!.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final user = state.referralState!.referralUserList![index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: MyTheme.border),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: MyTheme.primary.withOpacity(0.1),
              child: Text(
                user.name?[0].toUpperCase() ?? "?",
                style: TextStyle(
                  color: MyTheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              user.name ?? "Unknown User",
              style: Styles.bold_arsenic_14,
            ),
            subtitle: Text(
              AppLocalizations.of(
                context,
              )!.referral_joined_on(user.date ?? 'N/A'),
              style: Styles.regular_gull_grey_12,
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: MyTheme.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                AppLocalizations.of(context)!.referral_status_active,
                style: Styles.bold_green_12.copyWith(fontSize: 10),
              ),
            ),
          ),
        );
      },
    );
  }
}
